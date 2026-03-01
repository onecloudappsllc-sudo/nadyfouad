import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import '../models/api_response_model.dart';
import '../reposotories/news_letter_repo.dart';
import '../../helper/custom_snackbar_helper.dart';

class NewsLetterProvider extends ChangeNotifier {
  final NewsLetterRepo? newsLetterRepo;
  NewsLetterProvider({required this.newsLetterRepo});


  Future<void> addToNewsLetter( String email) async {
    ApiResponseModel apiResponse = await newsLetterRepo!.addToNewsLetter(email);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper('successfully_subscribe'.tr,isError: false);
      notifyListeners();
    } else {

      showCustomSnackBarHelper('mail_already_exist'.tr);
    }
  }
}
