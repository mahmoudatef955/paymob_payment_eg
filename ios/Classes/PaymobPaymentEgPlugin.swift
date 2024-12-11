import Flutter
import UIKit
import PaymobSDK


public class PaymobPaymentEgPlugin: NSObject, FlutterPlugin {
  var SDKResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paymob_payment_eg", binaryMessenger: registrar.messenger())
    let instance = PaymobPaymentEgPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "payWithPaymob":
      if let args = call.arguments as? [String: Any] {
          SDKResult = result
          callNativeSDK(arguments: args, VC: UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }


      // Function to call native PaymobSDK
    private func callNativeSDK(
        arguments: [String: Any], VC: FlutterViewController
    ) {

        // Initialize Paymob SDK
        let paymob = PaymobSDK()
        var savedCards: [SavedBankCard] = []
        paymob.delegate = self

        //customize the SDK

        if let appName = arguments["appName"] as? String {
            paymob.paymobSDKCustomization.appName = appName
        }

        if let buttonBackgroundColor = arguments["buttonBackgroundColor"]
            as? NSNumber
        {
            let colorInt = buttonBackgroundColor.intValue
            let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
            let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
            let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
            let blue = CGFloat(colorInt & 0xFF) / 255.0
            let color = UIColor(
                red: red, green: green, blue: blue, alpha: alpha)
            paymob.paymobSDKCustomization.buttonBackgroundColor = color

        }

        if let buttonTextColor = arguments["buttonTextColor"] as? NSNumber {

            let colorInt = buttonTextColor.intValue
            let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
            let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
            let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
            let blue = CGFloat(colorInt & 0xFF) / 255.0
            let color = UIColor(
                red: red, green: green, blue: blue, alpha: alpha)
            paymob.paymobSDKCustomization.buttonTextColor = color

        }

        if let saveCardDefault = arguments["saveCardDefault"] as? Bool {
            paymob.paymobSDKCustomization.saveCardDefault = saveCardDefault
        }

        if let showSaveCard = arguments["showSaveCard"] as? Bool {
           paymob.paymobSDKCustomization.showSaveCard = showSaveCard
        }

        if let savedCardData = arguments["savedBankCard"] as? [String: String],
            let token = savedCardData["token"],
            let maskedPanNumber = savedCardData["maskedPanNumber"],
            let cardType = savedCardData["cardType"]
        {

            // Now you can create a custom class in Swift
            let savedcard = SavedBankCard(
                token: token, maskedPanNumber: maskedPanNumber,
                cardType: CardType(rawValue: cardType) ?? CardType.Unknown)
            savedCards.append(savedcard)

        }

        // Call Paymob SDK with publicKey and clientSecret

        if let publicKey = arguments["publicKey"] as? String,
            let clientSecret = arguments["clientSecret"] as? String
        {
            do {
                try paymob.presentPayVC(
                    VC: VC, PublicKey: publicKey, ClientSecret: clientSecret)
            } catch let error {
                print(error.localizedDescription)
                SDKResult?(error.localizedDescription)
            }
            return

        }

    }
}

extension PaymobPaymentEgPlugin: PaymobSDKDelegate {

    public func transactionRejected() {
        print("Transaction rejected")
        self.SDKResult?("Rejected")
    }

    public func transactionAccepted() {
        print("Transaction accepted")
        self.SDKResult?("Successfull")
    }

    public func transactionPending() {
        print("Transaction pending")
        self.SDKResult?("Pending")
    }

}

