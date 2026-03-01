import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/features/order/domain/models/review_body_model.dart';
import 'package:flutter_grocery/features/order/domain/reposotories/order_repo.dart';

class ReviewProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  ReviewProvider({required this.orderRepo});

  bool _isLoading = false;
  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  bool get isLoading => _isLoading;
  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    for (int i = 0; i < orderDetailsList.length; i++) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    }
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBodyModel reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponseModel response = await orderRepo!.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String? errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBodyModel reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel response = await orderRepo!.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String? errorMessage;
      if(response.error is String) {
        errorMessage = response.error.toString();
      }else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }








}