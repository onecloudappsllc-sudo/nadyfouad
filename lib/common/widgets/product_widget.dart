import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/on_hover_widget.dart';
import 'package:provider/provider.dart';

import 'wish_button_widget.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final String productType;
  final bool isGrid;
  final bool isCenter;
  const ProductWidget({Key? key, required this.product, this.productType = ProductType.dailyItem, this.isGrid = false, this.isCenter = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    double? priceWithDiscount = 0;
    double? categoryDiscountAmount;
    if(product.categoryDiscount != null) {
      categoryDiscountAmount = PriceConverterHelper.convertWithDiscount(
        product.price, product.categoryDiscount?.discountAmount, product.categoryDiscount?.discountType,
        maxDiscount: product.categoryDiscount?.maximumAmount,
      );
    }

    priceWithDiscount = PriceConverterHelper.convertWithDiscount(product.price, product.discount, product.discountType);


    if(categoryDiscountAmount != null && categoryDiscountAmount > 0 && categoryDiscountAmount  < priceWithDiscount!) {
      priceWithDiscount = categoryDiscountAmount;
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double price = 0;
        int? stock = 0;
        bool isExistInCart = false;
        int? cardIndex;
        CartModel? cartModel;
        if(product.variations!.isNotEmpty) {
          for(int index=0; index<product.variations!.length; index++) {
            price = product.variations!.isNotEmpty ? (product.variations![index].price ?? 0) : (product.price ?? 0);
            stock = product.variations!.isNotEmpty ? product.variations![index].stock : product.totalStock;
            cartModel = CartModel(product.id, product.image!.isNotEmpty ? product.image![0] : '', product.name, price,
                PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType),
                1,
                product.variations!.isNotEmpty ? product.variations![index] : null,
                (price - PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType)!),
                (price - PriceConverterHelper.convertWithDiscount(price, product.tax, product.taxType)!),
                product.capacity,
                product.unit,
                stock,product
            );
            isExistInCart = cartProvider.isExistInCart(cartModel) != null;
            cardIndex = cartProvider.isExistInCart(cartModel);

            if(isExistInCart) {
              break;
            }
          }
        }else {
          price =  product.price ?? 0;
          stock = product.totalStock;
          cartModel = CartModel(
            product.id, (product.image?.isNotEmpty ?? false) ?  product.image![0] : '',
            product.name, price,
            PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType),
            1, null,
            (price - PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType)!),
            (price - PriceConverterHelper.convertWithDiscount(price, product.tax, product.taxType)!),
            product.capacity,
            product.unit,
            stock,product,
          );

          isExistInCart = cartProvider.isExistInCart(cartModel) != null;
          cardIndex = cartProvider.isExistInCart(cartModel);
        }

        return isGrid ? OnHoverWidget(isItem: true, child: _ProductGridWidget(
          cardIndex: cardIndex,
          isCenter: isCenter,
          isExistInCart: isExistInCart,
          priceWithDiscount: priceWithDiscount ?? 0,
          product: product,
          productType: productType,
          cartModel: cartModel,
          stock: stock,
        )) : Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: () => Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(
              productId: product.id, formSearch: productType == ProductType.searchItem,
            )),

            child: OnHoverWidget(
              isItem: true,
              child: Container(
                height: 110,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4), blurRadius: 7, spreadRadius: 0.1)],
                ),
                child: Row(children: [

                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)),
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomImageWidget(
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${
                                product.image!.isNotEmpty ? product.image![0] : ''}',
                            height: 110, width: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      product.discount != 0 ? Positioned(
                        top: 5, left: 5,
                        child: _DiscountTag(product: product),
                      ) : const SizedBox(),

                      Positioned(
                        top: ResponsiveHelper.isDesktop(context) ? null : 5,
                        right: ResponsiveHelper.isDesktop(context) ? 5 : 5,
                        bottom: ResponsiveHelper.isDesktop(context) ? 5 : null,
                        child: !isExistInCart ? Tooltip(
                          message: getTranslated('click_to_add_to_your_cart', context),
                          child: InkWell(
                              onTap: () {
                                if(product.variations == null || product.variations!.isEmpty) {
                                  if (isExistInCart) {
                                    showCustomSnackBarHelper('already_added'.tr);
                                  } else if (stock! < 1) {
                                    showCustomSnackBarHelper('out_of_stock'.tr);
                                  } else {
                                    Provider.of<CartProvider>(context, listen: false).addToCart(cartModel!);
                                    showCustomSnackBarHelper('added_to_cart'.tr, isError: false);
                                  }
                                }else {
                                  Navigator.of(context).pushNamed(
                                    RouteHelper.getProductDetailsRoute(
                                      productId: product.id, formSearch:productType == ProductType.searchItem,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(2),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.05)),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Icon(Icons.shopping_cart_outlined,
                                    color: Theme.of(context).primaryColor),
                              )),
                        ) : Consumer<CartProvider>(builder: (context, cart, child) => RotatedBox(
                          quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 3,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.05)),
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).cardColor,
                            ),

                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  if (cart.cartList[cardIndex!].quantity! > 1) {
                                    Provider.of<CartProvider>(context, listen: false).setCartQuantity(false, cardIndex, context: context, showMessage: true);
                                  } else {
                                    Provider.of<CartProvider>(context, listen: false).removeItemFromCart(cardIndex, context);
                                  }
                                },
                                child: RotatedBox(
                                  quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall,
                                        vertical: Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.remove, size: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
                                  ),
                                ),
                              ),

                              RotatedBox(
                                quarterTurns: ResponsiveHelper.isDesktop(context) ? 0 : 1,
                                child: Text(
                                    cart.cartList[cardIndex!].quantity.toString(),
                                    style: poppinsSemiBold.copyWith(
                                        fontSize: Dimensions.fontSizeExtraLarge,
                                        color: Theme.of(context).textTheme.bodyLarge!.color)),
                              ),


                              InkWell(
                                onTap: () {
                                  if(cart.cartList[cardIndex!].product!.maximumOrderQuantity == null || cart.cartList[cardIndex].quantity! < cart.cartList[cardIndex].product!.maximumOrderQuantity!) {
                                    if(cart.cartList[cardIndex].quantity! < cart.cartList[cardIndex].stock!) {
                                      cart.setCartQuantity(true, cardIndex, showMessage: true, context: context);
                                    }else {
                                      showCustomSnackBarHelper(getTranslated('out_of_stock', context));
                                    }
                                  }else{
                                    showCustomSnackBarHelper('${getTranslated('you_can_add_max', context)} ${cart.cartList[cardIndex].product!.maximumOrderQuantity} ${getTranslated(cart.cartList[cardIndex].product!.maximumOrderQuantity! > 1 ? 'items' : 'item', context)} ${getTranslated('only', context)}');
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeSmall,
                                      vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.add, size: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            product.rating != null ? Row(mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
                              const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: 20),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(product.rating!.isNotEmpty ? double.parse(product.rating![0].average!).toStringAsFixed(1) : '0.0', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                            ]) : const SizedBox(),

                            Tooltip(message: product.name, child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(product.name ?? '',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),

                            Text('${product.capacity} ${product.unit}', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

                            Flexible(
                              child: Row(children: [
                                product.price! > priceWithDiscount! ? CustomDirectionalityWidget(child: Text(
                                  PriceConverterHelper.convertPrice(context, product.price),
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.lineThrough, color: Theme.of(context).disabledColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )) : const SizedBox(),

                                product.price! > priceWithDiscount ? const SizedBox(width: Dimensions.paddingSizeExtraSmall) : const SizedBox(),

                                CustomDirectionalityWidget(child: Text(
                                  PriceConverterHelper.convertPrice(context, priceWithDiscount),
                                  style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),

                              ],),
                            ),
                          ]),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: WishButtonWidget(product: product, edgeInset: const EdgeInsets.all(5)),
                  ),

                ]),
              ),
            ),
          ),
        );
      },
    );
  }


}


