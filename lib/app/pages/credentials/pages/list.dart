import 'package:credible/app/pages/credentials/blocs/scan.dart';
import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/widget/list_item.dart';
import 'package:credible/app/shared/web_share.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:credible/app/shared/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsList extends StatefulWidget {
  final List<CredentialModel> items;

  const CredentialsList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<CredentialsList> createState() => _CredentialsListState();
}

class _CredentialsListState extends State<CredentialsList>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // This will initialize on first app start.
    WebShare.verifyWebShare(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isForeground = state == AppLifecycleState.resumed;

    // This will initialize when app returns from the background.
    if (isForeground) {
      WebShare.verifyWebShare(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener(
      bloc: Modular.get<ScanBloc>(),
      listener: (context, state) {
        if (state is ScanStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      child: BasePage(
        title: localizations.credentialListTitle,
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        navigation: CustomNavBar(index: 0),
        body: Column(
          children: List.generate(
            widget.items.length,
            (index) => CredentialsListItem(item: widget.items[index]),
          ),
        ),
      ),
    );
  }
}
