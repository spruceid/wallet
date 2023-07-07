import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/chain/widget/chain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:credible/app/shared/constants.dart';

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
  final base_endpoint = '10.0.2.2:8081/did/chain/';

  Future<DIDChainModel> get_did_chain(String url) async {
    final queryParams = {
      'root_event_time': Constants.rootEventTime.toString(),
    };
    final url_split = url.split('/');
    final uri =
        Uri.http(url_split[0], url_split.sublist(1).join('/'), queryParams);
    return DIDChainModel.fromMap(jsonDecode((await http.get(uri)).body));
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
