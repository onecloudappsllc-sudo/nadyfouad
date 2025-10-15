import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/price_item_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/coupon_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/delivery_option_widget.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CartDetailsWidget extends StatelessWidget {
  const CartDetailsWidget({
    super.key,
    required TextEditingController couponController,
    required double total,
    required bool isFreeDelivery,
    required double itemPrice,
    required double tax,
    required double discount,
  }) : _couponController = couponController, _total = total, _isFreeDelivery = isFreeDelivery, _itemPrice = itemPrice, _tax = tax, _discount = discount;

  final TextEditingController _couponController;
  final double _total;
  final bool _isFreeDelivery;
  final double _itemPrice;
  final double _tax;
  final double _discount;

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    print("-----------------(CART DETAILS WIDGET)--------------$_discount");
    return Column(children: [

      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('delivery_option', context), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
          DeliveryOptionWidget(value: 'delivery', title: getTranslated('home_delivery', context)),

          DeliveryOptionWidget(value: 'self_pickup', title: getTranslated('self_pickup', context)),

        ]),
      ),
      // SizedBox(height: _isSelfPickupActive ? Dimensions.paddingSizeDefault : 0),

      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Consumer<CouponProvider>(
            builder: (context, couponProvider, child) {
              return CouponWidget(couponController: _couponController, total: _total);
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Total
          Text(getTranslated('cost_summery', context), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          Divider(height: 30, thickness: 1, color: Theme.of(context).disabledColor.withOpacity(0.05)),

          PriceItemWidget(
            title: getTranslated('items_price', context),
            subTitle: PriceConverterHelper.convertPrice(context, _itemPrice),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          PriceItemWidget(
            title: '${getTranslated('tax', context)} ${configModel.isVatTexInclude! ? '(${getTranslated('include', context)})' : ''}',
            subTitle: '${ configModel.isVatTexInclude! ?  '' : '+'} ${PriceConverterHelper.convertPrice(context, _tax)}',
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          PriceItemWidget(
            title: getTranslated('discount', context),
            subTitle: '- ${PriceConverterHelper.convertPrice(context, _discount)}',
          ),


          Consumer<CouponProvider>(builder: (context, couponProvider, _) {
            return couponProvider.coupon?.couponType != 'free_delivery' && couponProvider.discount! > 0 ? Padding(
              padding: EdgeInsets.symmetric(vertical: couponProvider.coupon?.couponType != 'free_delivery' && couponProvider.discount! > 0 ? Dimensions.paddingSizeSmall : 0),
              child: PriceItemWidget(
                title: getTranslated('coupon_discount', context),
                subTitle: '- ${PriceConverterHelper.convertPrice(context, couponProvider.discount)}',
              ),
            ) : const SizedBox();
          }),

          Divider(height: 30, thickness: 1, color: Theme.of(context).disabledColor.withOpacity(0.1)),

          PriceItemWidget(
            title: getTranslated('subtotal', context),
            subTitle: PriceConverterHelper.convertPrice(context, _total),
            style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),

        ]),
      ),

    ]);
  }
}


