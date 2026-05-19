import 'enums.dart';
import 'theme.dart';

class GDPaymentSDKConfiguration {
  final SDKTheme? theme;
  final String sessionId;
  final SDKLanguage language;
  final bool isSandbox;
  final Region region;
  final String? applePayMerchantId;

  const GDPaymentSDKConfiguration({
    required this.sessionId,
    this.region = Region.uae,
    this.language = SDKLanguage.english,
    this.isSandbox = false,
    this.theme,
    this.applePayMerchantId,
  });
}

class PaymentResponse {
  final PaymentStatus status;
  final GDPaymentResult? result;
  final GDPaymentError? error;

  const PaymentResponse({
    required this.status,
    this.result,
    this.error,
  });
}

class GDPaymentResult {
  final String? orderId;
  final String? tokenId;
  final String? agreementId;
  final PaymentMethodResult? paymentMethod;

  const GDPaymentResult({
    this.orderId,
    this.tokenId,
    this.agreementId,
    this.paymentMethod,
  });
}

class PaymentMethodResult {
  final String? type;
  final String? brand;
  final String? maskedCardNumber;

  const PaymentMethodResult({
    this.type,
    this.brand,
    this.maskedCardNumber,
  });
}

class GDPaymentError {
  final String code;
  final String message;
  final String? details;

  const GDPaymentError({
    required this.code,
    required this.message,
    this.details,
  });
}
