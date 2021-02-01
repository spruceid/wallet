import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/pages/profile/module.dart';
import 'package:credible/app/pages/profile/widgets/did_display.dart';
import 'package:credible/app/pages/profile/widgets/menu_item.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:credible/localizations.dart';
import 'package:didkit/didkit.dart';
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
    ProfileModule.to.get<ProfileBloc>().add(ProfileEventLoad());
    ProfileModule.to.get<DIDBloc>().add(DIDEventLoad());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocConsumer(
      cubit: ProfileModule.to.get<ProfileBloc>(),
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
              Center(
                child: Text(
                  '$firstName $lastName',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
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
                onTap: () => Modular.to.pushNamed('/profile/recovery'),
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
              Center(
                child: Text(
                  'DIDKit v' + DIDKit.getVersion(),
                  style: Theme.of(context)
                      .textTheme
                      .overline
                      .apply(color: Palette.greenGrey),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Credible v0.1.0',
                  style: Theme.of(context)
                      .textTheme
                      .caption
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
