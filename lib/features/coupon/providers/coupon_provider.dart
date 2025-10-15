import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/features/coupon/domain/models/coupon_model.dart';
import 'package:flutter_grocery/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo? couponRepo;

  CouponProvider({required this.couponRepo});

  List<CouponModel>? _couponList;
  CouponModel? _coupon;
  double? _discount = 0.0;
  bool _isLoading = false;

  double? get discount => _discount;
  CouponModel? get coupon => _coupon;

  bool get isLoading => _isLoading;

  List<CouponModel>? get couponList => _couponList;

  Future<void> getCouponList(BuildContext context) async {
    ApiResponseModel apiResponse = await couponRepo!.getCouponList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _couponList = [];
      apiResponse.response!.data.forEach((category) => _couponList!.add(CouponModel.fromJson(category)));
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> applyCoupon(String coupon, double order) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await couponRepo!.applyCoupon(coupon);

    if (apiResponse.response != null && apiResponse.response!.data != null) {
      _coupon = CouponModel.fromJson(apiResponse.response!.data);
      if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= order) {
        if (_coupon!.discountType == 'percent' && _coupon!.couponType != 'free_delivery') {
          if (_coupon!.maxDiscount != null && _coupon!.maxDiscount != 0) {
            _discount = (_coupon!.discount! * order / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * order / 100) : _coupon!.maxDiscount;
          } else {
            _discount = _coupon!.discount! * order / 100;
          }
          showCustomSnackBarHelper('${'you_got_discount'.tr} ${'${_coupon!.discount}%'}', isError: false);

        }else if(_coupon!.discountType == 'amount' && order < _coupon!.discount! ) {
          showCustomSnackBarHelper('${'you_need_order_more_than'.tr} '
              '${PriceConverterHelper.convertPrice(Get.context!, _coupon!.discount)}');
        }
        else if(_coupon!.couponType == 'free_delivery'){
          showCustomSnackBarHelper('you_got_free_delivery_offer'.tr, isError: false);
        }else {
          _discount = _coupon!.discount;
          showCustomSnackBarHelper('${'you_got_discount'.tr} ${PriceConverterHelper.convertPrice(Get.context!, _coupon!.discount)}', isError: false);
        }
      } else {
        showCustomSnackBarHelper('${'you_need_order_more_than'.tr} '
            '${PriceConverterHelper.convertPrice(Get.context!, _coupon!.minPurchase)}');
        _discount = 0.0;
      }
    } else {
      _discount = 0.0;
      _coupon = null;
      showCustomSnackBarHelper('invalid_code_or_failed'.tr, isError: true);

    }

    _isLoading = false;
    notifyListeners();
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;

    if(notify) {
      notifyListeners();
    }
  }
}
