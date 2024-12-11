package com.example.paymob_payment_eg

import android.app.Activity
import android.graphics.Color
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.widget.Toast
import com.paymob.paymob_sdk.PaymobSdk
import com.paymob.paymob_sdk.domain.model.CreditCard
import com.paymob.paymob_sdk.domain.model.SavedCard
import com.paymob.paymob_sdk.ui.PaymobSdkListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
 

/** PaymobPaymentEgPlugin */
class PaymobPaymentEgPlugin: FlutterPlugin, MethodCallHandler,ActivityAware, PaymobSdkListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  // private lateinit var channel : MethodChannel
//   private val CHANNEL = "paymob_payment_eg"
//   private var SDKResult: MethodChannel.Result? = null

//   override fun onCreate(savedInstanceState: Bundle?) {
//     super.onCreate(savedInstanceState)
//     flutterEngine?.dartExecutor?.binaryMessenger?.let {
//         MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
//           println("call.method: ${call.method}")
//             if (call.method == "payWithPaymob") {
//                 SDKResult = result
//                 callNativeSDK(call)
//             } else {
//                 result.notImplemented()
//             }
//         }
//     }
// }
private lateinit var channel : MethodChannel
private var activity: Activity? = null   
private var SDKResult: MethodChannel.Result? = null

override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "paymob_payment_eg")
  channel.setMethodCallHandler(this)
}

override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
    result.success("Android ${android.os.Build.VERSION.RELEASE}")
  } else if (call.method == "payWithPaymob") {
    if (activity == null) {
        result.error(
            "NO_ACTIVITY",
            "Plugin requires a foreground activity",
            null
        )
        return
    }
    SDKResult = result
    callNativeSDK(call)
  } else {
    result.notImplemented()
  }
}

// override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//   channel.setMethodCallHandler(null)
// }

    // Function to call native PaymobSDK
    private fun callNativeSDK(call: MethodCall) {
      val arguments = call.arguments as? Map<String, Any>
      val publicKey = call.argument<String>("publicKey")
      val clientSecret = call.argument<String>("clientSecret")
      val savedBankCard = arguments?.get("savedBankCard") as? Map<String, Any>
      var savedCard: SavedCard? = null
      var buttonBackgroundColor: Int? = null
      var buttonTextColor: Int? = null
      val appName = call.argument<String>("appName")
      val buttonBackgroundColorData = call.argument<Number>("buttonBackgroundColor")?.toInt() ?: 0
      val buttonTextColorData = call.argument<Number>("buttonTextColor")?.toInt() ?: 0
      val saveCardDefault = call.argument<Boolean>("saveCardDefault") ?: false
      val showSaveCard = call.argument<Boolean>("showSaveCard") ?: true
      //get saved card data
      // if (savedBankCard != null) {
      //     val maskedPan = savedBankCard["maskedPanNumber"] as? String ?: ""
      //     val token = savedBankCard["token"] as? String ?: ""
      //     val cardType = savedBankCard["cardType"] as? String ?: ""
      //     val creditCard = CreditCard.valueOf(cardType.uppercase())
      //     savedCard = SavedCard(maskedPan = "**** **** **** " + maskedPan, savedCardToken = token, creditCard = creditCard )
      // }
      if (buttonTextColorData != null){
          buttonTextColor = Color.argb(
              (buttonTextColorData shr 24) and 0xFF,  // Alpha
              (buttonTextColorData shr 16) and 0xFF,  // Red
              (buttonTextColorData shr 8) and 0xFF,   // Green
              buttonTextColorData and 0xFF            // Blue
          )
      }
      Log.d("color", buttonTextColor.toString())
      if (buttonBackgroundColorData != null){
          buttonBackgroundColor = Color.argb(
              (buttonBackgroundColorData shr 24) and 0xFF,  // Alpha
              (buttonBackgroundColorData shr 16) and 0xFF,  // Red
              (buttonBackgroundColorData shr 8) and 0xFF,   // Green
              buttonBackgroundColorData and 0xFF            // Blue
          )
      }
      val paymobsdk = PaymobSdk.Builder(
          context = activity ?: throw IllegalStateException("Activity cannot be null"), 
          clientSecret = clientSecret.toString(),
          publicKey = publicKey.toString(),
          paymobSdkListener = this,
          // savedCard = savedCard//Optional Field if you have a saved card
      ).setButtonBackgroundColor(buttonBackgroundColor ?: Color.BLACK)
          .setButtonTextColor(buttonTextColor ?: Color.WHITE)
          .setAppName(appName)
          .isAbleToSaveCard(showSaveCard ?: true)
          .isSavedCardCheckBoxCheckedByDefault(saveCardDefault ?: false)
      .build()
      paymobsdk.start()
      return


  }
  //PaymobSDK Return Values
  override fun onSuccess() {
      // If The Payment is Accepted
      SDKResult?.success("Successfull")
  }
  override fun onFailure() {
      //If The Payment is declined
      SDKResult?.success("Rejected")
  }
  override fun onPending() {
      //If The Payment is pending
      SDKResult?.success("Pending")
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
}

override fun onDetachedFromActivityForConfigChanges() {
    activity = null
}

override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
}

override fun onDetachedFromActivity() {
    activity = null
}

override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
}

}
