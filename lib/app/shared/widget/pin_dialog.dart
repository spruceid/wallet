import 'package:credible/app/shared/ui/ui.dart';
import 'package:credible/app/shared/widget/base/button.dart';
import 'package:credible/app/shared/widget/base/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PinDialog extends StatefulWidget {
  final String title;

  const PinDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: UiKit.palette.appBarBackground,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 16.0,
        left: 24.0,
        right: 24.0,
      ),
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseTextField(
            label: widget.title,
            controller: controller,
            type: TextInputType.number,
          ),
          const SizedBox(height: 24.0),
          BaseButton.primary(
            borderColor: UiKit.palette.primary,
            onPressed: () {
              Modular.to.pop(controller.text.trim());
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
