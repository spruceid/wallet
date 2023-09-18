import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DIDDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer(
      bloc: Modular.get<DIDBloc>(),
      listener: (context, state) {
        if (state is DIDStateMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: state.message.color,
            content: Text(state.message.message),
          ));
        }
      },
      builder: (context, state) {
        final did = state is DIDStateDefault ? state.did : '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                localizations.didDisplayId,
                style: Theme.of(context).textTheme.bodyText2!,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: BaseButton.primary(
                    onPressed: () {
                      Modular.to.pushNamed(
                        '/did/display',
                        arguments: [
                          did,
                        ],
                      );
                    },
                    child: Text(
                      did,
                      style: Theme.of(context).textTheme.overline!,
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 16.0,
                ),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: did));
              },
              child: Text(
                localizations.didDisplayCopy,
                style: Theme.of(context).textTheme.bodyText1!,
              ),
            ),
          ],
        );
      },
    );
  }
}
