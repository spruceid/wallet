import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/pages/did/models/chain.dart';
import 'package:credible/app/pages/did/widget/chain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DIDChainDisplayPage extends StatefulWidget {
  final String name;
  final String data;

  const DIDChainDisplayPage({
    Key? key,
    required this.name,
    required this.data,
  }) : super(key: key);

  @override
  State<DIDChainDisplayPage> createState() => _DIDChainDisplayPageState();
}

class _DIDChainDisplayPageState extends State<DIDChainDisplayPage> {
  final base_endpoint = 'http://10.0.2.2:8081/did/chain/';

  Future<DIDChainModel> get_did_chain(String url) async {
    return DIDChainModel.fromMap(
        jsonDecode((await http.get(Uri.parse(url))).body));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final url = '$base_endpoint${widget.name}';
    return BasePage(
        title: "Luke's first App",
        titleLeading: BackLeadingButton(),
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DIDChainModel>(
              future: get_did_chain(url),
              builder: (BuildContext context,
                  AsyncSnapshot<DIDChainModel> snapshot) {
                if (snapshot.hasData) {
                  final didChain =
                      DIDChainWidgetModel.fromDIDChainModel(snapshot.data!);
                  return ListView(
                    children: didChain.data
                        .map((w) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 20,
                                      child: DIDDocumentWidget(model: w)),
                                  Expanded(
                                      flex: 2,
                                      child: Icon(Icons.check_circle_rounded,
                                          size: 40,
                                          color:
                                              Color.fromARGB(255, 7, 111, 10)))
                                ],
                              ),
                            ))
                        .toList(),
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
        ));
  }
}
