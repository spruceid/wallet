import 'package:credible/app/pages/profile/blocs/profile.dart';
import 'package:credible/app/pages/profile/models/profile.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/base/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalPage extends StatefulWidget {
  final ProfileModel profile;

  const PersonalPage({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.profile.firstName);
    lastNameController = TextEditingController(text: widget.profile.lastName);
    phoneController = TextEditingController(text: widget.profile.phone);
    locationController = TextEditingController(text: widget.profile.location);
    emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BasePage(
      title: localizations.personalTitle,
      titleLeading: BackLeadingButton(),
      titleTrailing: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Modular.get<ProfileBloc>().add(ProfileEventUpdate(ProfileModel(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phone: phoneController.text,
            location: locationController.text,
            email: emailController.text,
          )));
          Modular.to.pop();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Text(
            localizations.personalSave,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .apply(color: UiKit.palette.primary),
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
              localizations.personalSubtitle,
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
            label: localizations.personalFirstName,
            controller: firstNameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: localizations.personalLastName,
            controller: lastNameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: localizations.personalPhone,
            controller: phoneController,
            icon: Icons.phone,
            type: TextInputType.phone,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: localizations.personalLocation,
            controller: locationController,
            icon: Icons.location_pin,
          ),
          const SizedBox(height: 16.0),
          BaseTextField(
            label: localizations.personalMail,
            controller: emailController,
            icon: Icons.email,
            type: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
