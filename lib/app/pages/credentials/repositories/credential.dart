import 'package:credible/app/pages/credentials/database.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sembast/sembast.dart';

class CredentialsRepository extends Disposable {
  CredentialsRepository();

  Future<List<Map<String, dynamic>>> rawFindAll(/* dynamic filters */) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(db);

    return data.map((m) => m.value).toList();
  }

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(db);

    return data.map((m) => CredentialModel.fromMap(m.value)).toList();
  }

  Future<CredentialModel?> findById(String id) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.find(
      db,
      finder: Finder(
        filter: Filter.equals('id', id),
      ),
    );

    if (data.isEmpty) return null;

    return CredentialModel.fromMap(data.first.value);
  }

  Future<int> deleteAll() async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.delete(db);
  }

  Future<bool> deleteById(String id) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    final data = await store.delete(
      db,
      finder: Finder(
        filter: Filter.equals('id', id),
        limit: 1,
      ),
    );

    return data > 0;
  }

  Future<int> insert(CredentialModel credential) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.add(db, credential.toMap());
  }

  Future<int> update(CredentialModel credential) async {
    final db = await WalletDatabase.db;
    final store = intMapStoreFactory.store('credentials');
    return await store.update(
      db,
      credential.toMap(),
      finder: Finder(
        filter: Filter.equals('id', credential.id),
        limit: 1,
      ),
    );
  }

  @override
  void dispose() {}
}
