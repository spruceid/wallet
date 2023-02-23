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

// // TODO: design distinct presentation of a DID relative to credential
// class DIDChainWidget extends StatelessWidget {
//   final DIDChainWidgetModel model;
//   final Widget? trailing;

//   const DIDChainWidget({
//     Key? key,
//     required this.model,
//     this.trailing,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Container(
//         decoration: BaseBoxDecoration(
//           // TODO: update with different palette for DIDs
//           // color: UiKit.palette.credentialBackground,
//           color: Color.fromARGB(255, 17, 0, 255),
//           // shapeColor: UiKit.palette.credentialDetail.withOpacity(0.2),
//           value: 0.0,
//           shapeSize: 256.0,
//           anchors: <Alignment>[
//             Alignment.topRight,
//             Alignment.bottomCenter,
//           ],
//           // value: animation.value,
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               DocumentItemWidget(
//                 label: 'DID:',
//                 value: model.did,
//               ),
//               const SizedBox(height: 12.0),
//               DocumentItemWidget(label: 'Endpoint:', value: model.endpoint),
//               const SizedBox(height: 12.0),
//             ],
//           ),
//         ),
//       );
// }
