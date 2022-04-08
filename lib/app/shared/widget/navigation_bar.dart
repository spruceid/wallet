import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/info_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          color: UiKit.palette.navBarIcon,
        ),
      );
}

class CustomNavBar extends StatelessWidget {
  final int index;

  static const String assetWallet = 'assets/icon/wallet.svg';
  static const String assetWalletFilled = 'assets/icon/wallet-filled.svg';
  static const String assetQrCode = 'assets/icon/qr-code.svg';
  static const String assetProfile = 'assets/icon/profile.svg';
  static const String assetProfileFilled = 'assets/icon/profile-filled.svg';

  const CustomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: UiKit.constraints.navBarPadding,
      decoration: BoxDecoration(
        color: UiKit.palette.navBarBackground,
        borderRadius: UiKit.constraints.navBarRadius,
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        onTap: (newIndex) {
          if (newIndex == index) return;
          switch (newIndex) {
            case 0:
              Modular.to.pushReplacementNamed('/credentials/list');
              break;
            case 1:
              if (kIsWeb) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => InfoDialog(
                    title: 'Unavailable Feature',
                    subtitle: 'This feature is not available on the browser',
                    button: 'Ok',
                  ),
                );
              } else {
                Modular.to.pushReplacementNamed('/qr-code/scan');
              }
              break;
            case 2:
              Modular.to.pushReplacementNamed('/profile/');
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: localizations.credentialDetailListTitle,
            icon: _CustomNavIcon(asset: assetWallet),
            activeIcon: _CustomActiveNavIcon(asset: assetWalletFilled),
          ),
          BottomNavigationBarItem(
            label: 'QR Code',
            icon: _CustomNavIcon(asset: assetQrCode),
            activeIcon: _CustomActiveNavIcon(asset: assetQrCode),
          ),
          BottomNavigationBarItem(
            label: localizations.profileTitle,
            icon: _CustomNavIcon(asset: assetProfile),
            activeIcon: _CustomActiveNavIcon(asset: assetProfileFilled),
          ),
        ],
      ),
    );
  }
}
