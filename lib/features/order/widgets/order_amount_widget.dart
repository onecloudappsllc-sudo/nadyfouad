import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_divider_widget.dart';
import 'package:flutter_grocery/common/widgets/price_item_widget.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/features/order/widgets/order_details_button_view.dart';

class OrderAmountWidget extends StatelessWidget {
  final double itemsPrice;
  final double tax;
  final double subTotal;
  final double discount;
  final double couponDiscount;
  final double deliveryCharge;
  final double total;
  final bool isVatInclude;
  final List<OrderPartialPayment> paymentList;
  final OrderModel? orderModel;
  final String? phoneNumber;
  final double extraDiscount;
  final double? weightChargeAmount;

  const OrderAmountWidget({
    Key? key, required this.itemsPrice, required this.tax, required this.subTotal,
    required this.discount, required this.couponDiscount, required this.deliveryCharge,
    required this.total, required this.isVatInclude,
    required this.paymentList, this.orderModel, this.phoneNumber, required this.extraDiscount,
    this.weightChargeAmount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print("-------------(ORDER AMOUNT WIDGET)----${weightChargeAmount != null && weightChargeAmount! > 0.0}");
    print("--------------(ORDER AMOUNT WIDGET)--------${weightChargeAmount}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
          ),
          child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('cost_summery', context), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            Divider(height: 30, thickness: 1, color: Theme.of(context).disabledColor.withOpacity(0.05)),

            PriceItemWidget(
              title: 'subtotal'.tr,
              subTitle: PriceConverterHelper.convertPrice(context, itemsPrice),
            ),
            const SizedBox(height: 10),

            PriceItemWidget(
              title: 'discount'.tr,
              subTitle: '- ${PriceConverterHelper.convertPrice(context, discount)}',
            ),
            const SizedBox(height: 10),

            PriceItemWidget(
              title: '${'tax'.tr} ${isVatInclude ? '(${'include'.tr})' : ''}',
              subTitle: '${isVatInclude ? '' : '+'} ${PriceConverterHelper.convertPrice(context, tax)}',
            ),
            const SizedBox(height: 10),

            PriceItemWidget(
              title: 'coupon_discount'.tr,
              subTitle: '- ${PriceConverterHelper.convertPrice(context, couponDiscount)}',
            ),
            const SizedBox(height: 10),

            extraDiscount > 0 ? PriceItemWidget(
              title: 'extra_discount'.tr,
              subTitle: '- ${PriceConverterHelper.convertPrice(context, extraDiscount)}',
            ) : const SizedBox(),
            SizedBox(height: extraDiscount > 0 ? 10 : 0),


            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [

                Text(getTranslated('delivery_fee', context), style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor)),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                if(weightChargeAmount != null && weightChargeAmount! > 0.0)...[
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: false,
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                    ),
                    message: "${getTranslated('delivery_charge_base_on', context)} ${getTranslated('delivery_and_weight', context)}",
                    child: CustomAssetImageWidget(
                      Images.deliveryTooltipIcon, color: Theme.of(context).hintColor,
                      height: 18, width: 18,
                    ),
                  ),
                ],


              ]),

              CustomDirectionalityWidget(child: Text(
                '+ ${PriceConverterHelper.convertPrice(context, deliveryCharge)}',
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              )),


            ],)

          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),


        CustomDividerWidget( color: Theme.of(context).primaryColor.withOpacity(0.5), height: 1.5, width: 10),

       Container(
         padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeSmall),
         decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.05)),
         child: Column(children: [
           const SizedBox(height: Dimensions.fontSizeSmall),

           PriceItemWidget(
             title: 'total_amount'.tr,
             subTitle: PriceConverterHelper.convertPrice(context, total),
             style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
           ),

           if(paymentList.isNotEmpty) Padding(
             padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall),
             child: Column(children: paymentList.map((payment) => payment.id != null ? Padding(
               padding: const EdgeInsets.symmetric(vertical: 1),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                 Text("${getTranslated(payment.paidAmount! > 0 ? 'paid_amount' : 'due_amount', context)} (${ payment.paidWith != null && payment.paidWith!.isNotEmpty ? '${payment.paidWith?[0].toUpperCase()}${payment.paidWith?.substring(1).replaceAll('_', ' ')}' : getTranslated('${payment.paidWith}', context)})",
                   style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                   overflow: TextOverflow.ellipsis,),

                 Text(PriceConverterHelper.convertPrice(context, payment.paidAmount! > 0 ? payment.paidAmount : payment.dueAmount),
                   style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
                 ),
               ],
               ),
             ) : const SizedBox()).toList()),
           ),

           const SizedBox(height: Dimensions.paddingSizeDefault),
         ]),
       ),

        if(ResponsiveHelper.isDesktop(context)) Column(children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          OrderDetailsButtonView(orderModel: orderModel, phoneNumber: phoneNumber),
        ]),

      ]);
  }
}
