import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/features/order/domain/models/review_body_model.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/features/order/providers/image_note_provider.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
class OrderRepo {
  final DioClient? dioClient;
  OrderRepo({required this.dioClient});

  Future<Response> updateOrderImages(int orderId, List<XFile> images) async {
    final formData = FormData();

    for (final x in images) {
      if (kIsWeb) {
        final bytes = await x.readAsBytes();
        formData.files.add(MapEntry(
          'order_images[]',
          MultipartFile.fromBytes(bytes, filename: x.name),
        ));
      } else {
        formData.files.add(MapEntry(
          'order_images[]',
          await MultipartFile.fromFile(x.path, filename: p.basename(x.path)),
        ));
      }
    }

    return await dioClient!.post(
      // If dioClient already has baseUrl, do NOT prefix with AppConstants.baseUrl here
      '/api/v1/customer/order/updateOrderImages/$orderId',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer ${AppConstants.token}',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<ApiResponseModel> getOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.orderListUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> getOrderDetails(String? orderID, String? phoneNumber) async {
    try {
      final response = await dioClient!.post(AppConstants.orderDetailsUri, data: {
        'order_id' : orderID, 'phone' : phoneNumber == 'null' ? null : phoneNumber,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> cancelOrder(String orderID) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';
      final response = await dioClient!.post(AppConstants.orderCancelUri, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> trackOrder(String? orderID, String? phoneNumber) async {
    try {
      final response = await dioClient!.post(AppConstants.trackUri, data: {
        'order_id' : orderID, 'phone' : phoneNumber == 'null' ? null : phoneNumber,
      });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> placeOrder(PlaceOrderModel orderBody, {List<XFile?>? imageNote}) async {
    try {
      print(orderBody);
      final response = await dioClient!.postMultipart(
        AppConstants.placeOrderUri,
        files: imageNote ?? [],
        fileKey: 'order_images',
        data: orderBody.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getDeliveryManData(String? orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.lastLocationUri}$orderID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getTimeSlot() async {
    try {
      final response = await dioClient!.get(AppConstants.timeslotUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getDateList() {
    List<String> dates = [];
    dates.add(DateConverterHelper.slotDate(DateTime.now()));
    dates.add(DateConverterHelper.slotDate(DateTime.now().add(const Duration(days: 1))));
    dates.add(DateConverterHelper.slotDate(DateTime.now().add(const Duration(days: 2))));

    return dates;
  }


  Future<ApiResponseModel> submitReview(ReviewBodyModel reviewBody) async {
    try {
      final response = await dioClient!.post(AppConstants.reviewUri, data: reviewBody);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> submitDeliveryManReview(ReviewBodyModel reviewBody) async {
    try {
      final response = await dioClient!.post(AppConstants.deliveryManReviewUri, data: reviewBody);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    try {
      Response response = await dioClient!.get('${AppConstants.distanceMatrixUri}'
          '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
          '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

}