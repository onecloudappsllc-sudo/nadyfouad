import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/free_delivery_progressbar_widget.dart';
import 'package:flutter_grocery/features/checkout/screens/checkout_screen.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CartButtonWidget extends StatelessWidget {
  const CartButtonWidget({
    super.key,
    required double subTotal,
    required ConfigModel configModel,
    required double tax,
    required double itemPrice,
    required double total,
    required bool isFreeDelivery,
    required double discount,
    required double weight,
  }) : _subTotal = subTotal, _configModel = configModel,
        _isFreeDelivery = isFreeDelivery, _itemPrice = itemPrice, _discount = discount, _tax = tax,
        _total = total, _weight = weight;

  final double _subTotal;
  final ConfigModel _configModel;
  final double _itemPrice;
  final double _total;
  final bool _isFreeDelivery;
  final double _discount;
  final double _tax;
  final double _weight;

  @override
  Widget build(BuildContext context) {


    return SafeArea(child: Container(
      width: 1170,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [

        Consumer<CouponProvider>(
            builder: (context, couponProvider, _) {
              return couponProvider.coupon?.couponType == 'free_delivery'
                  ? const SizedBox() :
              FreeDeliveryProgressBarWidget(subTotal: _subTotal, configModel: _configModel);
            }
        ),

        CustomButtonWidget(
          buttonText: getTranslated('proceed_to_checkout', context),
          onPressed: () {
            if(_itemPrice < _configModel.minimumOrderValue!) {
              showCustomSnackBarHelper(' ${getTranslated('minimum_order_amount_is', context)} ${PriceConverterHelper.convertPrice(context, _configModel.minimumOrderValue)
              }, ${getTranslated('you_have', context)} ${PriceConverterHelper.convertPrice(context, _itemPrice)} ${getTranslated('in_your_cart_please_add_more_item', context)}', isError: true);
            } else {
              String? orderType = Provider.of<OrderProvider>(context, listen: false).orderType;
              double? couponDiscount = Provider.of<CouponProvider>(context, listen: false).discount;

              print("--------------------(CART BUTTON WIDGET)--------------Discount: $_discount and Coupon Discount: $couponDiscount and $_isFreeDelivery}");
              Navigator.pushNamed(
                context, RouteHelper.getCheckoutRoute(
                _total, _tax, _discount, couponDiscount, orderType,
                Provider.of<CouponProvider>(context, listen: false).coupon?.code ?? '',
                _isFreeDelivery ? 'free_delivery' : '', _weight
              ),
                arguments: CheckoutScreen(
                  tax: _tax,
                  amount: _total, orderType: orderType, discount: _discount, couponDiscount: couponDiscount,
                  couponCode: Provider.of<CouponProvider>(context, listen: false).coupon?.code,
                  freeDeliveryType:  _isFreeDelivery ? 'free_delivery' : '', weight: _weight,
                ),
              );
            }
          },
        ),
      ]),
    ));
  }
}
