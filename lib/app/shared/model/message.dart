import 'package:flutter/material.dart';

enum MessageType {
  error,
  warning,
  info,
  success,
}

class StateMessage {
  final String message;
  final MessageType type;

  StateMessage.error(this.message) : type = MessageType.error;

  StateMessage.warning(this.message) : type = MessageType.warning;

  StateMessage.info(this.message) : type = MessageType.info;

  StateMessage.success(this.message) : type = MessageType.success;

  Color get color {
    switch (type) {
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.yellow;
      case MessageType.info:
        return Colors.cyan;
      case MessageType.success:
        return Colors.green;
      default:
        return null;
    }
  }
}
