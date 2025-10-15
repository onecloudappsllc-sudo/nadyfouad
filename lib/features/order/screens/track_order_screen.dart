import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/order_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/order_constants.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/order/widgets/custom_stepper_widget.dart';
import 'package:flutter_grocery/features/order/widgets/delivery_man_widget.dart';
import 'package:flutter_grocery/features/order/widgets/track_order_shimmer_widget.dart';
import 'package:flutter_grocery/features/order/widgets/track_order_web_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/features/order/widgets/tracking_map_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TrackOrderScreen extends StatefulWidget {
  final String? orderID;
  final bool isBackButton;
  final OrderModel? orderModel;
  final String? phone;
  const TrackOrderScreen({Key? key, required this.orderID, this.isBackButton = false, this.orderModel, this.phone}) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {

  @override
  void initState() {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Provider.of<LocationProvider>(context, listen: false).initAddressList();


    orderProvider.trackOrder(widget.orderID, widget.orderModel,  context, true, isUpdate: false, phoneNumber: widget.phone ).whenComplete((){
      if(orderProvider.trackModel?.deliveryMan != null){
        orderProvider.getDeliveryManData(widget.orderID, context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ConfigModel? config = Provider.of<SplashProvider>(context, listen: false).configModel;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): CustomAppBarWidget(
        title: getTranslated('track_order', context),
        isCenter: false,
      )) as PreferredSizeWidget?,
      body: Column(children: [
        Expanded(child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Center(child: Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              String? status;
              bool isOrderFailed = status == OrderConstants.failed || status == OrderConstants.returned || status == OrderConstants.canceled;

              if (orderProvider.trackModel != null) {
                status = orderProvider.trackModel!.orderStatus;
              }

              return orderProvider.isLoading ? const TrackOrderShimmerWidget() : orderProvider.trackModel != null ? orderProvider.trackModel?.id == null ? NoDataWidget(
                title: getTranslated('order_not_found', context),
              )  :  Container(
                margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? (width - Dimensions.webScreenWidth) / 2 : Dimensions.paddingSizeDefault),
                decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                  color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                ) : null,
                child: ResponsiveHelper.isDesktop(context) ? const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: TrackOrderWebWidget(phoneNumber: null),
                ) : Column(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 0.5, blurRadius: 0.5)
                      ],
                    ),
                    child: Column(children: [
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

                      const Divider(height: Dimensions.paddingSizeDefault),

                      if(orderProvider.orderType != OrderConstants.selfPickUp)  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Image.asset(Images.wareHouse, color: Theme.of(context).primaryColor, width: Dimensions.paddingSizeLarge),
                            const SizedBox(width: 20),

                            if(orderProvider.trackModel?.branchId != null) Expanded(child: Text(
                              '${OrderHelper.getBranch(id: orderProvider.trackModel!.branchId!, branchList: splashProvider.configModel?.branches ?? [])?.address}',
                              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                            )),
                          ]),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            height: Dimensions.paddingSizeExtraLarge,
                            child: CustomPaint(
                              size: const Size(1, double.infinity),
                              painter: DashedLineVerticalPainter(isActive: false),
                            ),
                          ),

                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                orderProvider.trackModel!.deliveryAddress != null? orderProvider.trackModel!.deliveryAddress!.address! : getTranslated('address_was_deleted', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                            ),
                          ]),
                        ],
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      if(orderProvider.trackModel!.deliveryMan != null) DeliveryManWidget(deliveryMan: orderProvider.trackModel!.deliveryMan),




                    ]),
                  ),

                  Column(children: [
                    CustomStepperWidget(
                      title: getTranslated('order_placed', context),
                      isComplete: true,
                      isActive: status == OrderConstants.pending,
                      haveTopBar: false,
                      statusImage: Images.orderPlace,
                      subTitleWidget: Row(children: [
                        const Icon(Icons.schedule, size: Dimensions.fontSizeLarge),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(DateConverterHelper.localDateToIsoStringAMPM(DateConverterHelper.convertStringToDatetime(orderProvider.trackModel!.createdAt!), context)),
                      ]),
                    ),

                    if(isOrderFailed) CustomStepperWidget(
                      height: orderProvider.trackModel?.deliveryMan == null ? 30 : 130,
                      title: getTranslated(status, context),
                      isComplete: isOrderFailed,
                      isActive: isOrderFailed,
                      statusImage: Images.orderFailed,
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

                    Consumer<LocationProvider>(builder: (context, locationProvider, _) {
                      return CustomStepperWidget(
                        title: getTranslated('order_is_on_the_way', context),
                        isComplete: status == OrderConstants.outForDelivery || status == OrderConstants.delivered,
                        statusImage: Images.outForDelivery,
                        isActive: status == OrderConstants.outForDelivery,
                        subTitle: getTranslated('your_delivery_man_is_coming', context),
                        trailing: orderProvider.trackModel?.deliveryMan?.phone != null ? InkWell(
                          onTap: ()=> launchUrlString('tel:${orderProvider.trackModel?.deliveryMan?.phone}'),
                          child: const Icon(Icons.phone_in_talk),
                        ) : const SizedBox(),
                      );
                    }),


                    CustomStepperWidget(
                      height: (config?.googleMapStatus ?? false) ? orderProvider.trackModel?.deliveryMan == null ? 30 : 130 : 30,
                      title: getTranslated('order_delivered', context),
                      isComplete: status == OrderConstants.delivered,
                      isActive: status == OrderConstants.delivered,
                      statusImage: Images.orderDelivered,
                      child: orderProvider.deliveryManModel != null ? TrackingMapWidget(
                        deliveryManModel: orderProvider.deliveryManModel,
                        orderID: '${orderProvider.trackModel?.id}',
                        addressModel: orderProvider.trackModel!.deliveryAddress,
                        branchID: orderProvider.trackModel!.branchId,
                      ) : const SizedBox(),
                    ),
                  ]),

                ]),
              ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
            },
          ))),

          const FooterWebWidget(footerType: FooterType.sliver),
        ])),
        
      ]),
    );
  }
}

