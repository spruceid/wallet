import 'package:flutter/material.dart';

class HeroFix extends StatelessWidget {
  final String tag;
  final Widget child;

  const HeroFix({
    Key key,
    this.tag,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
        tag: tag,
        child: child,
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) =>
            Material(
          color: Colors.transparent,
          child: toHeroContext.widget,
        ),
      );
}
