import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/config.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:logging/logging.dart';

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
  DIDBloc() : super(DIDStateDefault('')) {
    on<DIDEventLoad>((event, emit) => _load(event).forEach(emit));
  }

  Stream<DIDState> _load(
    DIDEventLoad event,
  ) async* {
    final log = Logger('credible/did/load');

    try {
      yield DIDStateWorking();

      final key = (await SecureStorageProvider.instance.get('key'))!;
      final did_key =
          DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key);
      final did_stored =
          (await SecureStorageProvider.instance.get(ConfigModel.didKey))!;
      final did = did_stored == '' ? did_key : did_stored;
      yield DIDStateDefault(did);
    } catch (e) {
      log.severe('something went wrong', e);

      yield DIDStateMessage(StateMessage.error('Failed to load DID. '
          'Check the logs for more information.'));
    }
  }
}
