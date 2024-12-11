import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'paymob_payment_eg_method_channel.dart';

abstract class PaymobPaymentEgPlatform extends PlatformInterface {
  /// Constructs a PaymobPaymentEgPlatform.
  PaymobPaymentEgPlatform() : super(token: _token);

  static final Object _token = Object();

  static PaymobPaymentEgPlatform _instance = MethodChannelPaymobPaymentEg();

  /// The default instance of [PaymobPaymentEgPlatform] to use.
  ///
  /// Defaults to [MethodChannelPaymobPaymentEg].
  static PaymobPaymentEgPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PaymobPaymentEgPlatform] when
  /// they register themselves.
  static set instance(PaymobPaymentEgPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> payWithPaymob(Map<String, dynamic> arguments) {
    throw UnimplementedError('payWithPaymob() has not been implemented.');
  }
}
