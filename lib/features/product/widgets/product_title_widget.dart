import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:provider/provider.dart';

class ProductTitleWidget extends StatelessWidget {
  final Product? product;
  final int? stock;
  final int? cartIndex;
  const ProductTitleWidget({Key? key, required this.product, required this.stock,required this.cartIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? startingPrice;
    double? startingPriceWithDiscount;
    double? startingPriceWithCategoryDiscount;
    double? endingPrice;
    double? endingPriceWithDiscount;
    double? endingPriceWithCategoryDiscount;
    if(product!.variations!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in product!.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if(priceList[0]! < priceList[priceList.length-1]!) {
        endingPrice = priceList[priceList.length-1];
      }
    }else {
      startingPrice = product!.price;
    }


    if(product!.categoryDiscount != null) {
      startingPriceWithCategoryDiscount = PriceConverterHelper.convertWithDiscount(
        startingPrice, product!.categoryDiscount!.discountAmount, product!.categoryDiscount!.discountType,
        maxDiscount: product!.categoryDiscount!.maximumAmount,
      );

      if(endingPrice != null){
        endingPriceWithCategoryDiscount = PriceConverterHelper.convertWithDiscount(
          endingPrice, product!.categoryDiscount!.discountAmount, product!.categoryDiscount!.discountType,
          maxDiscount: product!.categoryDiscount!.maximumAmount,
        );
      }
    }
    startingPriceWithDiscount = PriceConverterHelper.convertWithDiscount(startingPrice, product!.discount, product!.discountType);

    if(endingPrice != null) {
      endingPriceWithDiscount = PriceConverterHelper.convertWithDiscount(endingPrice, product!.discount, product!.discountType);
    }

    if(startingPriceWithCategoryDiscount != null &&
        startingPriceWithCategoryDiscount > 0 &&
        startingPriceWithCategoryDiscount < startingPriceWithDiscount!) {
      startingPriceWithDiscount = startingPriceWithCategoryDiscount;
      endingPriceWithDiscount = endingPriceWithCategoryDiscount;
    }




    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Padding(
          padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall, left: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              product?.name ?? '',
                style: poppinsSemiBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeOverLarge : Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Row(children: [
              product?.rating != null ? Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: ColorResources.ratingColor.withOpacity(0.1),
                ),
                child: Row(mainAxisSize : MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: Dimensions.paddingSizeDefault),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(
                    product!.rating!.isNotEmpty ? double.parse(product!.rating![0].average!).toStringAsFixed(1) : '0.0',
                    style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6), fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ) : const SizedBox(),

              SizedBox(width: product!.rating != null ? Dimensions.paddingSizeSmall : 0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeLarge),
                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  color: /*product!.totalStock! > 0
                      ?  Theme.of(context).primaryColor
                      :*/ Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Text(
                  getTranslated(product!.totalStock! > 0
                      ? 'in_stock' : 'stock_out', context),
                  style: poppinsSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                ),
              ),
            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text(
              '${product!.capacity} ${product!.unit}',
              style: poppinsMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            //Product Price
            Row(children: [

              startingPriceWithDiscount! < startingPrice!  ? CustomDirectionalityWidget(
                child: Text(
                  '${PriceConverterHelper.convertPrice(context, startingPrice)}'
                      '${endingPrice != null ? ' - ${PriceConverterHelper.convertPrice(context, endingPrice)}' : ''}',
                  style: poppinsRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough,
                  ),
                ),
              ): const SizedBox(),
              SizedBox(width: startingPriceWithDiscount< startingPrice? Dimensions.paddingSizeExtraSmall : 0),

              CustomDirectionalityWidget(child: Text(
                '${PriceConverterHelper.convertPrice(context, startingPriceWithDiscount, )}'
                    '${endingPriceWithDiscount!= null ? ' - ${PriceConverterHelper.convertPrice(context, endingPriceWithDiscount)}' : ''}',
                style: poppinsBold.copyWith(color: Theme.of(context).primaryColor, fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeLarge),
              )),

            ]),

          ]),
        );
      },
    );
  }
}

