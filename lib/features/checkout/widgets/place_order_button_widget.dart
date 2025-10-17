import 'dart:convert'as convert;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_grocery/features/checkout/screens/order_success_screen.dart';
import 'package:flutter_grocery/features/checkout/widgets/amount_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/total_amount_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/upside_expansion_widget.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/order/enums/delivery_charge_type.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;



class PlaceOrderButtonWidget extends StatelessWidget {
  final bool fromOfflinePayment;
  final double? discount;
  final double? couponDiscount;
  final double? tax;
  final double? weight;
  final ScrollController? scrollController;
  final GlobalKey? dropdownKey;

  const PlaceOrderButtonWidget({super.key, this.fromOfflinePayment = false, this.discount, this.couponDiscount, this.tax,  this.scrollController,  this.dropdownKey, this.weight});


  void _openDropdown() {
    final dropdownContext = dropdownKey?.currentContext;

    if (dropdownContext != null) {
      GestureDetector? detector;
      void searchGestureDetector(BuildContext context) {
        context.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector?;
          } else {
            searchGestureDetector(element);
          }
        });
      }
      searchGestureDetector(dropdownContext);

      detector?.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    print('-------------(PLACE ORDER BUTTON WIDGET)---------------$weight');

    return CustomShadowWidget(
      isActive: !fromOfflinePayment,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
      borderRadius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSizeDefault : Dimensions.radiusSizeLarge,
      child: Consumer<OrderProvider>(builder: (context, orderProvider, _) {

        CheckOutModel? checkOutData = orderProvider.getCheckOutData;


        final bool isSelfPickup = CheckOutHelper.isSelfPickup(orderType: checkOutData?.orderType);
        final bool isKmWiseCharge = CheckOutHelper.isKmWiseCharge(configModel: configModel);
        final double deliveryCharge = orderProvider.deliveryCharge ?? 0;
        final double amount = checkOutData?.amount ?? 0;
        final double total = deliveryCharge + amount;


        print("---------------${!fromOfflinePayment}");
        return orderProvider.isLoading ? Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)) : SizedBox(
          //width: 1170,
          child: Column(mainAxisSize: MainAxisSize.min, children: [


             if(!fromOfflinePayment) ResponsiveHelper.isDesktop(context) ? AmountWidget(total: total, weight: weight) :
             UpsideExpansionWidget(
               title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                 Text(getTranslated('total_amount', context), style: poppinsSemiBold.copyWith(
                   fontSize: Dimensions.fontSizeLarge,
                   color: Theme.of(context).textTheme.bodyMedium?.color,
                 ),),
                 CustomDirectionalityWidget(child: Text(
                   PriceConverterHelper.convertPrice(context, total + (weight ?? 0)),
                   style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyMedium?.color),
                 )),
               ]),
               children: [
                 TotalAmountWidget(
                   amount: checkOutData?.amount ?? 0,
                   freeDelivery: CheckOutHelper.isFreeDeliveryCharge(type: checkOutData?.freeDeliveryType),
                   deliveryCharge: orderProvider.deliveryCharge ?? 0,
                   discount: discount, couponDiscount: couponDiscount,
                   tax: tax, weight: weight,
                 ),
               ]
             ),

            SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

            CustomButtonWidget(
              borderRadius: fromOfflinePayment ? Dimensions.radiusSizeLarge : Dimensions.radiusSizeDefault,
            buttonText: getTranslated(fromOfflinePayment ? 'submit' : 'place_order', context),
            onPressed: () async{
              if(fromOfflinePayment){
                Navigator.pop(context);
              }

              final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
              final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);


              if(fromOfflinePayment && orderProvider.getOfflinePaymentData().isEmpty){
                showCustomSnackBarHelper(getTranslated('input_your_data_properly', context),isError: true);

              }else if((orderProvider.selectedPaymentMethod == null ? (orderProvider.selectedOfflineValue == null) : orderProvider.selectedPaymentMethod == null )){
                showCustomSnackBarHelper(getTranslated('add_a_payment_method', context));

              }  else if (!isSelfPickup && orderProvider.addressIndex == -1) {
                showCustomSnackBarHelper(getTranslated('select_delivery_address', context),isError: true);

              } else if (orderProvider.timeSlots == null || orderProvider.timeSlots!.isEmpty) {
                showCustomSnackBarHelper(getTranslated('select_a_time', context),isError: true);

              } else if (!isSelfPickup && isKmWiseCharge && orderProvider.distance == -1) {
                showCustomSnackBarHelper(getTranslated('delivery_fee_not_set_yet', context),isError: true);

              } else if((CheckOutHelper.getDeliveryChargeType() == DeliveryChargeType.area.name) && (orderProvider.selectedAreaID == null) && !isSelfPickup){
                await scrollController?.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.ease);
                _openDropdown();
              }else {
                List<CartModel> cartList = Provider.of<CartProvider>(context, listen: false).cartList;
                List<Cart> carts = [];

                for (int index = 0; index < cartList.length; index++) {
                  Cart cart = Cart(
                    productId: cartList[index].id, price: cartList[index].price,
                    discountAmount: cartList[index].discountedPrice,
                    quantity: cartList[index].quantity, taxAmount: cartList[index].tax,
                    variant: '', variation: [Variation(type: cartList[index].variation?.type)],
                  );
                  carts.add(cart);
                }

                PlaceOrderModel placeOrderBody = PlaceOrderModel(
                  cart: carts, orderType: checkOutData?.orderType,
                  couponCode: checkOutData?.couponCode,
                  orderNote: checkOutData?.orderNote,
                  branchId: configModel!.branches![orderProvider.branchIndex].id,
                  deliveryAddressId: !isSelfPickup
                      ? Provider.of<LocationProvider>(context, listen: false).addressList![orderProvider.addressIndex].id
                      : 0, distance: isSelfPickup ? 0 : orderProvider.distance,
                  couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
                  timeSlotId: orderProvider.timeSlots![orderProvider.selectTimeSlot].id,
                  paymentMethod: orderProvider.selectedOfflineValue != null
                      ? 'offline_payment' : orderProvider.selectedPaymentMethod!.getWay!,
                  deliveryDate: orderProvider.getDateList()[orderProvider.selectDateSlot],
                  couponDiscountTitle: '',
                  orderAmount: (checkOutData!.amount ?? 0) + (orderProvider.deliveryCharge ?? 0) + (weight ?? 0),
                  selectedDeliveryArea: orderProvider.selectedAreaID,
                  paymentInfo: orderProvider.selectedOfflineValue != null ?  OfflinePaymentInfo(
                    methodFields: CheckOutHelper.getOfflineMethodJson(orderProvider.selectedOfflineMethod?.methodFields),
                    methodInformation: orderProvider.selectedOfflineValue,
                    paymentName: orderProvider.selectedOfflineMethod?.methodName,
                    paymentNote: orderProvider.selectedOfflineMethod?.paymentNote,
                  ) : null,
                  isPartial: orderProvider.partialAmount == null ? '0' : '1' ,
                );


                if(placeOrderBody.paymentMethod == 'wallet_payment'
                    || placeOrderBody.paymentMethod == 'cash_on_delivery'
                    || placeOrderBody.paymentMethod == 'offline_payment'){

                  orderProvider.placeOrder(placeOrderBody, _callback);

                } else{
                  String? hostname = html.window.location.hostname;
                  String protocol = html.window.location.protocol;
                  String port = html.window.location.port;
                  final String placeOrder =  convert.base64Url.encode(convert.utf8.encode(convert.jsonEncode(placeOrderBody.toJson())));

                  String url = "customer_id=${profileProvider.userInfoModel?.id ?? authProvider.getGuestId()}&&is_guest=${authProvider.getGuestId() != null ? '1' :'0'}"
                      "&&callback=${AppConstants.baseUrl}${RouteHelper.orderSuccessful}&&order_amount=${(checkOutData.amount! + (checkOutData.deliveryCharge ?? 0)).toStringAsFixed(2)}";

                  String webUrl = "customer_id=${profileProvider.userInfoModel?.id ?? authProvider.getGuestId()}&&is_guest=${authProvider.getGuestId() != null ? '1' :'0'}"
                      "&&callback=$protocol//$hostname${kDebugMode ? ':$port' : ''}${'${RouteHelper.orderWebPayment}/get_way'}&&order_amount=${(checkOutData.amount! + (checkOutData.deliveryCharge ?? 0)).toStringAsFixed(2)}&&status=";

                  String tokenUrl = convert.base64Encode(convert.utf8.encode(ResponsiveHelper.isWeb() ? webUrl : url));
                  String selectedUrl = '${AppConstants.baseUrl}/payment-mobile?token=$tokenUrl&&payment_method=${orderProvider.selectedPaymentMethod?.getWay}&&payment_platform=${kIsWeb ? 'web' : 'app'}&&is_partial=${orderProvider.partialAmount == null ? '0' : '1'}';


                  orderProvider.clearPlaceOrder().then((_) => orderProvider.setPlaceOrder(placeOrder).then((value) {
                    if(ResponsiveHelper.isWeb()){
                      html.window.open(selectedUrl,"_self");

                    }else{
                      Navigator.pushReplacementNamed(context, RouteHelper.getPaymentRoute(
                        url: selectedUrl,
                      ));

                    }

                  }));
                }
              }
            },
          ),
          ]),
        );
      }),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(Get.context!, listen: false).clearCartList();
      Provider.of<OrderProvider>(Get.context!, listen: false).stopLoader();
      if ( Provider.of<OrderProvider>(Get.context!, listen: false).paymentMethod?.getWay != 'cash_on_delivery') {
        Navigator.pushReplacementNamed(Get.context!,
          '${'${RouteHelper.orderSuccessful}/'}$orderID/success',
          arguments: OrderSuccessScreen(
            orderID: orderID, status: 0,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(Get.context!, '${RouteHelper.orderSuccessful}/$orderID/success');
      }
    } else {
      showCustomSnackBarHelper(message);
    }
  }
}


