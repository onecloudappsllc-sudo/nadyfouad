import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class PartialAlertMessageWidget extends StatelessWidget {
  const PartialAlertMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(height: 100, width: Dimensions.paddingSizeExtraSmall, color: ColorResources.ratingColor),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Icon(Icons.warning_amber_rounded, color: ColorResources.ratingColor, size: 32),
        ),
        const SizedBox(width: Dimensions.paddingSizeLarge),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('select_payment_method', context), style: poppinsMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.titleMedium?.color,
              )),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(getTranslated('pay_the_rest_of_amount_with', context),style: poppinsRegular.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.6),
              ), maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
        ),


      ],
    );
  }
}
