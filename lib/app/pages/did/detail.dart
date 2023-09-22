// import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/config.dart';
import 'package:credible/app/shared/globals.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
// No localizations currently on this page
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                    child: FutureBuilder<DIDModel>(
                        future: resolveDid(widget.did),
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
                                // TODO [#22]: consider reverting to the same widget
                                // as used in DID Chain (i.e. expandable JSON Viewer)
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
