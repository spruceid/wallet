import 'package:credible/app/shared/widget/hero_workaround.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandMinimal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HeroFix(
            tag: 'splash/icon-minimal',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              child: SvgPicture.asset('assets/brand/logo-splash.svg'),
            ),
          ),
        ],
      );
}

class Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HeroFix(
            tag: 'splash/icon',
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.2,
              child: SvgPicture.asset('assets/brand/logo-circular.svg'),
            ),
          ),
          const SizedBox(height: 32.0),
          HeroFix(
            tag: 'splash/title',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset('assets/brand/logo-title.svg'),
                const SizedBox(height: 16.0),
                SvgPicture.asset('assets/brand/logo-subtitle.svg'),
              ],
            ),
          ),
        ],
      );
}
