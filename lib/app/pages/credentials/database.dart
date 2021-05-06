import 'package:credible/app/shared/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class WalletDatabase {
  WalletDatabase._();

  static Database? _db;

  static Future<Database> get db async {
    return _ensureInitialized();
  }

  static Future<Database> _ensureInitialized() async {
    if (_db == null) {
      if (kIsWeb) {
        _db = await databaseFactoryWeb.openDatabase(Constants.databaseFilename);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        try {
          await dir.create(recursive: true);
          final dbPath = join(dir.path, Constants.databaseFilename);
          _db = await databaseFactoryIo.openDatabase(dbPath);
        } catch (e) {
          throw Exception('Failed to initialize local database');
        }
      }
    }
    return _db!;
  }
}
