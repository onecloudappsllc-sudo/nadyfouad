import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<ApiResponseModel> getAllAddress() async {
    try {
      final response = await dioClient!.get(AppConstants.addressListUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> removeAddressByID(int? id) async {
    try {
      final response = await dioClient!.post('${AppConstants.removeAddressUri}$id', data: {"_method": "delete"});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.addAddressUri,
        data: addressModel.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> updateAddress(AddressModel addressModel, int? addressId) async {
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateAddressUri}$addressId',
        data: addressModel.toJson(),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllAddressType({BuildContext? context}) {
    return [
      'Home',
      'Workplace',
      'Other',
    ];
  }

  Future<ApiResponseModel> getAddressFromGeocode(LatLng latLng) async {
    try {
      Response response = await dioClient!.get('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchLocation(String text) async {
    try {
      Response response = await dioClient!.get('${AppConstants.searchLocationUri}?search_text=$text');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getPlaceDetails(String? placeID) async {
    try {
      Response response = await dioClient!.get('${AppConstants.placeDetailsUri}?placeid=$placeID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getLastOrderedAddress() async {
    try {
      Response response = await dioClient!.get(AppConstants.lastOrderedAddress);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
