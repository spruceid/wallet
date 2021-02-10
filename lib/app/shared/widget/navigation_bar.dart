import 'package:credible/app/shared/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _CustomNavIcon extends StatelessWidget {
  final String asset;

  const _CustomNavIcon({
    Key? key,
    required this.asset,
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
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 24.0,
        height: 24.0,
        child: SvgPicture.asset(
          asset,
          color: Palette.blue,
        ),
      );
}

class CustomNavBar extends BottomNavigationBar {
  final int index;

  static const String assetWallet = 'assets/icon/wallet.svg';
  static const String assetWalletFilled = 'assets/icon/wallet-filled.svg';
  static const String assetQrCode = 'assets/icon/qr-code.svg';
  static const String assetProfile = 'assets/icon/profile.svg';
  static const String assetProfileFilled = 'assets/icon/profile-filled.svg';

  CustomNavBar({
    required this.index,
  }) : super(
          currentIndex: index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            switch (index) {
              case 0:
                Modular.to.pushReplacementNamed('/credentials');
                break;
              case 1:
                Modular.to.pushReplacementNamed('/qr-code/scan');
                break;
              case 2:
                Modular.to.pushReplacementNamed('/profile');
                break;
            }
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Wallet',
              icon: _CustomNavIcon(asset: assetWallet),
              activeIcon: _CustomActiveNavIcon(asset: assetWalletFilled),
            ),
            BottomNavigationBarItem(
              label: 'QR Code',
              icon: _CustomNavIcon(asset: assetQrCode),
              activeIcon: _CustomActiveNavIcon(asset: assetQrCode),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: _CustomNavIcon(asset: assetProfile),
              activeIcon: _CustomActiveNavIcon(asset: assetProfileFilled),
            ),
          ],
        );
}
