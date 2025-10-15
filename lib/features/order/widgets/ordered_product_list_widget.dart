import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/features/order/widgets/ordered_product_variation_widget.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_single_child_list_widget.dart';
import 'package:provider/provider.dart';

class OrderedProductListWidget extends StatelessWidget {
  const OrderedProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return CustomSingleChildListWidget(
      itemCount: orderProvider.orderDetails!.length,
      itemBuilder: (index) {
        return orderProvider.orderDetails![index].productDetails != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OrderedProductItem(orderDetailsModel: orderProvider.orderDetails![index]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

        ]): const SizedBox.shrink();
      },
    );
  }
}

class OrderedProductItem extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  final bool fromReview;
  const OrderedProductItem({Key? key, required this.orderDetailsModel,this.fromReview = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
          child: CustomImageWidget(
            placeholder: Images.placeHolder,
            image: '${splashProvider.baseUrls!.productImageUrl}/'
                '${orderDetailsModel.productDetails!.image!.isNotEmpty
                ? orderDetailsModel.productDetails!.image![0] : ''}',
            height: 80, width: 80, fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 200, child: Text(
                orderDetailsModel.productDetails?.name ?? '',
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),

              if(!fromReview) OrderedProductVariationWidget(orderDetailsModel: orderDetailsModel),


            ]),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              
                Text('${getTranslated('quantity', context)} :', style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              
                Text(orderDetailsModel.quantity.toString(), style: poppinsMedium),
              
              ]),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                  children: [
              
                orderDetailsModel.discountOnProduct! > 0 ? CustomDirectionalityWidget(
                  child: Text(
                    PriceConverterHelper.convertPrice(context, orderDetailsModel.price!.toDouble()),
                    style: poppinsRegular.copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).hintColor.withOpacity(0.6),
                    ),
                  ),
                ) : const SizedBox(),
                SizedBox(width: orderDetailsModel.discountOnProduct! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
              
                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(context, orderDetailsModel.price! - orderDetailsModel.discountOnProduct!.toDouble()),
                  style: poppinsBold,
                )),
                const SizedBox(width: 5),
              ]),
            ),

          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              orderDetailsModel.productDetails!.name!,
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            if(!fromReview) Row(children: [
              Text('${getTranslated('quantity', context)} :', style: poppinsRegular),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(orderDetailsModel.quantity.toString(), style: poppinsMedium),
            ]),
            if(!fromReview) const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [

              orderDetailsModel.discountOnProduct! > 0 ? CustomDirectionalityWidget(
                child: Text(
                  PriceConverterHelper.convertPrice(context, orderDetailsModel.price!.toDouble()),
                  style: poppinsRegular.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor.withOpacity(0.6),
                  ),
                ),
              ) : const SizedBox(),
              SizedBox(width: orderDetailsModel.discountOnProduct! > 0 ? Dimensions.paddingSizeExtraSmall : 0),

              CustomDirectionalityWidget(child: Text(
                PriceConverterHelper.convertPrice(context, orderDetailsModel.price! - orderDetailsModel.discountOnProduct!.toDouble()),
                style: poppinsRegular,
              )),
              const SizedBox(width: 5),
            ]),

            if(!fromReview) OrderedProductVariationWidget(orderDetailsModel: orderDetailsModel),
          ]),
        ),
      ]),
    );
  }
}



