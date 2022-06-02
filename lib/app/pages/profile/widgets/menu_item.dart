import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class MyMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MyMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: UiKit.palette.lightBorder),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24.0,
                  color: UiKit.palette.icon,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1!,
                  ),
                ),
                const SizedBox(width: 16.0),
                Icon(
                  Icons.chevron_right,
                  size: 24.0,
                  color: UiKit.palette.icon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
