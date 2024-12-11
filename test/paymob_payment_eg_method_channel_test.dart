import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paymob_payment_eg/paymob_payment_eg_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPaymobPaymentEg platform = MethodChannelPaymobPaymentEg();
  const MethodChannel channel = MethodChannel('paymob_payment_eg');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
