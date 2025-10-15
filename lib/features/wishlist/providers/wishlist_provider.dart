import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/features/wishlist/domain/models/wishlist_model.dart';
import 'package:flutter_grocery/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';


class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;

  WishListProvider({required this.wishListRepo});

  List<Product>? _wishList;
  List<Product>? get wishList => _wishList;
  Product? _product;
  Product? get product => _product;
  List<int?> _wishIdList = [];
  List<int?> get wishIdList => _wishIdList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addToWishList(Product product, BuildContext context) async {
    _wishList!.add(product);
    _wishIdList.add(product.id);
    notifyListeners();
    ApiResponseModel apiResponse = await wishListRepo!.addWishList([product.id]);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper('item_added_to'.tr, isError: false);
    } else {
      _wishList!.remove(product);
      _wishIdList.remove(product.id);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishList!.remove(product);
    _wishIdList.remove(product.id);
    notifyListeners();
    ApiResponseModel apiResponse = await wishListRepo!.removeWishList([product.id]);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper('item_removed_from'.tr, isError: false);
    } else {
      _wishList!.add(product);
      _wishIdList.add(product.id);
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getWishListProduct() async {
    _isLoading = true;
    _wishList = [];
    _wishIdList = [];
    ApiResponseModel apiResponse = await wishListRepo!.getWishList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _wishList = [];
      _wishList!.addAll(WishListModel.fromJson(apiResponse.response!.data).products!);
      for(int i = 0; i< _wishList!.length; i++){
        _wishIdList.add(_wishList![i].id);
      }


    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  void clearWishList(){
    _wishIdList = [];
    _wishIdList = [];
  }
}
