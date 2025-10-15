import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/discounted_price_widget.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cart;
  final int index;
  const CartItemWidget({super.key, required this.cart, required this.index});

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    String? variationText = _getVariationValue();


    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteHelper.getProductDetailsRoute(productId: cart.product?.id),
          );
        },
        child: Stack(children: [
          const Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              cartProvider.setExistData(null);
              Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
              cartProvider.removeItemFromCart(index, context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 200]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(crossAxisAlignment : ResponsiveHelper.isDesktop(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  mainAxisAlignment: ResponsiveHelper.isDesktop(context) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                  children: [

                Container(
                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)), borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImageWidget(
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart.image}',
                      height: ResponsiveHelper.isDesktop(context) ? 100 : 70, width: ResponsiveHelper.isDesktop(context) ? 100 : 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                !ResponsiveHelper.isDesktop(context) ? Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(cart.name!, style: poppinsMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                      ), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      
                      if(cart.product?.variations?.isNotEmpty ?? false)  Row(children: [
                        Text('${getTranslated('variation', context)}: ', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                        Flexible(child: Text(variationText!, style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ))),
                      ]),

                      Text('${cart.capacity} ${cart.unit}',textDirection: TextDirection.ltr, style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                      DiscountedPriceWidget(cart: cart, leadingText: '${getTranslated('unit', context)}: ',),




                      // Row(children: [
                      //   Text('${getTranslated('unit', context)}: ', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      //
                      //   if((cart.discountedPrice ?? 0) < (cart.price ?? 0)) CustomDirectionalityWidget(child: Text(
                      //     PriceConverterHelper.convertPrice(context, (cart.price ?? 0) * 1),
                      //     style: poppinsRegular.copyWith(
                      //       fontSize: Dimensions.fontSizeDefault,
                      //       color: Theme.of(context).disabledColor,
                      //       decoration: TextDecoration.lineThrough,
                      //     ),
                      //   )),
                      //
                      //   if((cart.discountedPrice ?? 0) < (cart.price ?? 0) ) const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      //   CustomDirectionalityWidget(child: Text(
                      //     PriceConverterHelper.convertPrice(context, (cart.discountedPrice ?? 0) * 1),
                      //     style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                      //     maxLines: 2,
                      //   ))
                      // ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      DiscountedPriceWidget(cart: cart, isUnitPrice: false, leadingText: '${getTranslated('total', context)}: ',),


                      
                    ]),
                ) : Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Expanded(
                      flex: 6,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(cart.name ?? '', style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        if(cart.product?.variations?.isNotEmpty ?? false)  Wrap(children: [
                          Text('${getTranslated('variation', context)}: ', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),

                          Text(variationText!, style: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor,
                          )),
                        ]),

                        DiscountedPriceWidget(cart: cart, leadingText: '${getTranslated('unit', context)}: ',),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),
                    
                    Expanded(
                      flex: 4,
                      child: Row(children: [
                        Text('${cart.capacity} ${cart.unit}',
                            textDirection: TextDirection.ltr,
                            style: poppinsMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).disabledColor,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        DiscountedPriceWidget(cart: cart, isUnitPrice: false),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                  ]),
                ),


                RotatedBox(
                  quarterTurns: ResponsiveHelper.isMobile() ? 0 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [

                      InkWell(
                        onTap: () {
                          if(cart.product!.maximumOrderQuantity == null || cart.quantity! < cart.product!.maximumOrderQuantity!) {
                            if(cart.quantity! < cart.stock!) {
                              Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
                              cartProvider.setCartQuantity(true, index, showMessage: true, context: context);
                            }else {
                              showCustomSnackBarHelper(getTranslated('out_of_stock', context));
                            }
                          }else{
                            showCustomSnackBarHelper('${getTranslated('you_can_add_max', context)} ${cart.product!.maximumOrderQuantity} ${
                                getTranslated(cart.product!.maximumOrderQuantity! > 1 ? 'items' : 'item', context)} ${getTranslated('only', context)}');
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault :  Dimensions.paddingSizeSmall),
                          child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                        ),
                      ),

                      RotatedBox(quarterTurns: ResponsiveHelper.isMobile() ? 0 : 3, child: Text(cart.quantity.toString(), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Theme.of(context).primaryColor))),

                      RotatedBox(
                        quarterTurns: ResponsiveHelper.isMobile() ? 0 : 1,
                        child: (ResponsiveHelper.isDesktop(context) && cart.quantity == 1) ? Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          child: IconButton(
                            onPressed: () {
                              cartProvider.removeItemFromCart(index, context);
                              cartProvider.setExistData(null);
                            },
                            icon: const RotatedBox(quarterTurns: 2, child: Icon(Icons.delete, color: Colors.red, size: 20)),
                          ),
                        ) : InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
                            if (cart.quantity! > 1) {
                              cartProvider.setCartQuantity(false, index,showMessage: true, context: context);
                            }else if(cart.quantity == 1){
                              cartProvider.removeItemFromCart(index, context);
                              cartProvider.setExistData(null);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                            child: Icon(Icons.remove, size: 20,color: Theme.of(context).disabledColor),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  String? _getVariationValue() {
    String? variationText = '';
    if(cart.variation != null ) {
      List<String> variationTypes = cart.variation?.type?.split('-') ?? [];
      if(variationTypes.length == cart.product?.choiceOptions?.length) {
        int index = 0;
        for (var choice in cart.product?.choiceOptions ?? []) {
          variationText = '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      }else {
        variationText = cart.product?.variations?[0].type;
      }
    }

    return variationText;
  }

}



