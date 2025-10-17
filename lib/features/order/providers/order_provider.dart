
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/order/domain/models/distance_model.dart';
import 'package:flutter_grocery/features/order/domain/models/offline_payment_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/order/domain/models/timeslote_model.dart';
import 'package:flutter_grocery/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_grocery/features/order/providers/image_note_provider.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/features/order/domain/models/delivery_man_model.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/order_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;
  OrderProvider({ required this.sharedPreferences,required this.orderRepo});

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? _historyOrderList;
  List<OrderDetailsModel>? _orderDetails;
  int? _paymentMethodIndex;
  OrderModel? _trackModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? _allTimeSlots;
  bool _isActiveOrder = true;
  int _branchIndex = 0;
  String? _orderType = 'delivery';
  ResponseModel? _responseModel;
  DeliveryManModel? _deliveryManModel;
  double _distance = -1;
  double? _deliveryCharge;
  PaymentMethod? _paymentMethod;
  PaymentMethod? _selectedPaymentMethod;
  double? _partialAmount;
  OfflinePaymentModel? _selectedOfflineMethod;
  List<Map<String, String>>? _selectedOfflineValue;
  bool _isOfflineSelected = false;
  CheckOutModel? _checkOutData;
  int? _reOrderIndex;
  int? _selectedAreaID;

  List<TimeSlotModel>? get timeSlots => _timeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  int? get paymentMethodIndex => _paymentMethodIndex;
  OrderModel? get trackModel => _trackModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  bool get isActiveOrder => _isActiveOrder;
  int get branchIndex => _branchIndex;
  String? get orderType => _orderType;
  ResponseModel? get responseModel => _responseModel;
  DeliveryManModel? get deliveryManModel => _deliveryManModel;
  double get distance => _distance;
  PaymentMethod? get paymentMethod => _paymentMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  double? get partialAmount => _partialAmount;
  OfflinePaymentModel? get selectedOfflineMethod => _selectedOfflineMethod;
  List<Map<String, String>>? get selectedOfflineValue => _selectedOfflineValue;
  bool get isOfflineSelected => _isOfflineSelected;
  CheckOutModel? get getCheckOutData => _checkOutData;
  int? get getReOrderIndex => _reOrderIndex;
  int? get selectedAreaID => _selectedAreaID;
  double? get deliveryCharge => _deliveryCharge;

  Map<String, TextEditingController> field  = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  set setCheckOutData(CheckOutModel value) {
    _checkOutData = value;
  }

  set setReorderIndex(int value) {
    _reOrderIndex = value;
  }


  Future<void> getOrderList(BuildContext context) async {
    ApiResponseModel apiResponse = await orderRepo!.getOrderList();
    if (apiResponse.response?.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response?.data.forEach((order) {

        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList!.add(orderModel);
        } else if (orderModel.orderStatus == 'delivered'||
            orderModel.orderStatus == 'returned' ||
            orderModel.orderStatus == 'failed' ||
            orderModel.orderStatus == 'canceled') {
          _historyOrderList!.add(orderModel);
        }
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> initializeTimeSlot() async {
    _distance = -1;
    ApiResponseModel apiResponse = await orderRepo!.getTimeSlot();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _timeSlots = [];
      _allTimeSlots = [];
      apiResponse.response!.data.forEach((timeSlot) {

        _timeSlots!.add(TimeSlotModel.fromJson(timeSlot));

        _allTimeSlots!.add(TimeSlotModel.fromJson(timeSlot));

      });
      validateSlot(_allTimeSlots, 0);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  List<String> getDateList() {
    return orderRepo!.getDateList();
  }

  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;

  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    _selectTimeSlot = index;
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel>? slots, int dateIndex) {
    _timeSlots = [];
    if(dateIndex == 0) {
      DateTime date = DateTime.now();
      for (var slot in slots!) {
        DateTime time = DateConverterHelper.stringTimeToDateTime(slot.endTime!).subtract(const Duration(/*hours: 1*/minutes: 30));
        DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second);
        if (dateTime.isAfter(DateTime.now())) {
          _timeSlots!.add(slot);
        }
      }
    }else {
      _timeSlots!.addAll(_allTimeSlots!);
    }
  }

  double subTotal = 0;
  double discount = 0;
  double totalPrice = 0;

  Future<List<OrderDetailsModel>?> getOrderDetails({required String orderID, String? phoneNumber}) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;
    subTotal = 0;
    discount = 0;
    totalPrice = 0;
    notifyListeners();
    ApiResponseModel apiResponse = await orderRepo!.getOrderDetails(orderID, phoneNumber);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response?.data.forEach((orderDetail) => _orderDetails?.add(OrderDetailsModel.fromJson(orderDetail)));
      for (var element in _orderDetails!) {
        try{
          subTotal += double.parse(element.productDetails!.price.toString());
          discount += double.parse(element.productDetails!.discount.toString());
          totalPrice += double.parse(element.price.toString());
        }catch(e){
          subTotal = 0;
          discount =0;
          totalPrice = 0;
        }

      }

    } else {
      _orderDetails = [];
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void changeActiveOrderStatus(bool status, {bool isUpdate = true}) {
    _isActiveOrder = status;

   if(isUpdate){
     notifyListeners();
   }
  }

  Future<void> getDeliveryManData(String? orderID, BuildContext context) async {
    ApiResponseModel apiResponse = await orderRepo!.getDeliveryManData(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response!.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(String? orderID, OrderModel? orderModel, BuildContext context, bool fromTracking, {String? phoneNumber, bool isUpdate = true}) async {
    _trackModel = null;
    ResponseModel responseModel;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      if(isUpdate){
        notifyListeners();
      }

      ApiResponseModel apiResponse = await orderRepo!.trackOrder(orderID, phoneNumber);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response!.data);
        responseModel = ResponseModel(true, apiResponse.response!.data.toString());
      } else {
        _orderDetails = [];
        _trackModel = OrderModel();
        responseModel = ResponseModel(false, ApiCheckerHelper.getError(apiResponse).errors?.first.message);
        ApiCheckerHelper.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }else {
      _trackModel = orderModel;
      responseModel = ResponseModel(true, 'Successful');
    }
    return responseModel;
  }

  Future<void> placeOrder(PlaceOrderModel placeOrderBody, Function callback) async {
    final OrderImageNoteProvider imageNoteProvider = Provider.of<OrderImageNoteProvider>(Get.context!, listen: false);

    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderRepo!.placeOrder(placeOrderBody, imageNote: imageNoteProvider.imageFiles ?? []);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      String? message = apiResponse.response!.data['message'];
      String orderID = apiResponse.response!.data['order_id'].toString();
      callback(true, message, orderID);
      debugPrint('-------- Order placed successfully $orderID ----------');
    } else {
      callback(false, ApiCheckerHelper.getError(apiResponse).errors![0].message, '-1');
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index, {bool notify = true}) {
    _addressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void cancelOrder(String orderID, bool fromOrder, Function callback, ) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await orderRepo!.cancelOrder(orderID);
    _isLoading = false;


    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      trackOrder(orderID, null, Get.context!, false, isUpdate: true);
      getOrderDetails(orderID: orderID);

      if(fromOrder){
       OrderModel? orderModel;
       for (var order in _runningOrderList!) {
         if (order.id.toString() == orderID) {
           orderModel = order;
         }
       }
       _runningOrderList!.remove(orderModel);
     }
      _showCancelled = true;
      callback(apiResponse.response?.data['message'], true, orderID);
    } else {

      callback(ApiCheckerHelper.getError(apiResponse).errors?.first.message, false, '-1');
    }
    notifyListeners();
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    _distance = -1;
    notifyListeners();
  }

  void setOrderType(String? type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      notifyListeners();
    }
  }


  void setDeliveryCharge(double? charge, {bool notify = true}) {
    _deliveryCharge = charge;
    if(notify) {
      notifyListeners();
    }
  }


  bool _isDistanceLoading = false;
  bool get isDistanceLoading => _isDistanceLoading;

  Future<bool> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    _isDistanceLoading = true;
    notifyListeners();
    bool isSuccess = false;
    ApiResponseModel response = await orderRepo!.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.response!.statusCode == 200 && response.response!.data['status'] == 'OK') {
        isSuccess = true;
        _distance = DistanceModel.fromJson(response.response!.data).rows![0].elements![0].distance!.value! / 1000;
      } else {
        _distance = Geolocator.distanceBetween(
          originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
        ) / 1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
        originLatLng.latitude, originLatLng.longitude, destinationLatLng.latitude, destinationLatLng.longitude,
      ) / 1000;
    }

    print("--------------------(DISTANCE CALCULATION)------------------$distance");
    _isDistanceLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<void> setPlaceOrder(String placeOrder)async{
    await sharedPreferences!.setString(AppConstants.placeOrderData, placeOrder);
  }
  String? getPlaceOrder(){
    return sharedPreferences!.getString(AppConstants.placeOrderData);
  }
  Future<void> clearPlaceOrder()async{
    await sharedPreferences!.remove(AppConstants.placeOrderData);
  }

  void clearPrevData({bool isUpdate = false}) {
    _paymentMethod = null;
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
    _selectedPaymentMethod = null;
    _selectedOfflineMethod = null;
    _distance = -1;
    _trackModel = null;
    _partialAmount = null;
    _isLoading = false;
    clearOfflinePayment();
    if(isUpdate){
      notifyListeners();
    }
  }

  void setPaymentIndex(int? index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    _paymentMethod = null;
    if(isUpdate){
      notifyListeners();
    }
  }

  void changePaymentMethod({PaymentMethod? digitalMethod, bool isUpdate = true, OfflinePaymentModel? offlinePaymentModel, bool isClear = false}){
    if(offlinePaymentModel != null){
      _selectedOfflineMethod = offlinePaymentModel;
    }else if(digitalMethod != null){
      _paymentMethod = digitalMethod;
      _paymentMethodIndex = null;
      _selectedOfflineMethod = null;
      _selectedOfflineValue = null;
    }
    if(isClear){
      _paymentMethod = null;
      _selectedPaymentMethod = null;
      clearOfflinePayment();

    }
    if(isUpdate){
      notifyListeners();
    }
  }
  void clearOfflinePayment(){
    _selectedOfflineMethod = null;
    _selectedOfflineValue = null;
    _isOfflineSelected = false;
  }


  void savePaymentMethod({int? index, PaymentMethod? method, bool isUpdate = true}){
    if(method != null){
      _selectedPaymentMethod = method.copyWith('online');
    }else if(index != null && index == 0){
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('cash_on_delivery', Get.context!),
        getWay: 'cash_on_delivery',
        type: 'cash_on_delivery',
      );
    }else if(index != null && index == 1){
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('wallet_payment', Get.context!),
        getWay: 'wallet_payment',
        type: 'wallet_payment',
      );
    }else{
      _selectedPaymentMethod = null;
    }

    if(isUpdate){
      notifyListeners();
    }

  }

  void setOfflineSelectedValue(List<Map<String, String>>? data, {bool isUpdate = true}){
    _selectedOfflineValue = data;

    if(isUpdate){
      notifyListeners();
    }
  }

  void setOfflineSelect(bool value){
    _isOfflineSelected = value;
    notifyListeners();
  }

  void changePartialPayment({double? amount,  bool isUpdate = true}){
    _partialAmount = amount;
    if(isUpdate) {
      notifyListeners();
    }
  }

  List<Map<String, String>> getOfflinePaymentData(){
    List<Map<String, String>>? data = [];

    if(formKey.currentState!.validate()){
      setOfflineSelectedValue(null);

      field.forEach((key, value) {
        data.add({key : value.text});
      });
      setOfflineSelectedValue(data);

    }
    return data;
  }

  List<CartModel> reOrderCartList = [];


  Future<List<CartModel>?> reorderProduct(String orderId) async {
    _isLoading = true;
    notifyListeners();

    final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);

    List<OrderDetailsModel>? orderDetailsList = await getOrderDetails(orderID: orderId);
    reOrderCartList = [];

    for(OrderDetailsModel orderDetails in orderDetailsList ?? []) {
      Product? product;
      String? selectVariationType;



      if(orderDetails.formattedVariation != null) {
        selectVariationType = OrderHelper.getVariationValue(orderDetails.formattedVariation);
      }


      try{
        product = await productProvider.getProductDetails('${orderDetails.productId}');
      }catch(e){
        _reOrderIndex = null;
        showCustomSnackBarHelper(getTranslated('this_product_is_currently_unavailable', Get.context!));
      }

      CartModel? cartModel = OrderHelper.getReorderCartData(product: product, selectVariationType: selectVariationType);

      if(cartModel != null) {
        reOrderCartList.add(cartModel);
      }
    }

    _isLoading = false;
    notifyListeners();

    return reOrderCartList;

  }

  void setAreaID({int? areaID, bool isUpdate = true, bool isReload = false}) {
    if(isReload){
      _selectedAreaID = null;
    }else{
      _selectedAreaID = areaID!;
    }
    if(isUpdate){
      notifyListeners();
    }
  }




}