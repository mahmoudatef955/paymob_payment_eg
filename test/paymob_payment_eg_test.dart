import 'package:flutter_test/flutter_test.dart';
import 'package:paymob_payment_eg/paymob_payment_eg.dart';
import 'package:paymob_payment_eg/paymob_payment_eg_platform_interface.dart';
import 'package:paymob_payment_eg/paymob_payment_eg_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPaymobPaymentEgPlatform
    with MockPlatformInterfaceMixin
    implements PaymobPaymentEgPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PaymobPaymentEgPlatform initialPlatform = PaymobPaymentEgPlatform.instance;

  test('$MethodChannelPaymobPaymentEg is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPaymobPaymentEg>());
  });

  test('getPlatformVersion', () async {
    PaymobPaymentEg paymobPaymentEgPlugin = PaymobPaymentEg();
    MockPaymobPaymentEgPlatform fakePlatform = MockPaymobPaymentEgPlatform();
    PaymobPaymentEgPlatform.instance = fakePlatform;

    expect(await paymobPaymentEgPlugin.getPlatformVersion(), '42');
  });
}
