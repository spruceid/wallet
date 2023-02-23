import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/document.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';

final log = Logger('MyClassName');

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
  // TODO: refactor into config
  final base_endpoint = 'http://10.0.2.2:8081/did/';

  Future<DIDModel> get_did(String url) async {
    log.severe('\n\n\n\n\n\n********************\n\n\n\n\n\n');
    log.severe(url);
    return DIDModel.fromMap(jsonDecode((await http.get(Uri.parse(url))).body));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final url = '$base_endpoint${widget.name}';
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
                    padding: const EdgeInsets.all(8.0),
                    // See here for FutureBuilder:
                    // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
                    child: FutureBuilder<DIDModel>(
                        future: get_did(url),
                        builder: (BuildContext context,
                            AsyncSnapshot<DIDModel> snapshot) {
                          // Uncomment for waiting part.
                          // if (false) {
                          if (snapshot.hasData) {
                            return DIDDocumentWidget(
                                model: DIDDocumentWidgetModel.fromDIDModel(
                                    snapshot.data!));
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
