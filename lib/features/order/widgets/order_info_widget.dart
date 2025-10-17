import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_zoom_widget.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/features/order/domain/models/timeslote_model.dart';
import 'package:flutter_grocery/features/order/widgets/payment_info_widget.dart';
import 'package:flutter_grocery/features/product/screens/product_image_screen.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/order_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/features/order/widgets/order_map_info_widget.dart';
import 'package:flutter_grocery/features/order/widgets/ordered_product_list_widget.dart';
import 'package:provider/provider.dart';

class OrderInfoWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final TimeSlotModel? timeSlot;

  const OrderInfoWidget({Key? key, required this.orderModel, required this.timeSlot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        int itemsQuantity = OrderHelper.getOrderItemQuantity(orderProvider.orderDetails);


        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Order info
            ResponsiveHelper.isDesktop(context) ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                Row(children: [

                  Row(children: [
                    Text('${getTranslated('order_id', context)} :', style: poppinsRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(orderProvider.trackModel!.id.toString(), style: poppinsSemiBold),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: OrderStatus.pending.name == orderProvider.trackModel!.orderStatus ? ColorResources.colorBlue.withOpacity(0.08)
                          : OrderStatus.out_for_delivery.name == orderProvider.trackModel!.orderStatus ? ColorResources.ratingColor.withOpacity(0.08)
                          : OrderStatus.canceled.name == orderProvider.trackModel!.orderStatus ? ColorResources.redColor.withOpacity(0.08) : ColorResources.colorGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                    ),
                    child: Text(
                      getTranslated(orderProvider.trackModel!.orderStatus, context),
                      style: poppinsRegular.copyWith(color: OrderStatus.pending.name == orderProvider.trackModel!.orderStatus ? ColorResources.colorBlue
                          : OrderStatus.out_for_delivery.name == orderProvider.trackModel!.orderStatus ? ColorResources.ratingColor
                          : OrderStatus.canceled.name == orderProvider.trackModel!.orderStatus ? ColorResources.redColor : ColorResources.colorGreen),
                    ),
                  ),


                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                timeSlot != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    Text('${getTranslated('delivered_time', context)}:', style: poppinsRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(DateConverterHelper.convertTimeRange(timeSlot!.startTime!, timeSlot!.endTime!, context), style: poppinsMedium),
                  ]),

                ]) : const SizedBox(),
                SizedBox(height: timeSlot != null ? Dimensions.paddingSizeSmall : 0),

                if(orderProvider.trackModel?.deliveryDate != null) Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    Text('${getTranslated('estimate_delivery_date', context)}: ', style: poppinsRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(DateConverterHelper.isoStringToLocalDateOnly(orderProvider.trackModel!.deliveryDate!), style: poppinsMedium),
                  ]),
                ),

                Row(children: [

                  Text('${getTranslated(itemsQuantity > 1 ? 'items' : 'item', context)}:', style: poppinsRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                  Text('$itemsQuantity', style: poppinsSemiBold),

                ]),

              ])),

              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const _OrderTypeWidget(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(DateConverterHelper.isoStringToLocalDateOnly(orderProvider.trackModel!.createdAt!), style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(height: Dimensions.paddingSizeDefault),


              ]),

            ]) : const SizedBox(),

            ResponsiveHelper.isDesktop(context) ? const SizedBox() : Row( crossAxisAlignment: CrossAxisAlignment.start, children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                
                  Row(children: [
                    Text('${getTranslated('order_id', context)} : ', style: poppinsRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                
                    Text(orderProvider.trackModel!.id.toString(), style: poppinsSemiBold),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(children: [

                    Text('${getTranslated(itemsQuantity > 1 ? 'items' : 'item', context)}:', style: poppinsRegular),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                    Text('$itemsQuantity', style: poppinsSemiBold),

                  ]),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(DateConverterHelper.isoStringToLocalDateOnly(orderProvider.trackModel!.createdAt!), style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                  timeSlot != null ? FittedBox(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Row(children: [
                        Text('${getTranslated('delivered_time', context)}:', style: poppinsRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(DateConverterHelper.convertTimeRange(timeSlot!.startTime!, timeSlot!.endTime!, context), style: poppinsMedium),
                      ]),
                    ]),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  if(orderProvider.trackModel?.deliveryDate != null) Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: FittedBox(
                      child: Row(children: [
                        Text('${getTranslated('estimate_delivery_date', context)}: ', style: poppinsRegular),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      
                        Text(DateConverterHelper.isoStringToLocalDateOnly(orderProvider.trackModel!.deliveryDate!), style: poppinsMedium),
                      ]),
                    ),
                  ),


                ]),
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start, children: [
                const _OrderTypeWidget(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: OrderStatus.pending.name == orderProvider.trackModel!.orderStatus ? ColorResources.colorBlue.withOpacity(0.08)
                        : OrderStatus.out_for_delivery.name == orderProvider.trackModel!.orderStatus ? ColorResources.ratingColor.withOpacity(0.08)
                        : OrderStatus.canceled.name == orderProvider.trackModel!.orderStatus ? ColorResources.redColor.withOpacity(0.08) : ColorResources.colorGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                  ),
                  child: Text(
                    getTranslated(orderProvider.trackModel!.orderStatus, context),
                    style: poppinsRegular.copyWith(color: OrderStatus.pending.name == orderProvider.trackModel!.orderStatus ? ColorResources.colorBlue
                        : OrderStatus.out_for_delivery.name == orderProvider.trackModel!.orderStatus ? ColorResources.ratingColor
                        : OrderStatus.canceled.name == orderProvider.trackModel!.orderStatus ? ColorResources.redColor : ColorResources.colorGreen),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                if(orderProvider.trackModel!.orderType == 'delivery' &&
                    (splashProvider.configModel?.googleMapStatus ?? false) &&
                    (orderProvider.trackModel?.deliveryAddress?.longitude?.isNotEmpty ?? false) && (orderProvider.trackModel?.deliveryAddress?.latitude?.isNotEmpty ?? false)
                )  InkWell(
                  onTap: () {

                    print('-------------(TRACK ORDER MODEL)-------------${orderProvider.trackModel?.toJson().toString()}');

                    if(orderProvider.trackModel!.deliveryAddress != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderMapInfoWidget(address: orderProvider.trackModel!.deliveryAddress)));
                    }
                    else{
                      showCustomSnackBarHelper(getTranslated('address_not_found', context), isError: true);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1.5, color: Theme.of(context).primaryColor.withOpacity(0.1)),
                    ),
                    child: Image.asset(Images.deliveryAddressIcon, color: Theme.of(context).primaryColor, height: 20, width: 20),
                  ),
                ),




              ]),

            ]),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            /// Payment info
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 1, blurRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(
                        getTranslated('payment_info', context),
                        style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                    if(orderProvider.trackModel?.paymentMethod == 'offline_payment' && (!ResponsiveHelper.isDesktop(context)))
                      SizedBox(
                        width: 120, height: 50,
                        child: CustomButtonWidget(
                          borderRadius: Dimensions.paddingSizeDefault,
                          margin: Dimensions.paddingSizeSmall,
                          buttonText: getTranslated('see_details', context),
                          onPressed: (){
                            ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                              child: PaymentInfoWidget(deliveryAddress: orderModel?.deliveryAddress),
                            ));
                          },
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
                          textStyle: poppinsRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                      )
                  ]),
                  Divider(height: 20, color: Theme.of(context).dividerColor.withOpacity(0.3)),

                  Row(children: [
                    Text('${getTranslated('status', context)} : ', style: poppinsRegular),

                    Text(
                      getTranslated(orderProvider.trackModel!.paymentStatus, context),
                      style: poppinsMedium,
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(children: [
                    Text('${getTranslated('method', context)} : ', style: poppinsRegular, maxLines: 1, overflow: TextOverflow.ellipsis),

                    Row(children: [
                      (orderProvider.trackModel!.paymentMethod != null && orderProvider.trackModel!.paymentMethod!.isNotEmpty) && orderProvider.trackModel!.paymentMethod == 'cash_on_delivery' ? Text(
                        getTranslated('cash_on_delivery', context), style: poppinsMedium
                      ) : Text(
                        (orderProvider.trackModel!.paymentMethod != null && orderProvider.trackModel!.paymentMethod!.isNotEmpty)
                            ? '${orderProvider.trackModel!.paymentMethod![0].toUpperCase()}${orderProvider.trackModel!.paymentMethod!.substring(1).replaceAll('_', ' ')}'
                            : 'Digital Payment', style: poppinsMedium,
                      ),

                      if(orderProvider.trackModel?.paymentStatus == 'partially_paid')
                        Text(' + ${getTranslated('wallet', context)}', style: poppinsMedium),

                      if(orderProvider.trackModel?.paymentMethod == 'offline_payment' && ResponsiveHelper.isDesktop(context))
                        SizedBox(
                          width: 120, height: 45,
                          child: CustomButtonWidget(
                            borderRadius: Dimensions.paddingSizeDefault,
                            margin: Dimensions.paddingSizeSmall,
                            buttonText: getTranslated('see_details', context),
                            onPressed: (){
                              ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                                child: PaymentInfoWidget(deliveryAddress: orderModel?.deliveryAddress),
                              ));
                            },
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
                            textStyle: poppinsRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                        )

                    ]),


                  ]),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const OrderedProductListWidget(),


            (orderProvider.trackModel?.orderNote?.isNotEmpty ?? false) ? Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              width: Dimensions.webScreenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
              ),
              child: Text(orderProvider.trackModel?.orderNote ?? '', style: poppinsRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
              )),
            ) : const SizedBox(),

           if(orderProvider.trackModel?.orderImageList?.isNotEmpty ?? false) Container(
             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Theme.of(context).cardColor,
               boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 1, blurRadius: 5)],
             ),
             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               Text(
                 splashProvider.configModel?.orderImageLabelName ?? '',
                 style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
               ),
               Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).dividerColor.withOpacity(0.3)),

               Row(
                 children: [
                   CustomSingleChildListWidget(
                     scrollDirection: Axis.horizontal,
                     itemCount: orderProvider.trackModel?.orderImageList?.length ?? 0,
                     itemBuilder: (index){

                       return InkWell(
                         onTap: (){

                           if(ResponsiveHelper.isDesktop(context)) {

                             showDialog(context: context, builder: (ctx)=> CustomAlertDialogWidget(child: ClipRRect(
                               borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                               child: CustomZoomWidget(
                                 image: CustomImageWidget(
                                     fit: BoxFit.contain,
                                     width: 400, height: 400,
                                     image: '${splashProvider.configModel?.baseUrls?.orderImageUrl}/${orderProvider.trackModel?.orderImageList?[index].image}'
                                 ),
                               ),
                             )));

                           }else {
                             Navigator.of(context).pushNamed(
                               RouteHelper.getProductImagesRoute(
                                 getTranslated('image', context),
                                 jsonEncode([orderProvider.trackModel?.orderImageList?[index].image ?? '']),
                                 splashProvider.configModel?.baseUrls?.orderImageUrl ?? '',
                               ),
                             );
                           }
                         },
                         child: Padding(
                           padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                           child: ClipRRect(
                             borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                             child: CustomImageWidget(
                                 width: 100, height: 100,
                                 image: '${splashProvider.configModel?.baseUrls?.orderImageUrl}/${orderProvider.trackModel?.orderImageList?[index].image}'
                             ),
                           ),
                         ),
                       );
                     },
                   ),
                 ],
               ),
             ]),
           ),

            if(orderProvider.trackModel?.orderImageList?.isNotEmpty ?? false) const SizedBox(height: Dimensions.paddingSizeDefault),

          ],
        );
      }
    );
  }
}

class _OrderTypeWidget extends StatelessWidget {
  const _OrderTypeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return orderProvider.trackModel?.orderType != 'delivery' ? Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
      ),
      child: Text(
        getTranslated(orderProvider.trackModel?.orderType == 'pos' ? 'pos_order' : 'self_pickup', context),
        style: poppinsRegular,
      ),
    ) : const SizedBox();
  }

}


