import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepo{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Home',
        'Office',
        'Other',
      ];
      Response response = Response(requestOptions: RequestOptions(path: ''), data: addressTypeList, statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.customerInfoUri);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String pass, File? file, PickedFile? data, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }else if(data != null) {
      Uint8List list = await data.readAsBytes();
      http.MultipartFile part = http.MultipartFile('image', data.readAsBytes().asStream(), list.length, filename: data.path);
      request.files.add(part);
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'f_name': userInfoModel.fName!, 'l_name': userInfoModel.lName!, 'email': userInfoModel.email!, 'phone': userInfoModel.phone!, 'password': pass
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


}