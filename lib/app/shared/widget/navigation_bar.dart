import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class _CustomNavIcon extends StatelessWidget {
  final String asset;

  const _CustomNavIcon({
    Key key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 0.33,
        child: _CustomActiveNavIcon(asset: asset),
      );
}

class _CustomActiveNavIcon extends StatelessWidget {
  final String asset;

  const _CustomActiveNavIcon({
    Key key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 24.0,
        height: 24.0,
        child: Image(image: AssetImage(asset)),
      );
}

class CustomNavBar extends BottomNavigationBar {
  final int index;

  static const String assetWallet = 'assets/icon/wallet.png';
  static const String assetQrCode = 'assets/icon/qr-code.png';
  static const String assetProfile = 'assets/icon/profile.png';

  CustomNavBar({
    @required this.index,
  }) : super(
          currentIndex: index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            switch (index) {
              case 1:
                Modular.to.pushNamed('/qr-code/scan');
                break;
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Wallet',
              icon: _CustomNavIcon(asset: assetWallet),
              activeIcon: _CustomActiveNavIcon(asset: assetWallet),
            ),
            BottomNavigationBarItem(
              label: 'QR Code',
              icon: _CustomNavIcon(asset: assetQrCode),
              activeIcon: _CustomActiveNavIcon(asset: assetQrCode),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: _CustomNavIcon(asset: assetProfile),
              activeIcon: _CustomActiveNavIcon(asset: assetProfile),
            ),
          ],
        );
}
