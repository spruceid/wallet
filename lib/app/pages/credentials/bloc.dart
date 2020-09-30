import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CredentialsBloc extends Disposable {
  final CredentialsRepository repository;

  CredentialsBloc(this.repository);

  BehaviorSubject<List<CredentialModel>> credentials$ =
      BehaviorSubject<List<CredentialModel>>();

  Future findAll(/* dynamic filters */) async {
    repository
        .findAll(/* filters */)
        .then((values) => credentials$.add(values));
  }

  @override
  void dispose() {
    credentials$.close();
  }
}
