import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/config.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/chain/widget/chain.dart';
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
  Future<DIDChainModel> get_did_chain(String did) async {
    final endpoint = (await ffi_config_instance.get_trustchain_endpoint());
    final route = '/did/chain/' + did;
    final queryParams = {
      'root_event_time':
          (await ffi_config_instance.get_root_event_time()).toString(),
    };
    final uri =
        Uri.parse(endpoint + route).replace(queryParameters: queryParams);
    return DIDChainModel.fromMap((await Dio().getUri(uri)).data);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BasePage(
        title: 'DID chain',
        titleLeading: BackLeadingButton(),
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DIDChainModel>(
              future: get_did_chain(widget.did),
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
