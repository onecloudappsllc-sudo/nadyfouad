import 'package:flutter/material.dart';
import 'models.dart';
import 'enums.dart';
import 'presentation_style.dart';
import 'payment_screen.dart';

class GDPaymentSDK {
  static GDPaymentSDK? _instance;

  GDPaymentSDK._();

  static GDPaymentSDK sharedInstance() {
    _instance ??= GDPaymentSDK._();
    return _instance!;
  }

  Future<PaymentResponse> start({
    required GDPaymentSDKConfiguration configuration,
    SDKPresentationStyle presentationStyle = const PushStyle(),
    required BuildContext context,
  }) async {
    final result = await Navigator.push<PaymentResponse>(
      context,
      MaterialPageRoute(
        builder: (_) => GeideaPaymentPage(configuration: configuration),
        fullscreenDialog: presentationStyle is ModalStyle,
      ),
    );

    return result ?? const PaymentResponse(status: PaymentStatus.canceled);
  }
}
