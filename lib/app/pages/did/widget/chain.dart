import 'package:credible/app/pages/did/models/chain.dart';
import 'package:credible/app/pages/did/models/did.dart';
import 'package:credible/app/pages/did/widget/item.dart';
import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) => ListView(
        // This is a DID chain widget model?
        children: model.data
            .map((w) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 20, child: DIDDocumentWidget(model: w)),
                      Expanded(
                          flex: 2,
                          child: Icon(Icons.check_circle_rounded,
                              size: 40, color: Color.fromARGB(255, 7, 111, 10)))
                    ],
                  ),
                ))
            .toList(),
      );
}
