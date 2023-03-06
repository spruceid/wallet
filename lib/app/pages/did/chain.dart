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
  final String did;

  const DIDChainDisplayPage({
    Key? key,
    required this.did,
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
    final url = '$base_endpoint${widget.did}';
    return BasePage(
        title: 'DID Trustchain',
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
                  return DIDChainWidget(
                      model: DIDChainWidgetModel.fromDIDChainModel(
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
        ));
  }
}
