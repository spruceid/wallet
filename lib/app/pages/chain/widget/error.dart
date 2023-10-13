import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  CustomErrorWidget({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80.0),
            child: ExpandablePanel(
                theme: const ExpandableThemeData(
                    hasIcon: false,
                    headerAlignment: ExpandablePanelHeaderAlignment.center),
                header: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50.0,
                    ),
                    Text(
                      'An error occurred!',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                collapsed: SizedBox(),
                expanded: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage.trim(),
                        textScaleFactor: 1.5,
                      ),
                    ],
                  ),
                ))));
  }
}
