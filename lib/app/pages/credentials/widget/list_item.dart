import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:credible/app/shared/palette.dart';
import 'package:credible/app/shared/widget/base/box_decoration.dart';
import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:credible/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class _BaseItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  const _BaseItem({
    Key key,
    @required this.child,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  __BaseItemState createState() => __BaseItemState();
}

class __BaseItemState extends State<_BaseItem>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(minutes: 4),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.0, end: 360.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.forward(from: 0.0);
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: !widget.enabled ? 0.33 : 1.0,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              color: Palette.darkGreen,
              shapeColor: Palette.gradientLightGreen.withOpacity(0.2),
              value: animation.value,
              anchors: <Alignment>[
                Alignment.bottomRight,
              ],
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Palette.shadow,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 2.0,
                ),
              ],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: child,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IntrinsicHeight(child: widget.child),
              ),
            ),
          ),
        ),
      );
}

class _LabeledItem extends StatelessWidget {
  final String icon;
  final String label;
  final String hero;
  final String value;

  const _LabeledItem({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.hero,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.6,
            child: SvgPicture.asset(
              icon,
              width: 18.0,
              height: 18.0,
            ),
          ),
          // Text(
          //   label,
          //   style: TextStyle(
          //     color: Colors.black38,
          //     fontSize: 10.0,
          //   ),
          // ),
          const SizedBox(width: 4.0),
          Expanded(
            child: TooltipText(
              tag: hero,
              text: value,
              tooltip: '$label $value',
              style: GoogleFonts.poppins(
                color: Palette.text,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}

class CredentialsListItem extends StatelessWidget {
  final CredentialModel item;

  CredentialsListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _BaseItem(
        enabled: !(item.status != CredentialStatus.active),
        onTap: () => Modular.to.pushNamed(
          '/credentials/detail',
          arguments: item,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Palette.text,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: HeroFix(
                tag: 'credential/${item.id}/icon',
                child: Icon(
                  Icons.domain,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TooltipText(
                    tag: 'credential/${item.id}/id',
                    text: item.id,
                    style: GoogleFonts.poppins(
                      color: Palette.text,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _LabeledItem(
                            icon: 'assets/icon/location-target.svg',
                            label: 'Issued by:',
                            hero: 'credential/${item.id}/issuer',
                            value: item.issuer,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _LabeledItem(
                            icon: 'assets/icon/time-clock.svg',
                            label: 'Valid thru:',
                            hero: 'credential/${item.id}/valid',
                            value: '01/22',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
