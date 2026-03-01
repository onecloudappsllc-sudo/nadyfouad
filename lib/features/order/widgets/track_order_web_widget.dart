import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/order_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/order_constants.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/order/widgets/custom_stepper_widget.dart';
import 'package:provider/provider.dart';

class TrackOrderWebWidget extends StatelessWidget {
  const TrackOrderWebWidget({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          String status = orderProvider.trackModel?.orderStatus ?? '';
          bool isOrderFailed = status == OrderConstants.failed || status == OrderConstants.returned || status == OrderConstants.canceled;

          return orderProvider.trackModel != null && orderProvider.trackModel?.id != null ?   Column(children: [
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(
                '${getTranslated('order_id', context)} #${orderProvider.trackModel!.id}',
                style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              )),

              CustomDirectionalityWidget(child: Text(
                PriceConverterHelper.convertPrice(context, orderProvider.trackModel!.orderAmount),
                style: poppinsBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
              )),
            ]),
            const Divider(height: Dimensions.paddingSizeExtraLarge),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Image.asset(Images.wareHouse, color: Theme.of(context).primaryColor, width: Dimensions.paddingSizeLarge),
                    const SizedBox(width: 20),

                    if(orderProvider.trackModel?.branchId != null) Text(
                      '${OrderHelper.getBranch(id: orderProvider.trackModel!.branchId!, branchList: splashProvider.configModel?.branches ?? [])?.address}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ]),
                ),

                if(OrderHelper.isShowDeliveryAddress(orderProvider.trackModel)) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: CustomPaint(
                    size: const Size(50, 2),
                    painter: DashedLineVerticalPainter(isActive: false, axis: Axis.horizontal),
                  ),
                ),

                if(OrderHelper.isShowDeliveryAddress(orderProvider.trackModel)) Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 20),

                    ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400), child: Text(
                         orderProvider.trackModel?.orderType == 'take_away'
                             ? getTranslated('take_away', context)
                             :  orderProvider.trackModel!.deliveryAddress != null
                             ? orderProvider.trackModel!.deliveryAddress!.address!
                             : getTranslated('address_was_deleted', context),
                        overflow: TextOverflow.ellipsis, maxLines: 1,
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      )),
                  ]),
                ),
              ]),

              if(phoneNumber != null) InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteHelper.getOrderDetailsRoute(
                      '${orderProvider.trackModel!.id}',
                      phoneNumber: phoneNumber
                  ));
                },
                child: Container(
                  width: 120, height: 40,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 2),
                  ),
                  child: Text(getTranslated('view_details', context), style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor)),
                ),
              ),

            ]),
            const SizedBox(height: 50),

            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomStepperWidget(
                title: getTranslated('order_placed', context),
                isComplete: true,
                isActive: status == OrderConstants.pending,
                statusImage: Images.orderPlace,
                subTitleWidget: Row(children: [
                  const Icon(Icons.schedule, size: Dimensions.fontSizeLarge),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(DateConverterHelper.localDateToIsoStringAMPM(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!), context),
                    style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ]),
              ),

              if(isOrderFailed) CustomStepperWidget(
                height: orderProvider.trackModel?.deliveryMan == null ? 30 : 130,
                title: getTranslated(status, context),
                isComplete: isOrderFailed,
                isActive: isOrderFailed,
                statusImage: Images.orderFailed,
                color: status == OrderConstants.failed ? Theme.of(context).colorScheme.error : null,
              ),

              CustomStepperWidget(
                title: getTranslated('order_accepted', context),
                isComplete: status == OrderConstants.confirmed
                    || status == OrderConstants.processing
                    || status == OrderConstants.outForDelivery
                    || status == OrderConstants.delivered,
                isActive: status == OrderConstants.confirmed,
                statusImage: Images.orderAccepted,
              ),

              CustomStepperWidget(
                title: getTranslated('preparing_items', context),
                isComplete: status == OrderConstants.processing
                    || status == OrderConstants.outForDelivery
                    ||status == OrderConstants.delivered,
                statusImage: Images.preparingItems,
                isActive: status == OrderConstants.processing,
              ),

              if(!isOrderFailed)Consumer<LocationProvider>(builder: (context, locationProvider, _) {
                return CustomStepperWidget(
                  title: getTranslated('order_is_on_the_way', context),
                  isComplete: status == OrderConstants.outForDelivery || status == OrderConstants.delivered,
                  statusImage: Images.outForDelivery,
                  isActive: status == OrderConstants.outForDelivery,
                  subTitleWidget: status == OrderConstants.outForDelivery ?  Text(
                    getTranslated('your_delivery_man_is_coming', context),
                    style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  ) : const SizedBox(),
                );
              }),

              CustomStepperWidget(
                height: orderProvider.trackModel?.deliveryMan == null ? 30 : 130,
                title: getTranslated('order_delivered', context),
                isComplete: status == OrderConstants.delivered,
                isActive: status == OrderConstants.delivered,
                statusImage: Images.orderDelivered,
                haveTopBar: false,
              ),
            ]),
            const SizedBox(height: 100),

          ]) : const SizedBox();
        }
    );
  }
}
