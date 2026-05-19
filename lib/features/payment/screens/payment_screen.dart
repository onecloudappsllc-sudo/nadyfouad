import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final String? url;
  final int? orderId;
  const PaymentScreen({Key? key, this.orderId, this.url}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = true;
  bool _handled = false;

  void _handleUrl(String urlStr) {
    if (_handled) return;
    if (urlStr.contains('payment-result.php')) {
      _handled = true;
      print('==== PAYMENT RESULT URL: $urlStr ====');
      
      String status = 'failure';
      String orderId = '';
      try {
        final uri = Uri.parse(urlStr);
        final responseCode = uri.queryParameters['responseCode'];
        final geideaStatus = uri.queryParameters['status'];
        if (responseCode == '000' || geideaStatus == 'success') {
          status = 'success';
        } else if (geideaStatus == 'canceled' || responseCode == '010') {
          status = 'canceled';
        } else {
          status = 'failure';
        }
        orderId = uri.queryParameters['orderId'] ?? '';
      } catch (e) {
        print('URL parse error: $e');
      }
      
      print('==== STATUS: $status ====');
      
      Future.delayed(const Duration(seconds: 1), () {
        try {
          if (status == 'success') {
            _handleSuccess(orderId);
          } else {
            Navigator.of(Get.context!).pop();
          }
        } catch (e) {
          print('Navigation error: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = 'https://nadyfouad.com/demo.nadyfouad.net/pay/geidea-session.php?sessionId=${widget.url}';
    
    return WillPopScope(
      onWillPop: () async {
        if (!_handled) {
          _handled = true;
                Navigator.of(Get.context!).pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدفع الإلكتروني'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (!_handled) {
                _handled = true;
                Navigator.of(Get.context!).pop();
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
                domStorageEnabled: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                supportZoom: false,
                allowsInlineMediaPlayback: true,
                javaScriptCanOpenWindowsAutomatically: true,
                thirdPartyCookiesEnabled: true,
              ),
              onLoadStart: (controller, url) {
                _handleUrl(url?.toString() ?? '');
              },
              onLoadStop: (controller, url) {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
                _handleUrl(url?.toString() ?? '');
              },
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSuccess(String orderId) {
    try {
      print('==== HANDLE SUCCESS ====');
      final orderProvider = Provider.of<OrderProvider>(Get.context!, listen: false);
      String? placeOrderString = orderProvider.getPlaceOrder();
      print('placeOrderString: ${placeOrderString != null ? "exists" : "null"}');
      
      if (placeOrderString != null && placeOrderString.isNotEmpty) {
        final decoded = utf8.decode(base64Url.decode(placeOrderString.replaceAll(' ', '+')));
        final jsonData = jsonDecode(decoded);
        PlaceOrderModel placeOrderBody = PlaceOrderModel.fromJson(jsonData);
        orderProvider.placeOrder(placeOrderBody, _callback);
        print('==== placeOrder called ====');
      } else {
        Navigator.of(Get.context!).pushNamedAndRemoveUntil(
          '${RouteHelper.orderSuccessful}/${orderId.isEmpty ? "No" : orderId}/success',
          (route) => false,
        );
      }
    } catch (e, stack) {
      print('==== Success error: $e ====');
      print('Stack: $stack');
      Navigator.of(Get.context!).pushNamedAndRemoveUntil(
        '${RouteHelper.orderSuccessful}/No/success',
        (route) => false,
      );
    }
  }

void _callback(bool isSuccess, String message, String orderID) async {
    if (!isSuccess) {
      showCustomSnackBarHelper(message);
      return;
    }

    final ctx = Get.context;
    if (ctx == null) return;

    try {
      Provider.of<CartProvider>(ctx, listen: false).clearCartList();
      Provider.of<OrderProvider>(ctx, listen: false).stopLoader();
    } catch (e) {}

    // شغل في الخلفية بدون await
    Provider.of<OrderProvider>(ctx, listen: false)
        .getOrderDetails(orderID: orderID)
        .catchError((e) => print('getOrderDetails error: $e'));

    Navigator.pushReplacementNamed(
      ctx,
      '${RouteHelper.orderSuccessful}/$orderID/success',
    );
  }
}