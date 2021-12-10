import 'package:credible/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'base/button.dart';
import 'base/text_field.dart';

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? initialValue;
  final String yes;
  final String no;

  const TextFieldDialog(
      {Key? key,
      required this.title,
      this.subtitle,
      this.initialValue,
      this.yes = 'Confirm',
      this.no = 'No'})
      : super(key: key);

  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();

    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
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
            label: 'Credential alias',
            controller: controller,
            // icon: Icons.wallet,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: <Widget>[
              Expanded(
                child: BaseButton.primary(
                  borderColor: UiKit.palette.primary,
                  onPressed: () {
                    Modular.to.pop(controller.text);
                  },
                  child: Text(widget.yes),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: BaseButton.transparent(
                  borderColor: UiKit.palette.primary,
                  onPressed: () {
                    Modular.to.pop();
                  },
                  child: Text(
                    widget.no,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
