import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  WalletRepo({required this.dioClient, required this.sharedPreferences,});

  Future<ApiResponseModel> getWalletTransactionList(String offset, String type) async {
    try {
      final response = await dioClient!.get('${AppConstants.walletTransactionUrl}?offset=$offset&limit=10&transaction_type=$type');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getLoyaltyTransactionList(String offset, String type) async {
    try {
      final response = await dioClient!.get('${AppConstants.loyaltyTransactionUrl}?offset=$offset&limit=10&type=$type');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> pointToWallet({int? point}) async {
    try {
      final response = await dioClient!.post(AppConstants.loyaltyPointTransferUrl, data: {'point' : point});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getWalletBonusList() async {
    try {
      final response = await dioClient!.get(AppConstants.walletBonusListUrl);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


}