import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class DiscountedPriceWidget extends StatelessWidget {
  final bool isUnitPrice;
  final String? leadingText;
  const DiscountedPriceWidget({
    Key? key,
    required this.cart, this.isUnitPrice = true, this.leadingText,
  }) : super(key: key);

  final CartModel cart;

  @override
  Widget build(BuildContext context) {

    return CustomDirectionalityWidget(child: RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      text: TextSpan(
        children: [
         if(leadingText != null) TextSpan(
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            text: leadingText,
          ),

          if((cart.discountedPrice ?? 0) < (cart.price ?? 0) && isUnitPrice) TextSpan(
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).disabledColor,
              decoration: TextDecoration.lineThrough,
            ),
            text: PriceConverterHelper.convertPrice(context, (cart.price ?? 0) * (isUnitPrice ? 1 : cart.quantity ?? 1)),
          ),
          if((cart.discountedPrice ?? 0) < (cart.price ?? 0) && isUnitPrice) const TextSpan(text: '  '),

          TextSpan(
            style: poppinsSemiBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            text: PriceConverterHelper.convertPrice(context, (cart.discountedPrice ?? 0) * (isUnitPrice ? 1 : cart.quantity ?? 1)),
          ),



        ],
      ),
    ));
  }
}