class _ProductGridWidget extends StatelessWidget {
  final bool isExistInCart;
  final int? stock;
  final CartModel? cartModel;
  final int? cardIndex;
  final double priceWithDiscount;
  final Product product;
  final String productType;
  final bool isCenter;

  const _ProductGridWidget({
    Key? key, required this.isExistInCart, this.stock, this.cartModel,
    required this.cardIndex, required this.priceWithDiscount,
    required this.product, required this.productType, required this.isCenter,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      borderRadius:  BorderRadius.circular(Dimensions.radiusSizeTen),
      onTap: () {
        Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(
          productId: product.id, formSearch: productType == ProductType.searchItem,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 7,
              spreadRadius: 0.1,
            ),]),
        child: Stack(children: [
          Column(children: [
            Expanded(
              flex: isCenter ? ResponsiveHelper.isMobile() ? 140 : 172 : 196,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                  width: Dimensions.webScreenWidth,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.radiusSizeTen),
                    ),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.radiusSizeTen),
                    ),
                    child: CustomImageWidget(
                      fit: BoxFit.cover,
                      height: 300,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${(product.image?.isNotEmpty ?? false) ? product.image![0] : ''}',
                    ),
                  ),
                ),
              ],
              ),),

            Expanded(flex: 100, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(
                crossAxisAlignment: isCenter ? CrossAxisAlignment.center: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  product.rating != null ? Row(mainAxisAlignment: isCenter ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
                    const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: 20),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(product.rating!.isNotEmpty ? double.parse(product.rating![0].average!).toStringAsFixed(1) : '0.0', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  ]) : const SizedBox(),

                  Tooltip(message: product.name ?? '', child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      product.name ?? '',
                      style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: isCenter ? TextAlign.center : TextAlign.start,
                    ),
                  )),

                  Column(children: [
                    if(!isCenter) const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    if(!isCenter) Divider(height: 2, thickness: 2,  color: Theme.of(context).secondaryHeaderColor),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                    isCenter ? Text(
                      '${product.capacity} ${product.unit}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ) : const SizedBox(),

                    isCenter ? CustomDirectionalityWidget(child: RichText(
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                        children: [

                          if((product.price ?? 0) > priceWithDiscount) TextSpan(
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).disabledColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                            text: PriceConverterHelper.convertPrice(context, (product.price ?? 0)),
                          ),
                          if((product.price ?? 0) > priceWithDiscount) const TextSpan(text: '  '),

                          TextSpan(
                            style: poppinsSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                            ),
                            text: PriceConverterHelper.convertPrice(context, priceWithDiscount),
                          ),



                        ],
                      ),
                    )) : Row(
                      children: [
                        Text(
                          '${product.capacity} ${product.unit}',
                          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),

                        product.price! > priceWithDiscount  ?
                        CustomDirectionalityWidget(
                          child: Text(
                            PriceConverterHelper.convertPrice(context, product.price),
                            style: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ) : const SizedBox(),

                        CustomDirectionalityWidget(child: Text(
                          PriceConverterHelper.convertPrice(context, priceWithDiscount),
                          style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        )),
                      ],
                    ),
                    // const SizedBox(height: Dimensions.paddingSizeSmall),
                  ]),

                ],
              ),
            )),

          ]),

          product.discount != 0 ? Positioned.fill(
            top: 17, left: 17,
            child: Align(
              alignment: Alignment.topLeft,
              child: _DiscountTag(product: product),
            ),
          ) : const SizedBox(),

          Positioned.fill(
            top: 17, right: 17,
            child: Align(
              alignment: Alignment.topRight,
              child: WishButtonWidget(product: product, edgeInset: const EdgeInsets.all(5.0)),
            ),
          ),

          Positioned.fill(
            right: 17, top: 60,
            child: Align(
              alignment: Alignment.topRight,
              child: !isExistInCart ? Tooltip(
                message: getTranslated('click_to_add_to_your_cart', context),
                child: InkWell(
                  onTap: () {
                    if(product.variations == null || product.variations!.isEmpty) {
                      if (isExistInCart) {
                        showCustomSnackBarHelper('already_added'.tr);
                      } else if (stock! < 1) {
                        showCustomSnackBarHelper('out_of_stock'.tr);
                      } else {
                        Provider.of<CartProvider>(context, listen: false).addToCart(cartModel!);
                        showCustomSnackBarHelper('added_to_cart'.tr, isError: false);
                      }
                    }else {
                      Navigator.of(context).pushNamed(
                        RouteHelper.getProductDetailsRoute(
                          productId: product.id, formSearch:productType == ProductType.searchItem,
                        ),
                      );
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)),
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).primaryColor,
                        size: Dimensions.paddingSizeLarge,
                      )
                  ),
                ),
              ) : Consumer<CartProvider>(builder: (context, cart, child) => RotatedBox(
                quarterTurns: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                  ),

                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    InkWell(
                      onTap: () {
                        if (cart.cartList[cardIndex!].quantity! > 1) {
                          Provider.of<CartProvider>(context, listen: false).setCartQuantity(false, cardIndex, context: context, showMessage: true);
                        } else {
                          Provider.of<CartProvider>(context, listen: false).removeItemFromCart(cardIndex!, context);
                        }
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeExtraSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Icon(
                            Icons.remove, size: Dimensions.paddingSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ),

                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        cart.cartList[cardIndex!].quantity.toString(),
                        style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ),


                    InkWell(
                      onTap: () {
                        if(cart.cartList[cardIndex!].product!.maximumOrderQuantity == null || cart.cartList[cardIndex!].quantity! < cart.cartList[cardIndex!].product!.maximumOrderQuantity!) {
                          if(cart.cartList[cardIndex!].quantity! < cart.cartList[cardIndex!].stock!) {
                            cart.setCartQuantity(true, cardIndex, showMessage: true, context: context);
                          }else {
                            showCustomSnackBarHelper(getTranslated('out_of_stock', context));
                          }
                        }else{
                          showCustomSnackBarHelper('${getTranslated('you_can_add_max', context)} ${cart.cartList[cardIndex!].product!.maximumOrderQuantity} ${getTranslated(cart.cartList[cardIndex!].product!.maximumOrderQuantity! > 1 ? 'items' : 'item', context)} ${getTranslated('only', context)}');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.add, size: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ),
                  ]),
                ),
              ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}


class _DiscountTag extends StatelessWidget {
  const _DiscountTag({Key? key, required this.product,}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(Dimensions.radiusSizeTen),
          bottomLeft: Radius.circular(Dimensions.radiusSizeTen),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              product.discountType == 'percent' ? '-${product.discount} %' : '-${PriceConverterHelper.convertPrice(context, product.discount)}',
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
            ),
          ),
        ],
      ),
    );
  }
}


