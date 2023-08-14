import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/config.dart';
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
      final rootEventTime = await SecureStorageProvider.instance
              .get(ConfigModel.rootEventTimeKey) ??
          '';
      final ionEndpoint = await SecureStorageProvider.instance
              .get(ConfigModel.ionEndpointKey) ??
          '';
      final trustchainEndpoint = await SecureStorageProvider.instance
              .get(ConfigModel.trustchainEndpointKey) ??
          '';
      final model = ConfigModel(
        did: did,
        rootEventTime: rootEventTime,
        ionEndpoint: ionEndpoint,
        trustchainEndpoint: trustchainEndpoint,
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

      await SecureStorageProvider.instance.set(
        ConfigModel.didKey,
        event.model.did,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.rootEventTimeKey,
        event.model.rootEventTime,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.ionEndpointKey,
        event.model.ionEndpoint,
      );
      await SecureStorageProvider.instance.set(
        ConfigModel.trustchainEndpointKey,
        event.model.trustchainEndpoint,
      );

      yield ConfigStateDefault(event.model);
    } catch (e) {
      log.severe('something went wrong', e);

      yield ConfigStateMessage(StateMessage.error('Failed to save config. '
          'Check the logs for more information.'));
    }
  }
}
