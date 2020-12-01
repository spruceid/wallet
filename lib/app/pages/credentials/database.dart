import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class WalletDatabase {
  WalletDatabase._();

  static Database _db;

  static Future<Database> get db async {
    return _ensureInitialized();
  }

  static Future<Database> _ensureInitialized() async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      final dbPath = join(dir.path, 'wallet.db');
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
    return _db;
  }
}
