
import 'package:dio/dio.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SearchRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getSearchProductList({
    required int offset,
    String? query,
    String? filterBy,
    double? priceLow,
    double? priceHigh,
  }) async {

    String url = '${AppConstants.searchUri}?limit=10&offset=$offset';

    if(query != null) {
      url = '$url&name=$query';

    }

    if(priceLow != null && priceHigh != null){
      url = '$url&price_low=$priceLow&price_high=$priceHigh';
    }
    if(filterBy != null){
      url = '$url&sort_by=$filterBy';
    }

    try {
      final response = await dioClient!.get(url);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String?> getAllSortByList(){
    List<String?> sortByList=[
      'low_to_high',
      'high_to_low',
      'ascending',
      'descending',
    ];
    return sortByList;
  }


  // for save home address
  Future<void> saveSearchAddress(String? searchAddress) async {
    try {
      List<String> searchKeywordList = sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
      if (!searchKeywordList.contains(searchAddress)) {
        searchKeywordList.add(searchAddress!);
      }
      await sharedPreferences!.setStringList(AppConstants.searchAddress, searchKeywordList);
    } catch (e) {
      rethrow;
    }
  }

  List<String> getSearchAddress() {
    return sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
  }

  Future<bool> clearSearchAddress() async {
    return sharedPreferences!.setStringList(AppConstants.searchAddress, []);
  }
}
