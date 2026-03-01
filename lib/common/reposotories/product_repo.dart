import 'package:dio/dio.dart';
import 'package:flutter_grocery/common/enums/product_filter_type_enum.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({required this.dioClient});

  Future<ApiResponseModel> getAllProductList(int? offset, ProductFilterType type) async {
    try {
      final response = await dioClient!.get('${AppConstants.allProductList}?limit=10&offset=$offset&sort_by=${type.name}');
      return ApiResponseModel.withSuccess(response);

    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> getItemList(int offset, String? productType) async {
    try {
      String? apiUrl;
      if(productType == ProductType.featuredItem){
        apiUrl = AppConstants.featuredProduct;
      }else if(productType == ProductType.dailyItem){
        apiUrl = AppConstants.dailyItemUri;
      } else if(productType == ProductType.mostReviewed){
        apiUrl = AppConstants.mostReviewedProduct;
      }

      final response = await dioClient!.get('$apiUrl?limit=10&&offset=$offset',
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getProductDetails(String productID, bool searchQuery) async {
    try {
      String params = productID;
      if(searchQuery) {
        params = '$productID?attribute=product';
      }
      final response = await dioClient!.get('${AppConstants.productDetailsUri}$params');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> searchProduct(String productId, String languageCode) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.searchProductUri}$productId',
        options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getBrandOrCategoryProductList(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.categoryProductUri}$id');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getFlashDeal(int offset) async {
    try {
      final response = await dioClient!.get('${AppConstants.flashDealUri}?limit=10&&offset=$offset');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
