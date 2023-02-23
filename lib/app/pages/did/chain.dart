import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/back_leading_button.dart';
import 'package:credible/app/shared/widget/base/page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:credible/app/pages/did/models/chain.dart';
import 'package:credible/app/pages/did/widget/chain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'dart:developer';

final log = Logger('MyClassName');

// TODO: implement the page for displaying a chain

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
    print('\n\n\n\n*********\n\n\n\n');
    // log.severe(url);
    // log.severe((await http.get(Uri.parse(url))).body);

    print(jsonDecode((await http.get(Uri.parse(url))).body));
    // print(
    //     (jsonDecode((await http.get(Uri.parse(url))).body) as Type).toString());
    print('\n============\n');
    return DIDChainModel.fromMap(
        jsonDecode((await http.get(Uri.parse(url))).body));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // final items = List<String>.generate(5, (i) => 'Item $i');
    final url = '$base_endpoint${widget.name}';
    return BasePage(
        title: ' ',
        titleLeading: BackLeadingButton(),
        scrollView: false,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          // See here for FutureBuilder:
          // https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
          child: FutureBuilder<DIDChainModel>(
              future: get_did_chain(url),
              builder: (BuildContext context,
                  AsyncSnapshot<DIDChainModel> snapshot) {
                // Uncomment for waiting part.
                // if (false) {
                print('-------------------');
                print(snapshot.error);
                print('*******************');
                if (snapshot.hasData) {
                  log.severe(snapshot);
                  final didChain =
                      DIDChainWidgetModel.fromDIDChainModel(snapshot.data!);
                  return ListView(children: [
                    for (var widg in didChain.data)
                      DIDDocumentWidget(model: widg)
                    // ListTile(title: Text('Thing 1')),
                    // ListTile(title: Text('Thing 2'))
                  ]
                      // children: DIDChainWidgetModel.fromDIDChainModel(
                      //     model: DIDChainModel.fromMap(snapshot.didChain!))
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
        // body: ListView.builder(
        //   itemCount: items.length,
        //   prototypeItem: ListTile(
        //     title: Text(items.first),
        //   ),
        //   itemBuilder: (context, index) {

        //     return ListTile(
        //       title: Text(items[index]),
        //     );
        //   },
        // ),
        // body: Column(
        //   children: [
        //     Expanded(
        //       child: Center(
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text(
        //               localizations.qrCodeSharing,
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.bodyText1,
        //             ),
        //             const SizedBox(height: 4.0),
        //             Text(
        //               name,
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.caption,
        //             ),
        //             Container(
        //               alignment: Alignment.center,
        //               padding: const EdgeInsets.all(32.0),
        //               child: QrImage(
        //                 data: data,
        //                 version: QrVersions.auto,
        //                 foregroundColor: UiKit.palette.icon,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
