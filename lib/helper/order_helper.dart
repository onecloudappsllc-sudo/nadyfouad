
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/features/order/domain/models/timeslote_model.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/order_constants.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

class OrderHelper{
  static Branches? getBranch({required int id,required List<Branches> branchList}){
    Branches? branches;
    for(Branches branch in branchList) {
      if(id == branch.id) {
        branches = branch;
        break;
      }
    }
    return branches;
  }

  static double getDeliveryCharge({required OrderModel? orderModel})=> (orderModel?.deliveryCharge ?? 0) + (orderModel?.weightChargeAmount ?? 0);



  static double getOrderDetailsValue({required  List<OrderDetailsModel>? orderDetailsList, required OrderValue type }){
    double? value;

    if(orderDetailsList != null) {
      double itemsPrice = 0;
      double discount = 0;
      double tax = 0;


      for(OrderDetailsModel orderDetails in orderDetailsList) {
        switch(type) {
          case OrderValue.itemPrice:
            itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
            value = itemsPrice;

            break;

          case OrderValue.discount:
            discount = discount + (orderDetails.discountOnProduct! * orderDetails.quantity!);
            value =  discount;
            break;

          case OrderValue.tax:
            tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!);
            value = tax;
            break;
        }
      }
    }
    return value ?? 0;
  }
  static bool isVatTaxInclude({required  List<OrderDetailsModel>? orderDetailsList}){
    bool? isVatInclude;
    if(orderDetailsList != null){
      for(OrderDetailsModel orderDetails in orderDetailsList) {
        isVatInclude = orderDetails.isVatInclude;
      }
    }
    return isVatInclude ?? false;
  }

  static double getExtraDiscount({required OrderModel? trackOrder})=> trackOrder?.extraDiscount ?? 0;

  static double getSubTotalAmount({
    required double itemsPrice,
    required double tax,
    required isVatInclude,
  })=> itemsPrice + (isVatInclude! ? 0 : tax);

  static double getTotalOrderAmount({
    required double subTotal,
    required double discount,
    required double extraDiscount,
    required double deliveryCharge,
    required double? couponDiscount,
  })=> (subTotal + deliveryCharge) - (discount + extraDiscount  + (couponDiscount ?? 0));

  static TimeSlotModel? getTimeSlot({required List<TimeSlotModel>? timeSlotList, required int? timeSlotId}){
    TimeSlotModel? timeSlotModel;
    try{
       timeSlotModel = timeSlotList?.firstWhere((timeSlot) => timeSlot.id == timeSlotId);
    }catch(c) {
      timeSlotModel = null;
    }
    return timeSlotModel;
  }


  static List<OrderDetailsModel> getOrderDetailsList({required  List<OrderDetailsModel>? orderList}){
    List<OrderDetailsModel> orderDetailsList = [];
    List<int?> orderIdList = [];

    if(orderList != null){
      for (OrderDetailsModel orderDetails in orderList) {
        if(orderDetails.productDetails != null) {
          if(!orderIdList.contains(orderDetails.productDetails!.id)) {
            orderDetailsList.add(orderDetails);
            orderIdList.add(orderDetails.productDetails!.id);
          }
        }
      }
    }
    return orderDetailsList;
  }

  static List<OrderPartialPayment> getPaymentList(OrderModel? trackOrder){
    List<OrderPartialPayment> paymentList = [];

    if(trackOrder != null &&  trackOrder.orderPartialPayments != null && trackOrder.orderPartialPayments!.isNotEmpty){

      paymentList.addAll(trackOrder.orderPartialPayments!);

      if(trackOrder.paymentStatus == 'partially_paid' && (trackOrder.orderPartialPayments!.first.dueAmount ?? 0) > 0){
        paymentList.add(OrderPartialPayment(
          id: -1, paidAmount: 0, paidWith: trackOrder.paymentMethod,
          dueAmount: trackOrder.orderPartialPayments!.first.dueAmount,
        ));
      }
    }

    return paymentList;
  }

 static CartModel? getReorderCartData({required Product? product, required String? selectVariationType, OrderDetailsModel? orderDetailsModel}) {
    CartModel? cartModel;

    if(product == null && product?.id != null && orderDetailsModel != null) {
      print('=====re order----> ${getVariationValue(orderDetailsModel.formattedVariation)}');
      product = Product(
        id: orderDetailsModel.productId,
        price: orderDetailsModel.productDetails?.price,
        name: orderDetailsModel.productDetails?.name,
        capacity: orderDetailsModel.productDetails?.capacity,
        image: orderDetailsModel.productDetails!.image!.isNotEmpty ? orderDetailsModel.productDetails!.image![0] : '',
        taxType: orderDetailsModel.productDetails?.taxType,
        tax: orderDetailsModel.productDetails?.tax,
        variations: [Variations(type: getVariationValue(orderDetailsModel.formattedVariation), price: orderDetailsModel.productDetails?.price, stock: 0)],
        discount: orderDetailsModel.productDetails?.discount,
        discountType: orderDetailsModel.productDetails?.discountType,
        unit: orderDetailsModel.productDetails?.unit,
        totalStock: 0,
        maximumOrderQuantity: 0,
        status: 0,
      );
    }


    if(product != null) {
      double? price = product.price;
      int? stock = product.totalStock;
      Variations? selectedVariation;


      for(Variations variation in product.variations!) {
        if (selectVariationType != null &&  variation.type == selectVariationType) {
          price = variation.price;
          selectedVariation = variation;
          stock = variation.stock;
          break;
        }
      }

      cartModel = CartModel(
        product.id,
        product.image!.isNotEmpty ? product.image![0] : '',
        product.name, price,
        PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType),
        1, selectedVariation,
        (price!-PriceConverterHelper.convertWithDiscount(price, product.discount, product.discountType)!),
        (price-PriceConverterHelper.convertWithDiscount(price, product.tax, product.taxType)!),
        product.capacity,
        product.unit,
        stock,
        product,
      );
    }

    return cartModel;

  }

  static void addToCartReorderProduct({required List<CartModel> cartList}){
    final CartProvider cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    List<CartModel> availableCartList = [];
    Navigator.pop(Get.context!);



    for(int i = 0; i < cartList.length; i++) {

      if(cartProvider.isExistInCart(cartList[i]) == null && (cartList[i].stock != null && cartList[i].stock! > 1)) {
        availableCartList.add(cartList[i]);
      }
    }


    if(availableCartList.isNotEmpty){
      for (var cartModel in availableCartList) {
        cartProvider.addToCart(cartModel);
      }

      if(ResponsiveHelper.isMobilePhone()) {
        splashProvider.setPageIndex(2);
      }else{
        Navigator.pushNamed(Get.context!, RouteHelper.getCartScreen());
      }
    }else{
      showCustomSnackBarHelper(getTranslated('add_to_cart_is_not_available', Get.context!));
    }
  }


  static double getTotalAmount({required double? subTotal, required double? deliveryCharge}){
    return (subTotal ?? 0) + (deliveryCharge ?? 0);
  }

  static bool isShowDeliveryAddress(OrderModel? trackOrder) {
    return trackOrder != null && trackOrder.orderType == OrderConstants.deliveryType && trackOrder.deliveryAddress != null;
  }

  static double getOrderItemQuantity(List<OrderDetailsModel>? orderDetailsList){
    double quantity = 0;
    if(orderDetailsList != null) {
      for(int i = 0; i < orderDetailsList.length; i++) {
        quantity = quantity + (orderDetailsList[i].quantity ?? 0);
      }
    }
    return quantity;
  }

  static String getVariationValue(Map<String, dynamic>? orderVariation) {
    String variation = '';

    orderVariation?.forEach((key, value) {
      variation = '$variation ${variation.isEmpty ? '' : '-'} $value';
    });

    return variation.replaceAll(' ', '');
  }


}

enum OrderValue{
  itemPrice, discount, tax,
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  out_for_delivery,
  delivered,
  returned,
  failed,
  canceled,
}