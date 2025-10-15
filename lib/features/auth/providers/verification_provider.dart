import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/error_response_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/auth/domain/models/signup_model.dart';
import 'package:flutter_grocery/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/profile/screens/profile_edit_screen.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart' as auth;
import 'package:universal_html/js.dart';

class VerificationProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  VerificationProvider({required this.authRepo});


  bool resendLoadingStatus = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  String _verificationMsg = '';
  String get verificationMsg => _verificationMsg;

  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  Timer? _timer;
  int? currentTime;



  Future<void> sendVerificationCode(BuildContext buildContext, ConfigModel config, String userInput, {required String type, required String fromPage}) async {
    resendLoadingStatus = true;
    if(fromPage == FromPage.profile.name){
      showLoader(buildContext);
    }
    notifyListeners();

    if(AuthHelper.isCustomerVerificationEnable(config)){
      if(type == VerificationType.email.name && AuthHelper.isEmailVerificationEnable(config)){
        print("--------------------(SEND VERIFICATION CODE Email)-----------$userInput , $type and $fromPage");
        await checkEmail(buildContext, userInput, fromPage);
      }else if(type == VerificationType.phone.name && AuthHelper.isFirebaseVerificationEnable(config)){
        print("--------------------(SEND VERIFICATION CODE Firebase)-----------$userInput , $type and $fromPage");
        await firebaseVerifyPhoneNumber(buildContext, userInput, fromPage);
      }else if(type == VerificationType.phone.name && AuthHelper.isPhoneVerificationEnable(config)){
        print("--------------------(SEND VERIFICATION CODE Phone)-----------$userInput , $type and $fromPage");
        await checkPhone(buildContext, userInput, fromPage);
      }
    }
    resendLoadingStatus = false;
    notifyListeners();
  }


  Future<ResponseModel> checkPhone(BuildContext buildContext, String phone, String fromPage) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkPhone(phone);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
      print("---------------API ${apiResponse.response?.data}");


      String? routeName = ModalRoute.of(buildContext)?.settings.name;
      bool isReplaceRoute = ModalRoute.of(buildContext)?.settings.name == RouteHelper.verification;
      print("----------------------(CHECK PHONE) Route Name ------------------------: $routeName");
      print("----------------------(CHECK PHONE)  ---- $phone and $fromPage");
      //print("---------------------- Get context in checkPhone--------${Get.context?.widget.}--------------");


      if(isReplaceRoute){
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        Navigator.pushReplacementNamed(Get.context!, RouteHelper.getVerifyRoute(phone, fromPage));
      }else{
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        Navigator.pushNamed(Get.context!, RouteHelper.getVerifyRoute(phone, fromPage));
      }

    } else {
      String errorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message ?? '';
      showCustomSnackBarHelper(errorMessage);
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> checkEmail(BuildContext buildContext, String email, String fromPage) async {
    _isLoading = true;
    resendLoadingStatus = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.checkEmail(email);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);

      print("---------------API ${apiResponse.response?.data}");

      String routeName = ModalRoute.of(buildContext)?.settings.name?.split('?').first ?? '';
      bool isReplaceRoute =  (routeName == RouteHelper.verification) ;
      print("----------------------(CHECK EMAIL) Route Name ------------------------: $routeName");
      print("----------------------(CHECK EMAIL)  ---- $email and $fromPage");


      if(isReplaceRoute){
        print('---------HERE I AM------------');
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        Navigator.pushReplacementNamed(Get.context!, RouteHelper.getVerifyRoute(email, fromPage));
      }else{
        print('---------HERE I AM ELSE------------');
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        Navigator.pushNamed(Get.context!, RouteHelper.getVerifyRoute(email, fromPage));

      }

    } else {
      String? errorMessage = ApiCheckerHelper.getError(apiResponse).errors?.first.message.toString();

      responseModel = ResponseModel(false, errorMessage);
      showCustomSnackBarHelper(errorMessage!);
    }
    resendLoadingStatus = false;
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> firebaseVerifyPhoneNumber(BuildContext buildContext, String phoneNumber, String fromPage, {bool isForgetPassword = false})async {
    _isLoading = true;
    notifyListeners();

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if(Navigator.canPop(buildContext)) {
          if(!(ModalRoute.of(buildContext)?.settings.name == RouteHelper.profileEdit) && !(ModalRoute.of(buildContext)?.settings.name == RouteHelper.sendOtp)){
            Navigator.pop(Get.context!);
          }
        }
        _isLoading = false;
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        notifyListeners();
        showCustomSnackBarHelper(getTranslated('${e.message}', Get.context!));
      },
      codeSent: (String vId, int? resendToken) {

        bool isReplaceRoute = ModalRoute.of(buildContext)?.settings.name == RouteHelper.verification;
        print('---------------------(IS REPLACE ROUTE)--------------------$isReplaceRoute');

        _isLoading = false;
        if(fromPage == FromPage.profile.name){
          Navigator.pop(buildContext);
        }
        notifyListeners();

        if(fromPage == FromPage.profile.name){
          if(isReplaceRoute){
            Navigator.pushReplacementNamed(buildContext, RouteHelper.getVerifyRoute(phoneNumber,
              fromPage, session: vId,
            ));
          }else{
            Navigator.of(buildContext).pushNamed(RouteHelper.getVerifyRoute(phoneNumber,
              fromPage, session: vId,
            ));
          }
        }else{
          if(isReplaceRoute){
            Navigator.pushReplacementNamed(Get.context!, RouteHelper.getVerifyRoute(phoneNumber,
                isForgetPassword ? FromPage.forget.name : fromPage, session: vId));
          }else{
            Navigator.of(Get.context!).pushNamed(RouteHelper.getVerifyRoute(phoneNumber,
              isForgetPassword ? FromPage.forget.name : fromPage, session: vId,
            ));
          }
        }


      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }



  Future<ResponseModel> verifyPhone(String phone) async {
    final auth.AuthProvider authProvider = Provider.of<auth.AuthProvider>(Get.context!, listen: false);
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.verifyPhone(phone, _verificationCode);

    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String token = apiResponse.response!.data["token"];
      await authProvider.updateAuthToken(token);
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);

    } else {
      String? errorMessage = getTranslated(ErrorResponseModel.fromJson(apiResponse.error).errors![0].message, Get.context!);
      responseModel = ResponseModel(false, errorMessage);

      showCustomSnackBarHelper(errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String userInput) async {
    _isLoading = true;
    notifyListeners();

    print("-------------(VERIFY TOKEN)----UserInput $userInput and Verification Code $_verificationCode----------");
    ApiResponseModel apiResponse = await authRepo!.verifyToken(userInput, _verificationCode);

    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(false, ErrorResponseModel.fromJson(apiResponse.error).errors![0].message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String? email) async {
    final auth.AuthProvider authProvider = Provider.of<auth.AuthProvider>(Get.context!, listen: false);

    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.verifyEmail(email, _verificationCode);

    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String token = apiResponse.response!.data["token"];
      await authProvider.updateAuthToken(token);
      final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage = ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;

      responseModel = ResponseModel(false, errorMessage);
      showCustomSnackBarHelper(errorMessage ?? '');
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyProfileInfo(String userInput, String type, String? session) async {

    print('-------------------(VERIFY PROFILE INFO)----------$userInput and $type');
    _isLoading = true;
    notifyListeners();
    if(session?.isNotEmpty ?? false){
      type = 'firebase';
    }
    print('-------------------(VERIFY PROFILE INFO)----------$userInput and $type and $session');
    ApiResponseModel apiResponse = await authRepo!.verifyProfileInfo(userInput, _verificationCode, type, session);
    print("----------------(API)--------------${apiResponse.toString()}");
    print("--------------(API RESPONSE)--------------${apiResponse.error.toString()}");
    ResponseModel? responseModel;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      Map map = apiResponse.response!.data;
      print("------------(VERIFY PROFILE INFO)---------${map.toString()}");

      final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
      profileProvider.getUserInfo(true);
      showCustomSnackBarHelper(apiResponse.response!.data['message'], isError: false);
      responseModel = ResponseModel(true, 'verification');

    } else {
      String? error = ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;
      showCustomSnackBarHelper(error ?? '');
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isLoading = false;
    notifyListeners();
    return (responseModel);
  }

  Future<(ResponseModel?, String?)> verifyPhoneForOtp(String phone) async {
    final auth.AuthProvider authProvider = Provider.of<auth.AuthProvider>(Get.context!, listen: false);
    _isLoading = true;
    if(phone.contains('++')) {
      phone = phone.replaceAll('++', '+');
    }
    _verificationMsg = '';

    print("------------------------(VERIFY PHONE FOR OTP)-----------------$phone");
    print("------------------------(VERIFY PHONE FOR OTP)-----------------$_verificationCode");

    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.verifyOtp(phone, _verificationCode);
    print("-------------------------(API RESPONSE)---------------${apiResponse.response?.data}");
    ResponseModel? responseModel;
    String? token;
    String? tempToken;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      Map map = apiResponse.response!.data;
      if(map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      }else if(map.containsKey('token')){
        token = map["token"];
      }

      if(token != null){
        await authProvider.updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'verification');
      }else if(tempToken != null){
        responseModel = ResponseModel(true, 'verification');
      }
    } else {
      _verificationMsg = ApiCheckerHelper.getError(apiResponse).errors![0].message ?? '';
      showCustomSnackBarHelper(_verificationMsg);
      responseModel = ResponseModel(false, _verificationMsg);
    }
    _isLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  void updateVerificationCode(String query, int queryLen, {bool isUpdate = true}) {
    if (query.length == queryLen) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    if(isUpdate) {
      notifyListeners();
    }
  }



  void startVerifyTimer(){
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);

    _timer?.cancel();
    currentTime = splashProvider.configModel?.otpResendTime ?? 0;


    _timer =  Timer.periodic(const Duration(seconds: 1), (_){

      if(currentTime! > 0) {
        currentTime = currentTime! - 1;
      }else{
        _timer?.cancel();
      }

      notifyListeners();
    });

  }









}