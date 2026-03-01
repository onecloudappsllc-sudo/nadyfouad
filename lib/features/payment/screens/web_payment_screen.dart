import 'dart:convert';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPaymentScreen extends StatefulWidget {
  final String? token;
  const WebPaymentScreen({Key? key, this.token}) : super(key: key);

  @override
  State<WebPaymentScreen> createState() => _WebPaymentScreenState();
}

class _WebPaymentScreenState extends State<WebPaymentScreen> {

  getValue() async {
    if(html.window.location.href.contains('success')){
      final orderProvider =  Provider.of<OrderProvider>(context, listen: false);
      String placeOrderString =  utf8.decode(base64Url.decode(orderProvider.getPlaceOrder()!.replaceAll(' ', '+')));
      String tokenString = utf8.decode(base64Url.decode(widget.token!.replaceAll(' ', '+')));
      String paymentMethod = tokenString.substring(0, tokenString.indexOf('&&'));
      String transactionReference = tokenString.substring(tokenString.indexOf('&&') + '&&'.length, tokenString.length);

      PlaceOrderModel placeOrderBody =  PlaceOrderModel.fromJson(jsonDecode(placeOrderString)).copyWith(
        paymentMethod: paymentMethod.replaceAll('payment_method=', ''),
        transactionReference:  transactionReference.replaceRange(0, transactionReference.indexOf('transaction_reference='), '').replaceAll('transaction_reference=', ''),
      );
      orderProvider.placeOrder(placeOrderBody, _callback);

    }else{
      Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/0/field');
    }
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();
    Provider.of<OrderProvider>(context, listen: false).clearPlaceOrder();
    Provider.of<OrderProvider>(context, listen: false).stopLoader();
    if(isSuccess) {
      Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/$orderID/success');
    }else {
      showCustomSnackBarHelper(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): null,
      body: Center(
          child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),
    );
  }
}
