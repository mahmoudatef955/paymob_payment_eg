import 'dart:ui';

import 'paymob_payment_eg_platform_interface.dart';

class PaymobPaymentEg {
  Future<String?> getPlatformVersion() {
    return PaymobPaymentEgPlatform.instance.getPlatformVersion();
  }

  Future<bool?> payWithPaymob(String pk, String csk,
      {SavedBankCard? savedCard,
      String? appName,
      Color? buttonBackgroundColor,
      Color? buttonTextColor,
      bool? saveCardDefault,
      bool? showSaveCard}) async {
    Map<String, dynamic> arguments = {
      "publicKey": pk,
      "clientSecret": csk,
      "savedBankCard": savedCard?.toMap(),
      "appName": appName,
      "buttonBackgroundColor": buttonBackgroundColor?.value,
      "buttonTextColor": buttonTextColor?.value,
      "saveCardDefault": saveCardDefault,
      "showSaveCard": showSaveCard
    };
    final result = await PaymobPaymentEgPlatform.instance.payWithPaymob(arguments);
    switch (result) {
      case 'Successfull':
        print('Transaction Successfull');
        return true;
      case 'Rejected':
        print('Transaction Rejected');
        // Do something for rejected
        return false;
      case 'Pending':
        print('Transaction Pending');
        // Do something for pending
        return false;
      default:
        print('Unknown response');
        return false;
      // Handle unknown response
    }
  }
}

enum CardType { OmanNet, JCB, Meeza, Maestro, Amex, Visa, MasterCard }

class SavedBankCard {
  final String token;
  final String maskedPanNumber;
  final String cardType;

  SavedBankCard({required this.token, required this.maskedPanNumber, required this.cardType});

  // Convert the custom CardType class to a Map (which can be serialized to JSON)
  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'maskedPanNumber': maskedPanNumber,
      'cardType': cardType,
    };
  }
}
