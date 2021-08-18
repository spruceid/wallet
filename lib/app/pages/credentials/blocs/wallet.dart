import 'dart:async';

import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc extends Disposable {
  final CredentialsRepository repository;

  late StreamSubscription subscription;

  WalletBloc(this.repository) {
    subscription = repository.observeAll().listen((values) {
      credentials$.add(values);
    });
  }

  BehaviorSubject<List<CredentialModel>> credentials$ =
      BehaviorSubject<List<CredentialModel>>();

  Future findAll(/* dynamic filters */) async {
    await repository.findAll(/* filters */);
  }

  Future deleteById(String id) async {
    await repository.deleteById(id);
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
  }

  @override
  void dispose() {
    credentials$.close();
    unawaited(subscription.cancel());
  }
}
