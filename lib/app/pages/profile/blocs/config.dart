import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/config.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:logging/logging.dart';

abstract class ConfigEvent {}

class ConfigEventLoad extends ConfigEvent {}

class ConfigEventUpdate extends ConfigEvent {
  final ConfigModel model;

  ConfigEventUpdate(this.model);
}

abstract class ConfigState {}

class ConfigStateWorking extends ConfigState {}

class ConfigStateMessage extends ConfigState {
  final StateMessage message;

  ConfigStateMessage(this.message);
}

class ConfigStateDefault extends ConfigState {
  final ConfigModel model;

  ConfigStateDefault(this.model);
}

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  ConfigBloc() : super(ConfigStateDefault(ConfigModel())) {
    on<ConfigEventLoad>((event, emit) => _load(event).forEach(emit));
    on<ConfigEventUpdate>((event, emit) => _update(event).forEach(emit));
  }

  Stream<ConfigState> _load(
    ConfigEventLoad event,
  ) async* {
    final log = Logger('credible/config/load');
    try {
      yield ConfigStateWorking();

      final did =
          await SecureStorageProvider.instance.get(ConfigModel.didKey) ?? '';
      final trustchainEndpoint = await SecureStorageProvider.instance
              .get(ConfigModel.trustchainEndpointKey) ??
          '';
      final rootEventDate = await SecureStorageProvider.instance
              .get(ConfigModel.rootEventDateKey) ??
          '';
      final confirmationCode = await SecureStorageProvider.instance
              .get(ConfigModel.confirmationCodeKey) ??
          '';
      final rootDid =
          await SecureStorageProvider.instance.get(ConfigModel.rootDidKey) ??
              '';
      final rootTxid =
          await SecureStorageProvider.instance.get(ConfigModel.rootTxidKey) ??
              '';
      final rootBlockHeight = await SecureStorageProvider.instance
              .get(ConfigModel.rootBlockHeightKey) ??
          '';
      final rootEventTime = await SecureStorageProvider.instance
              .get(ConfigModel.rootEventTimeKey) ??
          '';

      final model = ConfigModel(
        did: did,
        trustchainEndpoint: trustchainEndpoint,
        rootEventDate: rootEventDate,
        confirmationCode: confirmationCode,
        rootDid: rootDid,
        rootTxid: rootTxid,
        rootBlockHeight: rootBlockHeight,
        rootEventTime: rootEventTime,
      );

      yield ConfigStateDefault(model);
    } catch (e) {
      log.severe('something went wrong', e);

      yield ConfigStateMessage(StateMessage.error('Failed to load config. '
          'Check the logs for more information.'));
    }
  }

  Stream<ConfigState> _update(
    ConfigEventUpdate event,
  ) async* {
    final log = Logger('credible/config/update');

    try {
      yield ConfigStateWorking();

      final key = await SecureStorageProvider.instance.get('key');
      final did = event.model.did != ''
          ? event.model.did
          : DIDKitProvider.instance.keyToDID(Constants.defaultDIDMethod, key!);
      await SecureStorageProvider.instance.set(
        ConfigModel.didKey,
        did,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.trustchainEndpointKey,
        event.model.trustchainEndpoint,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootEventDateKey,
        event.model.rootEventDate,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.confirmationCodeKey,
        event.model.confirmationCode,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootDidKey,
        event.model.rootDid,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootTxidKey,
        event.model.rootTxid,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootBlockHeightKey,
        event.model.rootBlockHeight,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootEventTimeKey,
        event.model.rootEventTime,
      );

      yield ConfigStateDefault(event.model);
    } catch (e) {
      log.severe('something went wrong', e);

      yield ConfigStateMessage(StateMessage.error('Failed to save config. '
          'Check the logs for more information.'));
    }
  }
}
