import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/product_filter_type_enum.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/reposotories/product_repo.dart';
import 'package:flutter_grocery/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  final SearchRepo searchRepo;

  ProductProvider({required this.productRepo, required this.searchRepo});

  ProductModel? _allProductModel;
  Product? _product;
  int? _imageSliderIndex;
  ProductModel? _dailyProductModel;
  ProductModel? _featuredProductModel;
  ProductModel? _mostViewedProductModel;
  ProductFilterType _selectedFilterType = ProductFilterType.latest;

  Product? get product => _product;
  ProductModel? get allProductModel=> _allProductModel;
  ProductModel? get dailyProductModel => _dailyProductModel;
  ProductModel? get featuredProductModel => _featuredProductModel;
  ProductModel? get mostViewedProductModel => _mostViewedProductModel;
  int? get imageSliderIndex => _imageSliderIndex;
  ProductFilterType get selectedFilterType => _selectedFilterType;



  Future<void> getAllProductList(int offset, bool reload, {bool isUpdate = true}) async {
    if(reload) {
      _allProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    ApiResponseModel? response = await productRepo.getAllProductList(offset, _selectedFilterType);
    if (response.response != null && response.response?.data != null && response.response?.statusCode == 200) {
      if(offset == 1){
        _allProductModel = ProductModel.fromJson(response.response?.data);
      } else {
        _allProductModel!.totalSize = ProductModel.fromJson(response.response?.data).totalSize;
        _allProductModel!.offset = ProductModel.fromJson(response.response?.data).offset;
        _allProductModel!.products!.addAll(ProductModel.fromJson(response.response?.data).products!);
      }

      notifyListeners();

    } else {
      ApiCheckerHelper.checkApi(response);
    }

  }


  Future<void> getItemList(int offset, {bool isUpdate = true, bool isReload = true,  required String? productType}) async {
    if(offset == 1) {
      _dailyProductModel = null;
      _featuredProductModel = null;
      _mostViewedProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }

    }
    ApiResponseModel apiResponse = await productRepo.getItemList(offset, productType);

    if(apiResponse.response?.statusCode == 200) {
      if(offset == 1) {

        if(productType == ProductType.dailyItem) {
          _dailyProductModel = ProductModel.fromJson(apiResponse.response?.data);

        }else if(productType == ProductType.featuredItem){
          _featuredProductModel = ProductModel.fromJson(apiResponse.response?.data);

        }else if(productType == ProductType.mostReviewed){
          _mostViewedProductModel = ProductModel.fromJson(apiResponse.response?.data);
        }

      }else {

        if(productType == ProductType.dailyItem) {
          _dailyProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _dailyProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _dailyProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);

        }else if(productType == ProductType.featuredItem){
          _featuredProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _featuredProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _featuredProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);

        }else if(productType == ProductType.mostReviewed){
          _mostViewedProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _mostViewedProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _mostViewedProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        }

      }
    }else{
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
  }



  Future<Product?> getProductDetails(String productID, {bool searchQuery = false}) async {

    final CartProvider cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    _product = null;
    ApiResponseModel apiResponse = await productRepo.getProductDetails(
      productID, searchQuery,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _product = Product.fromJson(apiResponse.response!.data);
      cartProvider.initData(_product!);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);

    }
    notifyListeners();

    return _product;

  }

  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }

  void onChangeProductFilterType(ProductFilterType type){
    _selectedFilterType = type;
    notifyListeners();
  }


}
