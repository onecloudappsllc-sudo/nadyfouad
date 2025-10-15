import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';


class VariationWidget extends StatelessWidget {
  final Product? product;
  const VariationWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: product!.choiceOptions!.length,
          padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics:  const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(product!.choiceOptions![index].title!, style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(0.8))),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1 / 0.3) : (1 / 0.35),
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: product!.choiceOptions![index].options!.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                    onTap: () {
                      cartProvider.setCartVariationIndex(index, i);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: cartProvider.variationIndex![index] != i ? Theme.of(context).canvasColor : Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(cartProvider.variationIndex![index] != i ? 0.08 : 0.8), width: 1),
                      ),
                      child: Text(
                        product!.choiceOptions![index].options![i].trim(), maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: poppinsRegular.copyWith(
                          color: cartProvider.variationIndex![index] != i ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5) : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: index != product!.choiceOptions!.length-1 ? Dimensions.paddingSizeLarge : 0),
            ]);
          },
        );
      },
    );
  }
}
