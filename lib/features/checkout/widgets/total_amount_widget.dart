import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/shipping_policy_bottom_sheet.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';


class TotalAmountWidget extends StatelessWidget {
  const TotalAmountWidget({
    super.key,
    required this.amount,
    required this.freeDelivery,
    required this.deliveryCharge,
    this.discount,
    this.couponDiscount,
    this.tax,
    this.weight
  });

  final double amount;
  final bool freeDelivery;
  final double deliveryCharge;
  final double? discount;
  final double? couponDiscount;
  final double? tax;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    print('-------------------(DELIVERY CHARGE IN TOTAL AMOUNT WIDGET)------------------------$deliveryCharge');


    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

      Text(getTranslated('cost_summery', context),
        style: poppinsSemiBold.copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: Dimensions.fontSizeDefault
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Divider(height: 2, color: Theme.of(context).hintColor.withOpacity(0.2)),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('subtotal', context),
          style: poppinsRegular.copyWith(
            color: Theme.of(context).hintColor.withOpacity(0.5),
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),

        CustomDirectionalityWidget(child: Text(
          PriceConverterHelper.convertPrice(context, amount),
          style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        )),

      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [

          Text(getTranslated('delivery', context),
            style: poppinsRegular.copyWith(
              color: Theme.of(context).hintColor.withOpacity(0.5),
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            preferBelow: false,

            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
            ),
            message: _toolTipMessage(context),
            child: CustomAssetImageWidget(
              Images.deliveryTooltipIcon, color: Theme.of(context).hintColor,
              height: 18, width: 18,
            ),
          ),

        ]),


        CustomDirectionalityWidget(child: Text(
          PriceConverterHelper.convertPrice(context, deliveryCharge + (weight ?? 0.0)),
          style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        )),

      ]),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        InkWell(
          onTap: (){
            ResponsiveHelper.showDialogOrBottomSheet(context,
              const CustomAlertDialogWidget(
                child: ShippingPolicyBottomSheet(),
              ),
            );
          },
          child: Text(getTranslated("shipping_policy", context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

      ],),

    ]);
  }
}




String _toolTipMessage(BuildContext context){
  final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
  final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

  String message = '';
  message += "${getTranslated('delivery_charge_base_on', context)} ";
  message += getTranslated('${splashProvider.deliveryInfoModelList?[orderProvider.branchIndex].deliveryChargeSetup?.deliveryChargeType}',context);

  if(splashProvider.deliveryInfoModelList?[orderProvider.branchIndex].deliveryWeightSettingsStatus ?? false){
    message += " ${getTranslated('and_weight', context)}";
  }

  return message;

}