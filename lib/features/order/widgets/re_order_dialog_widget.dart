import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/helper/order_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_single_child_list_widget.dart';
import 'package:provider/provider.dart';

class ReOrderDialogWidget extends StatelessWidget {
  const ReOrderDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return Dialog(child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSizeLarge)),
          ),
          width: 600,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Flexible(child: CustomSingleChildListWidget(
              itemCount: orderProvider.reOrderCartList.length,
              itemBuilder: (index) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ReOrderProductItem(
                    cart: orderProvider.reOrderCartList[index],
                    index: index,
                    orderDetailsModel: orderProvider.orderDetails![index],
                  ),
                  const Divider(height: Dimensions.paddingSizeDefault),

                ]);
              },
            )),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Row(children: [
              Expanded(child: CustomButtonWidget(backgroundColor: Theme.of(context).disabledColor, buttonText: getTranslated('cancel', context), onPressed: ()=> Navigator.pop(context))),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(child: CustomButtonWidget(
                buttonText: getTranslated('confirm', context),
                onPressed: ()=> OrderHelper.addToCartReorderProduct(cartList: orderProvider.reOrderCartList),
              )),
            ])

          ]),
        ));
      }
    );
  }
}

class ReOrderProductItem extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  final CartModel cart;
  final int index;
  const ReOrderProductItem({Key? key, required this.cart, required this.index, required this.orderDetailsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String? variationText = '';
    if(cart.variation !=null ) {
      List<String> variationTypes = cart.variation!.type!.split('-');
      if(variationTypes.length == cart.product!.choiceOptions!.length) {
        int index = 0;
        for (var choice in cart.product!.choiceOptions!) {
          variationText = '${variationText!}${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
          index = index + 1;
        }
      }else {
        variationText = cart.product!.variations![0].type;
      }
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        bool isProductNotAvailable = (cartProvider.isExistInCart(cart) != null) || (cart.stock != null &&  cart.stock! < 1);

        return Stack(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: ((cartProvider.isExistInCart(cart) != null) || (cart.stock != null &&  cart.stock! < 1))
                    ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                    placeholder: Images.placeHolder,
                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart.image}',
                    height: 70, width: 85,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(children: [
                      Expanded(child: Text(
                        cart.name!,
                        style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),

                      // Text('${getTranslated('quantity', context)}:', style: poppinsRegular),
                      // const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      //
                      // Text('${cart.quantity}', style: poppinsSemiBold.copyWith(
                      //   fontSize: Dimensions.fontSizeExtraLarge,
                      //   color: Theme.of(context).primaryColor,
                      // )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Row(children: [
                      Expanded(child: CustomDirectionalityWidget(child: Text(
                        PriceConverterHelper.convertPrice(context, cart.price),
                        style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                      ))),

                      Text('${cart.capacity} ${cart.unit}', style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                    cart.product!.variations!.isNotEmpty ? Text(
                      variationText!,maxLines: 1,
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      overflow: TextOverflow.ellipsis,
                    ) : const SizedBox(),
                  ],
                )),

              ]),
            ),

          if(orderDetailsModel.price != cart.price)  Positioned.fill(
            child: Align(alignment: Alignment.topLeft, child: ReOrderTagView(
              message: getTranslated('price_updated', context),
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusSizeDefault),
                bottomRight: Radius.circular(Dimensions.radiusSizeLarge),
              ),
            )),
          ),

          Positioned.fill(
            child: Align(alignment: Alignment.topRight, child: Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isProductNotAvailable ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor,
              ),
              child: Icon(
                isProductNotAvailable ? Icons.not_interested_outlined : Icons.done_outlined,
                color: Colors.white, size: Dimensions.paddingSizeLarge,
              ),
            )),
          ),

          if(isProductNotAvailable) Positioned.fill(
            child: Align(alignment: Alignment.bottomRight, child: ReOrderTagView(
              message: getTranslated( (cart.stock != null &&  cart.stock! < 1) ? 'out_of_stock' : 'already_added', context),
            )),
          ),
        ]);
      }
    );
  }
}

class ReOrderTagView extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final String message;
  const ReOrderTagView({
    Key? key, this.borderRadius, this.color, required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusSizeLarge),
          bottomRight: Radius.circular(Dimensions.radiusSizeDefault),
        ),
        color: color ?? Theme.of(context).colorScheme.error.withOpacity(0.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: Dimensions.paddingSizeSmall),
      child: Text(message, style: poppinsLight.copyWith(
        fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white,
      )),
    );
  }
}




