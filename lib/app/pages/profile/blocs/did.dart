import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';

abstract class DIDEvent {}

class DIDEventLoad extends DIDEvent {}

abstract class DIDState {}

class DIDStateWorking extends DIDState {}

class DIDStateMessage extends DIDState {
  final StateMessage message;

  DIDStateMessage(this.message);
}

class DIDStateDefault extends DIDState {
  final String did;

  DIDStateDefault(this.did);
}

class DIDBloc extends Bloc<DIDEvent, DIDState> {
  DIDBloc() : super(DIDStateDefault(''));

  @override
  Stream<DIDState> mapEventToState(DIDEvent event) async* {
    if (event is DIDEventLoad) {
      yield* _load(event);
    }
  }

  Stream<DIDState> _load(
    DIDEventLoad event,
  ) async* {
    try {
      yield DIDStateWorking();

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final did = await DIDKitProvider.instance
          .keyToDID(Constants.defaultDIDMethod, key);

      yield DIDStateDefault(did);
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/did/load',
        error: e,
      );

      yield DIDStateMessage(StateMessage.error('Failed to load DID. '
          'Check the logs for more information.'));
    }
  }
}
