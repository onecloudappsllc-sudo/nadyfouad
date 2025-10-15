import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_divider_widget.dart';
import 'package:flutter_grocery/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_grocery/features/checkout/widgets/total_amount_widget.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class AmountWidget extends StatelessWidget {
  final double total;
  final double? weight;
  const AmountWidget({
    super.key,
    required this.total,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel =  Provider.of<SplashProvider>(context, listen: false).configModel;

    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {

      print('----------------(AMOUNT WIDGET)-----------$weight');

      CheckOutModel? checkOutData = Provider.of<OrderProvider>(context, listen: false).getCheckOutData;
      bool isFreeDelivery = CheckOutHelper.isFreeDeliveryCharge(type: checkOutData?.orderType);
      bool selfPickup = CheckOutHelper.isSelfPickup(orderType: checkOutData?.orderType);
      bool showPayment = orderProvider.selectedPaymentMethod != null;


          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Column(children: [

              const SizedBox(height: Dimensions.paddingSizeLarge),

              // Column(children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //
              //   Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
              //
              //   CustomDirectionalityWidget(child: Text(
              //     PriceConverterHelper.convertPrice(context, checkOutData?.amount),
              //       style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              //     )),
              //   ]),
              //   const SizedBox(height: Dimensions.paddingSizeSmall),
              //
              //   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //     Row(children: [
              //
              //       Text(getTranslated('delivery', context),
              //         style: poppinsRegular.copyWith(
              //           color: Theme.of(context).hintColor.withOpacity(0.5),
              //           fontSize: Dimensions.fontSizeDefault,
              //         ),
              //       ),
              //       const SizedBox(width: Dimensions.paddingSizeSmall),
              //
              //       Tooltip(
              //         message: "${getTranslated('delivery_charge_base_on', context)} ${getTranslated('${splashProvider.deliveryInfoModelList?[orderProvider.branchIndex].deliveryChargeSetup?.deliveryChargeType}', context)}",
              //         child: CustomAssetImageWidget(
              //           Images.deliveryTooltipIcon, color: Theme.of(context).hintColor,
              //           height: 18, width: 18,
              //         ),
              //       ),
              //
              //     ]),
              //
              //
              //     CustomDirectionalityWidget(child: Text(
              //       PriceConverterHelper.convertPrice(context, deliveryCharge),
              //       style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
              //     )),
              //
              //   ]),
              //
              //   const Padding(
              //     padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              //     child: CustomDividerWidget(),
              //   ),
              // ]),



              if(ResponsiveHelper.isDesktop(context)) TotalAmountWidget(
                amount: checkOutData?.amount ?? 0,
                freeDelivery: isFreeDelivery,
                weight: weight,
                deliveryCharge: checkOutData?.deliveryCharge ?? 0,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Divider(height: 2, color: Theme.of(context).hintColor.withOpacity(0.2)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if(orderProvider.partialAmount != null) Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    getTranslated('wallet_payment', context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: Text(PriceConverterHelper.convertPrice(context, checkOutData!.amount! + (checkOutData.deliveryCharge ?? 0) - (orderProvider.partialAmount ?? 0) ),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text( showPayment && orderProvider.selectedPaymentMethod?.type != 'cash_on_delivery'? getTranslated(orderProvider.selectedPaymentMethod?.getWayTitle, context) :
                  '${getTranslated('due_amount', context)} ${orderProvider.selectedPaymentMethod?.type == 'cash_on_delivery'
                      ? '(${getTranslated(orderProvider.selectedPaymentMethod?.type, context)})' : ''}',
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),

                  CustomDirectionalityWidget(
                    child: Text(PriceConverterHelper.convertPrice(context, orderProvider.partialAmount ??  (orderProvider.getCheckOutData?.amount ?? 0)),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),

                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

              ]),

              if(ResponsiveHelper.isDesktop(context))...[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(getTranslated('total_amount', context), style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  )),

                  CustomDirectionalityWidget(child: Text(
                    PriceConverterHelper.convertPrice(context, total + (weight ?? 0)),
                    style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyMedium?.color),
                  )),

                ]),

              ],

            ]),
          );
        }
    );
  }
}
