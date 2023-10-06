import 'package:credible/app/pages/did/widget/document.dart';
import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTile extends StatelessWidget {
  final DIDDocumentWidgetModel model;
  final String rootEventDate;
  final bool isFirst;
  final bool isLast;

  const CustomTile({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.model,
    required this.rootEventDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Color.fromARGB(255, 7, 111, 10);
    const lineColor = Color.fromARGB(255, 170, 171, 172);
    const lineThickness = 1.5;
    return Container(
        child: TimelineTile(
            alignment: TimelineAlign.end,
            isFirst: isFirst,
            isLast: isLast,
            beforeLineStyle: LineStyle(
              color: lineColor,
              thickness: lineThickness,
            ),
            afterLineStyle: LineStyle(
              color: lineColor,
              thickness: lineThickness,
            ),
            indicatorStyle: IndicatorStyle(
                color: color,
                width: 40,
                height: 40,
                iconStyle: IconStyle(
                    iconData: Icons.done, color: UiKit.palette.credentialText)),
            startChild: HumanFriendlyDIDDocumentWidget(
              model: model,
              rootEventDate: rootEventDate,
              isRoot: isFirst,
            )));
  }
}
