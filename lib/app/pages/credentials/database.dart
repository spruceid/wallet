import 'dart:convert';
import 'dart:io';

import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/key_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class _WalletCodec extends AsyncContentCodecBase {
  final String keyAlias;

  _WalletCodec(this.keyAlias);

  @override
  Future<String> encodeAsync(Object? input) async {
    try {
      final data = json.encode(input);

      final encrypted = await KeyManager.encryptPayload(
        keyAlias,
        Uint8List.fromList(data.codeUnits),
      );

      if (encrypted == null) {
        throw DatabaseException.badParam('Failed to encrypt payload.');
      }

      final iv = base64UrlEncode(encrypted.iv);
      final value = base64UrlEncode(encrypted.data);

      return '$iv.$value';
    } catch (e) {
      debugPrint('encodeAsync failed for `${input.runtimeType}` "$input": $e');
      rethrow;
    }
  }

  @override
  Future<Object?> decodeAsync(String input) async {
    try {
      final split = input.split('.');
      assert(split.length == 2);
      final iv = base64Url.decode(split[0]);
      final value = base64Url.decode(split[1]);

      final decrypted = await KeyManager.decryptPayload(keyAlias, iv, value);

      if (decrypted == null) {
        throw DatabaseException.badParam('Failed to decrypt payload.');
      }

      final decoded = json.decode(utf8.decode(decrypted));
      if (decoded is Map) {
        return decoded.cast<String, Object?>();
      }

      return decoded;
    } catch (e) {
      debugPrint('decodeAsync failed for "$input": $e');
      rethrow;
    }
  }
}

class SignatureMismatchException implements Exception {
  const SignatureMismatchException();

  @override
  String toString() => 'SignatureMismatch: signature does not match SE key.';
}

Future<String> _generateSignature(String keyAlias) async => 'se/$keyAlias';

Future<SembastCodec> _codec(String keyAlias) async => SembastCodec(
      signature: await _generateSignature(keyAlias),
      codec: _WalletCodec(keyAlias),
    );

class WalletDatabase {
  WalletDatabase._();

  static Database? _db;

  static Future<Database> get db async {
    return _ensureInitialized();
  }

  static final Mutex _migrationLock = Mutex();

  static Future<Database?> _migrateOpen(String keyAlias) async {
    try {
      await _migrationLock.acquire();

      // Assert directory creation
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, Constants.databaseFilename);

      debugPrint('Listing appdir files');
      Directory(dir.path).listSync().forEach((e) {
        debugPrint('- [appdir] $e');
      });

      final file = File(dbPath);

      // If nothing to migrate, return the database with the new codec.
      if (!file.existsSync()) {
        debugPrint('Database file does not exist, starting fresh');
        return await databaseFactoryIo.openDatabase(
          dbPath,
          codec: await _codec(keyAlias),
        );
      }

      final metadataStr = file.readAsLinesSync().first;
      final metadata = jsonDecode(metadataStr) as Map<String, dynamic>;

      // If codec is already present, open normally
      if (metadata.containsKey('codec')) {
        debugPrint('Codec field is already present, skipping migration');
        return _open(keyAlias);
      }

      // Migration
      debugPrint('Starting migration');

      // Backup the database file and delete the old
      final newPath = join(dir.path, '${Constants.databaseFilename}.migrate');
      final newFile = File(newPath);

      // Ensure previous attempts are deleted
      if (newFile.existsSync()) {
        newFile.deleteSync();
      }

      debugPrint('Open databases');
      // Open both databases
      final oldDb = await databaseFactoryIo.openDatabase(dbPath);
      final newDb = await databaseFactoryIo.openDatabase(
        newPath,
        codec: await _codec(keyAlias),
      );

      debugPrint('Create stores');
      // Create both stores
      final credentialStore = intMapStoreFactory.store('credentials');
      final actionStore = intMapStoreFactory.store('async_credentials');

      debugPrint('Load data');
      // Load all credentials and actions from oldDb
      final credentialEntries = await credentialStore.find(oldDb);
      final actionEntries = await actionStore.find(oldDb);

      debugPrint('Map data');
      // Map data
      final credentialData = credentialEntries.map((m) => m.value).toList();
      final actionData = actionEntries.map((m) => m.value).toList();

      debugPrint('Starting transaction');
      // Create transaction to add all data
      final success = await newDb.transaction((tx) async {
        try {
          debugPrint('- Adding (${credentialData.length}) credentials');
          final ids = await credentialStore.addAll(tx, credentialData);
          debugPrint('- Added (${ids.length}) credentials');
          if (ids.length != credentialData.length) return false;
        } catch (e) {
          debugPrint('Failed to write credentials. Error: $e');
          return false;
        }

        try {
          debugPrint('- Adding (${actionData.length}) actions');
          final ids = await actionStore.addAll(tx, actionData);
          debugPrint('- Added (${ids.length}) actions');
          if (ids.length != actionData.length) return false;
        } catch (e) {
          debugPrint('Failed to write actions. Error: $e');
          return false;
        }

        return true;
      });

      debugPrint('Transaction result: $success');
      if (!success) throw 'Failed to execute transaction';

      debugPrint('Overwriting old database file');
      File(newPath).renameSync(dbPath);

      return newDb;
    } catch (e) {
      throw Exception('Failed to migrateInitialize local database!\nError: $e');
    } finally {
      _migrationLock.release();
    }
  }

  static Future<Database?> _open(String keyAlias) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, Constants.databaseFilename);

      final file = File(dbPath);

      // Verify codec signature is still decoded by the current key
      // to determine if same key that initialized the database is
      // still available in SE.
      final metadataStr = file.readAsLinesSync().first;
      final metadata = jsonDecode(metadataStr) as Map<String, dynamic>;
      final signatureEncrypted = metadata['codec'];
      final codec = _WalletCodec(keyAlias);
      final Object? decoded;
      try {
        decoded = await codec.decodeAsync(signatureEncrypted);
        if (decoded == null) {
          throw 'Failed to decode codec value';
        }
      } catch (_) {
        throw const SignatureMismatchException();
      }
      final signature = (decoded as Map)['signature'];
      final expectedSignature = await _generateSignature(keyAlias);
      if (signature != expectedSignature) {
        throw const SignatureMismatchException();
      }

      return await databaseFactoryIo.openDatabase(
        dbPath,
        codec: await _codec(keyAlias),
      );
    } on SignatureMismatchException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to initialize local database!\nError: $e');
    }
  }

  static Future<Database> _ensureInitialized() async {
    if (_db == null) {
      if (kIsWeb) {
        _db = await databaseFactoryWeb.openDatabase(Constants.databaseFilename);
      } else {
        _db = await _migrateOpen(Constants.defaultAliasEncrypt);
      }
    }
    return _db!;
  }

  static Future<void> delete() async {
    try {
      await _migrationLock.acquire();

      _db = null;

      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, Constants.databaseFilename);
      final dbFile = File(dbPath);

      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }

      await databaseFactoryIo.deleteDatabase(dbPath);
    } catch (e) {
      throw Exception('Failed to delete database!\nError: $e');
    } finally {
      _migrationLock.release();
    }
  }

  static Future<void> unload() async {
    try {
      await _migrationLock.acquire();
      _db = null;
    } catch (e) {
      throw Exception('Failed to unload database!\nError: $e');
    } finally {
      _migrationLock.release();
    }
  }
}
