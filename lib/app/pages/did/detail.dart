// import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/config.dart';
import 'package:credible/app/shared/constants.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/document.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
// No localizations currently on this page
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_modular/flutter_modular.dart';

// Trustchain FFI
import 'package:credible/app/interop/trustchain/trustchain.dart';

// TODO: implement the page for displaying a DID
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
  Future<DIDModel> get_did(String did) async {
    final url =
        (await ffi_config_instance.get_trustchain_endpoint()) + '/did/' + did;
    final url_split = url.split('/');
    final route = '/' + url_split.sublist(1).join('/');
    final uri = Uri.http(url_split[0], route);
    return DIDModel.fromMap(jsonDecode((await http.get(uri)).body));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // No localizations currently on this page
    // final localizations = AppLocalizations.of(context)!;
    // final url = '$base_endpoint${widget.did}';
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
                    // child: FutureBuilder<DIDModel>(

                    child: FutureBuilder<DIDModel>(
                        future: get_did(widget.did),
                        builder: (BuildContext context,
                            // AsyncSnapshot<DIDModel> snapshot) {
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
                                // child: DIDDocumentWidget(
                                //     model: DIDDocumentWidgetModel.fromDIDModel(
                                //         snapshot.data!)));
                                child: JsonViewer((snapshot.data!.toMap())));
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
