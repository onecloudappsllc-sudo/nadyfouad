import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/reposotories/product_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';

class FlashDealProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  FlashDealProvider({required this.productRepo});

  ProductModel? _flashDealModel;
  Duration? _duration;
  Timer? _timer;
  Duration? get duration => _duration;
  int? _currentIndex;
  int? get currentIndex => _currentIndex;
  ProductModel? get flashDealModel => _flashDealModel;


  Future<void> getFlashDealProducts(int offset, {bool isUpdate = true}) async {
    if(offset == 1) {
      _flashDealModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    ApiResponseModel? response = await productRepo.getFlashDeal(offset);
    if (response.response?.statusCode == 200) {
      if(offset == 1){
        _flashDealModel = ProductModel.fromJson(response.response?.data);

      } else {
        _flashDealModel?.offset = ProductModel.fromJson(response.response?.data).offset;
        _flashDealModel?.totalSize = ProductModel.fromJson(response.response?.data).totalSize;
        _flashDealModel?.flashDeal = ProductModel.fromJson(response.response?.data).flashDeal;
        _flashDealModel?.products?.addAll(ProductModel.fromJson(response.response?.data).products ?? []);
      }

      if(_flashDealModel?.flashDeal?.endDate != null) {
        DateTime endTime = DateConverterHelper.isoStringToLocalDate(_flashDealModel!.flashDeal!.endDate!).add(const Duration(days: 1));
        _duration = endTime.difference(DateTime.now());

        _timer?.cancel();
        _timer = null;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _duration = _duration! - const Duration(seconds: 1);
          notifyListeners();
        });
      }



    } else {
      ApiCheckerHelper.checkApi(response);
    }

    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
