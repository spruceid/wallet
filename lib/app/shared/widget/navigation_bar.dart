import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavBar extends BottomNavigationBar {
  final int index;

  CustomNavBar({
    @required this.index,
  }) : super(
          currentIndex: index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Container(),
              icon: Icon(Icons.credit_card),
            ),
            BottomNavigationBarItem(
              title: Container(),
              icon: FaIcon(FontAwesomeIcons.qrcode, size: 16.0),
            ),
            BottomNavigationBarItem(
              title: Container(),
              icon: Icon(Icons.account_circle),
            ),
          ],
        );
}
