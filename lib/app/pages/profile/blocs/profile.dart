import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:logging/logging.dart';

abstract class ProfileEvent {}

class ProfileEventLoad extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {
  final ProfileModel model;

  ProfileEventUpdate(this.model);
}

abstract class ProfileState {}

class ProfileStateWorking extends ProfileState {}

class ProfileStateMessage extends ProfileState {
  final StateMessage message;

  ProfileStateMessage(this.message);
}

class ProfileStateDefault extends ProfileState {
  final ProfileModel model;

  ProfileStateDefault(this.model);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileStateDefault(ProfileModel()));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileEventLoad) {
      yield* _load(event);
    } else if (event is ProfileEventUpdate) {
      yield* _update(event);
    }
  }

  Stream<ProfileState> _load(
    ProfileEventLoad event,
  ) async* {
    final log = Logger('credible/profile/load');
    try {
      yield ProfileStateWorking();

      final firstName =
          await SecureStorageProvider.instance.get(ProfileModel.firstNameKey) ??
              '';
      final lastName =
          await SecureStorageProvider.instance.get(ProfileModel.lastNameKey) ??
              '';
      final phone =
          await SecureStorageProvider.instance.get(ProfileModel.phoneKey) ?? '';
      final location =
          await SecureStorageProvider.instance.get(ProfileModel.locationKey) ??
              '';
      final email =
          await SecureStorageProvider.instance.get(ProfileModel.emailKey) ?? '';

      final model = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
      );

      yield ProfileStateDefault(model);
    } catch (e) {
      log.severe('something went wrong', e);

      yield ProfileStateMessage(StateMessage.error('Failed to load profile. '
          'Check the logs for more information.'));
    }
  }

  Stream<ProfileState> _update(
    ProfileEventUpdate event,
  ) async* {
    final log = Logger('credible/profile/update');

    try {
      yield ProfileStateWorking();

      await SecureStorageProvider.instance.set(
        ProfileModel.firstNameKey,
        event.model.firstName,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.lastNameKey,
        event.model.lastName,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.phoneKey,
        event.model.phone,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.locationKey,
        event.model.location,
      );
      await SecureStorageProvider.instance.set(
        ProfileModel.emailKey,
        event.model.email,
      );

      yield ProfileStateDefault(event.model);
    } catch (e) {
      log.severe('something went wrong', e);

      yield ProfileStateMessage(StateMessage.error('Failed to save profile. '
          'Check the logs for more information.'));
    }
  }
}
