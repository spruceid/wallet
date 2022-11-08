import 'dart:convert';

import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:credible/app/pages/credentials/repositories/credential.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WebShareHandler {
  final Future<dynamic> Function(Map<String, dynamic>) verify;
  final Future<bool> Function(BuildContext, dynamic) show;

  WebShareHandler(this.verify, this.show);
}

class WebShare {
  static const channelId = 'com.web.share';
  static const platform = MethodChannel(channelId);

  static final instance = WebShare._();

  final List<WebShareHandler> handlers;

  WebShare._() : handlers = [];

  static Future<dynamic> _nativeMethodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case channelId:
        if (methodCall.arguments.isNotEmpty) {
          await SecureStorageProvider.instance
              .set('webShare', methodCall.arguments);
        }
        break;

      default:
        break;
    }
  }

  static void setupWebShare() {
    platform.setMethodCallHandler(_nativeMethodCallHandler);
  }

  static Future<void> registerWebShare() async {
    final String webShareContent = await platform.invokeMethod('method', {});

    if (webShareContent.isNotEmpty) {
      await SecureStorageProvider.instance.set('webShare', webShareContent);
    }
  }

  static Future<void> verifyWebShare(BuildContext context) async {
    final webShare = await SecureStorageProvider.instance.get('webShare');

    if (webShare != null &&
        webShare.isNotEmpty &&
        webShare != 'Web Share string not initialized') {
      await SecureStorageProvider.instance.delete('webShare');

      try {
        // TODO: improve credential handling
        final json = jsonDecode(webShare);
        for (final handler in instance.handlers) {
          final response = await handler.verify(json);
          if (response == null) continue;
          final add = await handler.show(context, response);
          if (add) {
            await Modular.get<CredentialsRepository>().insert(response);
          }
        }
      } catch (_) {
        print('Failed to decode JSON credential');
      } finally {
        await SecureStorageProvider.instance.delete('webShare');
      }
    }
  }
}
