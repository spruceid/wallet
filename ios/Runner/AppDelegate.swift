import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let groupId = "..."
  let sharedKey = "sharedString"
  let channelId = "com.web.share"
  let keymanChannelId = "com.security.keyman"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let webShareChannel = FlutterMethodChannel(name: self.channelId,
                                                    binaryMessenger: controller.binaryMessenger)

    let keymanChannel = FlutterMethodChannel(name: self.keymanChannelId,
                                                    binaryMessenger: controller.binaryMessenger)

    webShareChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread that handles web share.
      result("Test")
    })

    keymanChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case "generateSigningKey":
            guard let args = call.arguments as? [String : Any] else {
                result(nil)
                return
            }
            let alias = args["alias"] as! String
            KeyManager.generateSigningKey(id: alias)
            result(true)
            
        case "signPayload":
            guard let args = call.arguments as? [String : Any] else {
                result(nil)
                return
            }
            let alias = args["alias"] as! String
            let payloadArg = args["payload"] as! FlutterStandardTypedData
            let payload = [UInt8](payloadArg.data)
            guard let signed = KeyManager.signPayload(id: alias, payload: payload) else {
                result(nil)
                return
            }
            let signedFlutter = FlutterStandardTypedData(bytes: Data(signed))
            result(signedFlutter)
        
        case "generateEncryptionKey":
            guard let args = call.arguments as? [String : Any] else {
                result(nil)
                return
            }
            let alias = args["alias"] as! String
            KeyManager.generateEncryptionKey(id: alias)
            result(true)
            
        case "encryptPayload":
            guard let args = call.arguments as? [String : Any] else {
                result(nil)
                return
            }
            let alias = args["alias"] as! String
            let payloadArg = args["payload"] as! FlutterStandardTypedData
            let payload = [UInt8](payloadArg.data)
            guard let (iv, encrypted) = KeyManager.encryptPayload(id: alias, payload: payload) else {
                result(nil)
                return
            }
            let ivFlutter = FlutterStandardTypedData(bytes: Data(iv))
            let encryptedFlutter = FlutterStandardTypedData(bytes: Data(encrypted))
            result([ivFlutter, encryptedFlutter])
            
        case "decryptPayload":
            guard let args = call.arguments as? [String : Any] else {
                result(nil)
                return
            }
            let alias = args["alias"] as! String
            let ivArg = args["iv"] as! FlutterStandardTypedData
            let iv = [UInt8](ivArg.data)
            let payloadArg = args["payload"] as! FlutterStandardTypedData
            let payload = [UInt8](payloadArg.data)
            guard let decrypted = KeyManager.decryptPayload(id: alias, iv: iv, payload: payload) else {
                result(nil)
                return
            }
            let decryptedFlutter = FlutterStandardTypedData(bytes: Data(decrypted))
            result(decryptedFlutter)
  
        default:
            print("Method not implemented")
            result(FlutterMethodNotImplemented)
        }
    })


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier
  ) -> Bool {
    return extensionPointIdentifier != .keyboard
  }

  // Invoked by URL protocol then gets payload from userDefaults and posts it to Flutter
  // with FlutterMethodChannel.
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let webShareChannel = FlutterMethodChannel(name: self.channelId,
                                                    binaryMessenger: controller.binaryMessenger)

    let defaults = UserDefaults(suiteName: self.groupId);
    let sharedString = defaults?.string(forKey: self.sharedKey);

    webShareChannel.invokeMethod(self.channelId, arguments: sharedString);

    return true;
  }
}
