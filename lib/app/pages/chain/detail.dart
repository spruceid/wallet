import 'package:credible/app/pages/chain/widget/error.dart';
import 'package:credible/app/shared/globals.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/chain/widget/chain.dart';

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
              future: resolveDidChain(widget.did),
              builder: (BuildContext context,
                  AsyncSnapshot<DIDChainModel> snapshot) {
                var message = 'Default message.';
                if (snapshot.hasData) {
                  return DIDChainWidget(
                      model: DIDChainWidgetModel.fromDIDChainModel(
                          snapshot.data!));
                } else if (snapshot.hasError) {
                  message = 'Chain resolution failed';
                  if (snapshot.error is DioError) {
                    message = (snapshot.error as DioError).message;
                  }
                  return CustomErrorWidget(errorMessage: message);
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
