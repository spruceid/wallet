import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let groupId = "..."
  let sharedKey = "sharedString"
  let channelId = "com.web.share"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let webShareChannel = FlutterMethodChannel(name: self.channelId,
                                                    binaryMessenger: controller.binaryMessenger)

    webShareChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread that handles web share.
      result("Test")
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
