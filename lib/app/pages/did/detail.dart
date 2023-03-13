// import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/document.dart';
// No localizations currently on this page
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_modular/flutter_modular.dart';

class DIDDisplayPage extends StatefulWidget {
  final String did;

  const DIDDisplayPage({
    Key? key,
    required this.did,
  }) : super(key: key);

  @override
  State<DIDDisplayPage> createState() => _DIDDisplayPageState();
}

class _DIDDisplayPageState extends State<DIDDisplayPage> {
  // TODO: refactor into config
  final base_endpoint = 'http://10.0.2.2:8081/did/';

  Future<DIDModel> get_did(String url) async {
    return DIDModel.fromMap(jsonDecode((await http.get(Uri.parse(url))).body));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // No localizations currently on this page
    // final localizations = AppLocalizations.of(context)!;
    final url = '$base_endpoint${widget.did}';
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
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    // See here for FutureBuilder:
                    // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
                    child: FutureBuilder<DIDModel>(
                        future: get_did(url),
                        builder: (BuildContext context,
                            AsyncSnapshot<DIDModel> snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onPanUpdate: (details) {
                                if (details.delta.dx < 0) {
                                  Modular.to.pushNamed(
                                    '/did/chain',
                                    arguments: [widget.did],
                                  );
                                }
                              },
                              child: DIDDocumentWidget(
                                  model: DIDDocumentWidgetModel.fromDIDModel(
                                      snapshot.data!)),
                            );
                          } else {
                            return Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ));
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
