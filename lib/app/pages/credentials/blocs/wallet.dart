import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc extends Disposable {
  final CredentialsRepository repository;

  WalletBloc(this.repository);

  BehaviorSubject<List<CredentialModel>> credentials$ =
      BehaviorSubject<List<CredentialModel>>();

  Future findAll(/* dynamic filters */) async {
    await repository
        .findAll(/* filters */)
        .then((values) => credentials$.add(values));
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
    await findAll();
  }

  @override
  void dispose() {
    credentials$.close();
  }
}
