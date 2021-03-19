import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentTicketSeparator extends StatelessWidget {
  const DocumentTicketSeparator();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-8.0, 0.0),
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: UiKit.palette.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(8.0, 0.0),
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: UiKit.palette.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
