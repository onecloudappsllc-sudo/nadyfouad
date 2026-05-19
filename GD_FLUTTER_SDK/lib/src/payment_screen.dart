import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'models.dart';
import 'enums.dart';

class GeideaPaymentPage extends StatefulWidget {
  final GDPaymentSDKConfiguration configuration;

  const GeideaPaymentPage({Key? key, required this.configuration}) : super(key: key);

  @override
  State<GeideaPaymentPage> createState() => _GeideaPaymentPageState();
}

class _GeideaPaymentPageState extends State<GeideaPaymentPage> {
  bool _isLoading = true;
  bool _paymentDone = false;

  String get _lang => widget.configuration.language == SDKLanguage.arabic ? 'ar' : 'en';

  @override
  Widget build(BuildContext context) {
    final url = 'https://nadyfouad.com/demo.nadyfouad.net/pay/geidea-session.php?sessionId=${widget.configuration.sessionId}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_lang == 'ar' ? 'الدفع الإلكتروني' : 'Online Payment'),
        backgroundColor: _parseColor(widget.configuration.theme?.primaryColor) ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!_paymentDone) {
              _paymentDone = true;
              Navigator.pop(context, const PaymentResponse(status: PaymentStatus.canceled));
            }
          },
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              domStorageEnabled: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final urlStr = navigationAction.request.url?.toString() ?? '';
              if (_paymentDone) return NavigationActionPolicy.CANCEL;
              
              if (urlStr.contains('payment-result.php')) {
                _paymentDone = true;
                final uri = Uri.parse(urlStr);
                final status = uri.queryParameters['status'] ?? 'failure';
                final orderId = uri.queryParameters['orderId'] ?? '';
                final message = uri.queryParameters['message'] ?? '';
                
                PaymentResponse response;
                if (status == 'success') {
                  response = PaymentResponse(
                    status: PaymentStatus.success,
                    result: GDPaymentResult(orderId: orderId),
                  );
                } else if (status == 'canceled') {
                  response = const PaymentResponse(status: PaymentStatus.canceled);
                } else {
                  response = PaymentResponse(
                    status: PaymentStatus.failure,
                    error: GDPaymentError(code: 'ERROR', message: message),
                  );
                }
                
                Navigator.pop(context, response);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) {
              setState(() => _isLoading = false);
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: _parseColor(widget.configuration.theme?.primaryColor) ?? Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }
}