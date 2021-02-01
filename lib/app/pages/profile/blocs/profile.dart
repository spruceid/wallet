import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/shared/model/message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    try {
      yield ProfileStateWorking();

      final storage = FlutterSecureStorage();

      final firstName =
          await storage.read(key: ProfileModel.firstNameKey) ?? '';
      final lastName = await storage.read(key: ProfileModel.lastNameKey) ?? '';
      final phone = await storage.read(key: ProfileModel.phoneKey) ?? '';
      final location = await storage.read(key: ProfileModel.locationKey) ?? '';
      final email = await storage.read(key: ProfileModel.emailKey) ?? '';

      final model = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
      );

      yield ProfileStateDefault(model);
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/profile/load',
        error: e.message,
      );

      yield ProfileStateMessage(StateMessage.error('Failed to load profile. '
          'Check the logs for more information.'));
    }
  }

  Stream<ProfileState> _update(
    ProfileEventUpdate event,
  ) async* {
    try {
      yield ProfileStateWorking();

      final storage = FlutterSecureStorage();

      await storage.write(
        key: ProfileModel.firstNameKey,
        value: event.model.firstName,
      );

      await storage.write(
        key: ProfileModel.lastNameKey,
        value: event.model.lastName,
      );
      await storage.write(
        key: ProfileModel.phoneKey,
        value: event.model.phone,
      );
      await storage.write(
        key: ProfileModel.locationKey,
        value: event.model.location,
      );
      await storage.write(
        key: ProfileModel.emailKey,
        value: event.model.email,
      );

      yield ProfileStateDefault(event.model);
    } catch (e) {
      log(
        'something went wrong',
        name: 'credible/profile/update',
        error: e.message,
      );

      yield ProfileStateMessage(StateMessage.error('Failed to save profile. '
          'Check the logs for more information.'));
    }
  }
}
