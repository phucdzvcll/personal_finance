import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register method channel using FlutterPluginRegistry (recommended approach)
    guard let controller = window?.rootViewController as? FlutterViewController else {
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let flavorChannel = FlutterMethodChannel(name: "com.personalfinance.app/flavor",
                                              binaryMessenger: controller.binaryMessenger)
    
    flavorChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "getFlavor" {
        let flavor = self.getFlavor()
        result(flavor)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func getFlavor() -> String {
    #if DEV
    return "dev"
    #elseif STG
    return "stg"
    #elseif PROD
    return "prod"
    #else
    return "dev"
    #endif
  }
}
