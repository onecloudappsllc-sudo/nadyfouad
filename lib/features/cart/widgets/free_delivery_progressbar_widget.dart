import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FreeDeliveryProgressBarWidget extends StatelessWidget {
  const FreeDeliveryProgressBarWidget({
    Key? key,
    required double subTotal,
    required ConfigModel configModel,
  }) : _subTotal = subTotal, super(key: key);

  final double _subTotal;

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return configModel?.freeDeliveryStatus ?? false ? Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Row(children: [
          Icon(Icons.discount_outlined, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          (_subTotal / (configModel?.freeDeliveryOverAmount ?? 0))  < 1 ?
          CustomDirectionalityWidget(child: Text(
            '${PriceConverterHelper.convertPrice(context, (configModel?.freeDeliveryOverAmount ?? 0) - _subTotal)} ${getTranslated('more_to_free_delivery', context)}',
          ))
              : Text(getTranslated('enjoy_free_delivery', context)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        LinearProgressIndicator(
          value: (_subTotal / (configModel?.freeDeliveryOverAmount ?? 0)),
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ]),
    ) : const SizedBox();
  }
}
