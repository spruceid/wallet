import 'package:credible/app/pages/profile/blocs/did.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DIDDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                'Your DID is',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: Palette.greenGrey),
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
                    child: Text(
                      did,
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .apply(color: Palette.greenGrey),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                'Copy DID to clipboard',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .apply(color: Palette.greenGrey),
              ),
            ),
          ],
        );
      },
    );
  }
}
