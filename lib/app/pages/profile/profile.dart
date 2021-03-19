import 'package:credible/app/interop/didkit/didkit.dart';
import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/pages/profile/widgets/did_display.dart';
import 'package:credible/app/pages/profile/widgets/menu_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/confirm_dialog.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Modular.get<ProfileBloc>().add(ProfileEventLoad());
    Modular.get<DIDBloc>().add(DIDEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: Modular.get<ProfileBloc>(),
      listener: (context, state) {
        if (state is ProfileStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      builder: (context, state) {
        final model =
            state is ProfileStateDefault ? state.model : ProfileModel();
        final firstName = model.firstName;
        final lastName = model.lastName;

        return BasePage(
          backgroundColor: Palette.background,
          title: 'Profile',
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
          ),
          navigation: CustomNavBar(index: 2),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (firstName.isNotEmpty || lastName.isNotEmpty)
                Center(
                  child: Text(
                    '$firstName $lastName',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .apply(color: Palette.greenGrey),
                  ),
                ),
              const SizedBox(height: 32.0),
              MenuItem(
                icon: Icons.person,
                title: 'Personal',
                onTap: () =>
                    Modular.to.pushNamed('/profile/personal', arguments: model),
              ),
              MenuItem(
                icon: Icons.shield,
                title: 'Privacy & Security',
                onTap: () => Modular.to.pushNamed('/profile/privacy'),
              ),
              MenuItem(
                icon: Icons.article,
                title: 'Terms & Conditions',
                onTap: () => Modular.to.pushNamed('/profile/terms'),
              ),
              MenuItem(
                icon: Icons.vpn_key,
                title: 'Recovery',
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Be careful',
                          subtitle:
                              'The recovery page contains sensitive information '
                              'that will compromise your identifier in the wrong '
                              'hands. You should not open this page in public '
                              'or share it with anyone.',
                          yes: 'Continue',
                          no: 'Cancel',
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    await Modular.to.pushNamed('/profile/recovery');
                  }
                },
              ),
              MenuItem(
                icon: Icons.support,
                title: 'Support',
                onTap: () => Modular.to.pushNamed('/profile/support'),
              ),
              MenuItem(
                icon: Icons.assignment_sharp,
                title: 'Notices',
                onTap: () => Modular.to.pushNamed('/profile/notices'),
              ),
              const SizedBox(height: 48.0),
              DIDDisplay(),
              const SizedBox(height: 48.0),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Reset Wallet',
                          subtitle:
                              'Are you sure you want to reset your wallet?',
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    // TODO: Add typing confirmation
                    await SecureStorageProvider.instance.delete('key');
                    await SecureStorageProvider.instance.delete('mnemonic');
                    await SecureStorageProvider.instance.delete('data');

                    await SecureStorageProvider.instance
                        .delete(ProfileModel.firstNameKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.lastNameKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.phoneKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.locationKey);
                    await SecureStorageProvider.instance
                        .delete(ProfileModel.emailKey);

                    final repository = Modular.get<CredentialsRepository>();
                    await repository.deleteAll();

                    await Modular.to.pushReplacementNamed('/splash');
                  }
                },
                child: Text(
                  'Reset wallet',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .apply(color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 48.0),
              Center(
                child: Text(
                  'DIDKit v' + DIDKitProvider.instance.getVersion(),
                  style: Theme.of(context)
                      .textTheme
                      .overline!
                      .apply(color: Palette.greenGrey),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Credible v0.1.0',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .apply(color: Palette.greenGrey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
