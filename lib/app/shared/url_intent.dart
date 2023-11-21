import 'package:credible/app/interop/secure_storage/secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class UrlIntent {
  static const channelId = 'com.intent.url';
  static const platform = MethodChannel(channelId);

  static Future<void> _handleUrl(String urlIntent) async {
    try {
      final uri = Uri.parse(urlIntent);

      switch (uri.scheme) {
        case 'openid4vp':
        case 'openid-vc':
          // Modular.get<RequestBloc>().add(OID4VPRequest(
          //   requestUri: urlIntent,
          //   isSameDevice: true,
          // ));
          break;
        default:
          throw 'Invalid or unsupported protocol';
      }
    } catch (e) {
      debugPrint('Failed to process Url Intent. Error: $e');
    }
  }

  static Future<dynamic> _nativeMethodCallHandler(MethodCall methodCall) async {
    debugPrint(
        '--- X. Url Intent from native call with: ${methodCall.method} method'
        ' and ${methodCall.arguments} string ---');

    switch (methodCall.method) {
      case channelId:
        if (methodCall.arguments.isNotEmpty) {
          await _handleUrl(methodCall.arguments);
        }
        break;

      default:
        break;
    }
  }

  static void setupUrlIntent() {
    platform.setMethodCallHandler(_nativeMethodCallHandler);
  }

  static Future<void> verifyUrlIntent(BuildContext context) async {
    final urlIntent = await platform.invokeMethod('method', {});

    debugPrint('--- 2. Url Intent native call with string: $urlIntent ---');

    if (urlIntent != null &&
        urlIntent.isNotEmpty &&
        urlIntent != 'Url Intent string not initialized') {
      await SecureStorageProvider.instance.delete('urlIntent');
      await _handleUrl(urlIntent);
    }
  }
}
