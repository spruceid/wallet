import 'package:credible/app/pages/chain/models/chain.dart';
import 'package:credible/app/pages/did/widget/document.dart';
import 'package:flutter/material.dart';

class DIDChainWidgetModel {
  final List<DIDDocumentWidgetModel> data;

  const DIDChainWidgetModel(this.data);

  factory DIDChainWidgetModel.fromDIDChainModel(DIDChainModel model) {
    return DIDChainWidgetModel(model.didChain
        .map((m) => DIDDocumentWidgetModel.fromDIDModel(m))
        .toList());
  }
}

class DIDChainWidget extends StatelessWidget {
  final DIDChainWidgetModel model;
  final Widget? trailing;

  const DIDChainWidget({
    Key? key,
    required this.model,
    this.trailing,
  }) : super(key: key);

  Widget customChain(DIDDocumentWidgetModel documentWidget, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 20,
              child: HumanFriendlyDIDDocumentWidget(
                model: documentWidget,
              )),
          Expanded(flex: 1, child: SizedBox(width: 0, height: 0)),
          Expanded(
              flex: 2,
              child: Icon(Icons.check_circle_rounded,
                  size: 40, color: Color.fromARGB(255, 7, 111, 10)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
      children: model.data
              .take(1)
              .map((w) => customChain(w, Color.fromARGB(255, 175, 4, 242)))
              .toList() +
          model.data.skip(1).map((w) => customChain(w)).toList());
}
