import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/document.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:dio/dio.dart';
import 'dart:convert';

// TODO: implement the page for displaying a DID
class DIDDisplayPage extends StatefulWidget {
  final String name;
  final String data;

  const DIDDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  State<DIDDisplayPage> createState() => _DIDDisplayPageState();
}

class _DIDDisplayPageState extends State<DIDDisplayPage> {
  // TODO: determine how to initialize the didModel as it produces an uninitialized exception.
  late DIDModel didModel;

  // TODO: check how to pass the issuer DID of credential into function call
  void get_did(String url) async {
    final client = Dio();
    final Map<String, dynamic> resolutionResult = jsonDecode((await client.get(url)).data);
    setState(() {
      didModel = DIDModel.fromMap(resolutionResult);
    });
  }

  @override
  void initState() {
    super.initState(); //TODO: Add placeholder DIDModel with empty details as this produces error until get_did() is called
    final url = 'http://10.0.2.2:8081/did/${widget.name}';
    get_did(url);
  }

  @override
  Widget build(BuildContext context) {
    final didDocModel = didModel;

    final localizations = AppLocalizations.of(context)!;
    print(widget.name);
    print(widget.data);
    return BasePage(
      title: 'DID Resolution',
      titleLeading: BackLeadingButton(),
      scrollView: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    localizations.didDisplay,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(32.0),
                    child: DIDDocumentWidget(
                      model:
                      DIDDocumentWidgetModel.fromDIDModel(didDocModel)
                      ),
                    
                    // child: QrImage(
                    //   data: data,
                    //   version: QrVersions.auto,
                    //   foregroundColor: UiKit.palette.icon,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
