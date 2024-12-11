import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'paymob_payment_eg_platform_interface.dart';

/// An implementation of [PaymobPaymentEgPlatform] that uses method channels.
class MethodChannelPaymobPaymentEg extends PaymobPaymentEgPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('paymob_payment_eg');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> payWithPaymob(Map<String, dynamic> arguments) async {
    final result = await methodChannel.invokeMethod<String>('payWithPaymob', arguments);
    return result;
  }
}
