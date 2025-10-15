import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class ShippingPolicyBottomSheet extends StatelessWidget {
  const ShippingPolicyBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [


        Center(child: Text(
          getTranslated('shipping_policy', context),
          style: poppinsSemiBold.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: Dimensions.fontSizeLarge,
          ),
        )),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(getTranslated('shipping_policy_rules', context),
          style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(getTranslated('shipping_cost', context),
          style: poppinsSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(getTranslated('delivery_charge_calculation_based_on', context),
          maxLines: 2,
          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          CircleAvatar(
            radius: 2,
            backgroundColor: Theme.of(context).hintColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('fixed_wise', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          CircleAvatar(
            radius: 2,
            backgroundColor: Theme.of(context).hintColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('distance_wise', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          CircleAvatar(
            radius: 2,
            backgroundColor: Theme.of(context).hintColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('postcode_area_wise', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [

          CircleAvatar(
            radius: 2,
            backgroundColor: Theme.of(context).hintColor,
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('extra_charge_on_weight', context),
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(getTranslated('shipping_time', context),
          style: poppinsSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Text(getTranslated('entering_location_postcode_result_estimated_delivery_time', context),
          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),

      ],),
    );
  }
}