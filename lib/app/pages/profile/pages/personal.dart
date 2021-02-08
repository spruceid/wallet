import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/pages/profile/module.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/base/text_field.dart';
import 'package:credible/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PersonalPage extends StatefulWidget {
  final ProfileModel profile;

  const PersonalPage({
    Key key,
    @required this.profile,
  }) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController phoneController;
  TextEditingController locationController;
  TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    firstNameController =
        TextEditingController(text: widget.profile.firstName ?? '');

    lastNameController =
        TextEditingController(text: widget.profile.lastName ?? '');

    phoneController = TextEditingController(text: widget.profile.phone ?? '');

    locationController =
        TextEditingController(text: widget.profile.location ?? '');

    emailController = TextEditingController(text: widget.profile.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BasePage(
      title: 'Personal',
      titleLeading: BackLeadingButton(),
      titleTrailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text.rich(
          TextSpan(
            text: 'Save',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .apply(color: Palette.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ProfileModule.to
                    .get<ProfileBloc>()
                    .add(ProfileEventUpdate(ProfileModel(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      location: locationController.text,
                      email: emailController.text,
                    )));
                Modular.to.pop();
              },
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Your profile data can be used to fill credentials when applicable',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          // Center(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.2,
          //     height: MediaQuery.of(context).size.width * 0.2,
          //     decoration: BoxDecoration(
          //       color: Colors.pink,
          //       borderRadius: BorderRadius.circular(16.0),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 32.0),
          BaseTextField(
            label: 'First Name',
            controller: firstNameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: 'Last Name',
            controller: lastNameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: 'Phone',
            controller: phoneController,
            icon: Icons.phone,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: 'Location',
            controller: locationController,
            icon: Icons.location_pin,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: 'E-mail',
            controller: emailController,
            icon: Icons.email,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
