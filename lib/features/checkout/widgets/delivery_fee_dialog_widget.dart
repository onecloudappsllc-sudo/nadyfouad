import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_divider_widget.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialogWidget extends StatelessWidget {
  final double amount;
  final double distance;
  final bool freeDelivery;
  final Function(double amount)? callBack;
  const DeliveryFeeDialogWidget({super.key, required this.amount, required this.distance, required this.freeDelivery, this.callBack});

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Consumer<OrderProvider>(builder: (context, order, child) {

      print("------(DISTANCE)-----------${orderProvider.distance}");
      print("------(Free Delivery Type)-----------${orderProvider.getCheckOutData?.freeDeliveryType}");

      double deliveryCharge = CheckOutHelper.getDeliveryCharge(
        orderAmount: amount, distance: distance,
        discount: order.getCheckOutData?.placeOrderDiscount ?? 0,
        configModel: configModel,
        freeDeliveryType: order.getCheckOutData?.freeDeliveryType,
      );

      callBack!(deliveryCharge);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width*0.4 : MediaQuery.of(context).size.width ,
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 70, width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delivery_dining,
                color: Theme.of(context).primaryColor, size: 50,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Column(children: [
              Text(
                '${getTranslated('delivery_fee_from_your_selected_address_to_branch', context)}:',
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              CustomDirectionalityWidget(child: Text(
                PriceConverterHelper.convertPrice(context, deliveryCharge),
                style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              )),

              const SizedBox(height: 20),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                
                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(context, amount),
                  style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                )),
              ]),
              const SizedBox(height: 10),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  getTranslated('delivery_fee', context),
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),

                CustomDirectionalityWidget(child: Text(
                  freeDelivery ? getTranslated('free', context):
                  '(+) ${PriceConverterHelper.convertPrice(context, deliveryCharge)}',
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                )),
              ]),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: CustomDividerWidget(),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(getTranslated('total_amount', context), style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
                )),

                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(context, amount + deliveryCharge),
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
              ]),
            ]),
            const SizedBox(height: 30),

            CustomButtonWidget(buttonText: getTranslated('ok', context), onPressed: () {
              Navigator.pop(context);
            }),

          ]),
        ),
      );
    });
  }
}
