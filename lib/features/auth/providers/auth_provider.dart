
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/error_response_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/auth/domain/models/signup_model.dart';
import 'package:flutter_grocery/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_grocery/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_grocery/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/email_checker_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../helper/api_checker_helper.dart';
import '../screens/login_screen.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;
  bool _isCheckedPhone = false;
  String? _registrationErrorMessage = '';
  bool _isActiveRememberMe = false;
  String? _loginErrorMessage = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isNumberLogin = false;
  GoogleSignInAccount? googleAccount;
  int _countSocialLoginOptions = 0;

  bool get isLoading => _isLoading;
  bool get isCheckedPhone => _isCheckedPhone;
  String? get registrationErrorMessage => _registrationErrorMessage;
  bool get isActiveRememberMe => _isActiveRememberMe;
  String? get loginErrorMessage => _loginErrorMessage;
  bool get isNumberLogin => _isNumberLogin;
  int get countSocialLoginOptions => _countSocialLoginOptions;

  void updateRegistrationErrorMessage(String message, bool isUpdate) {
    _registrationErrorMessage = message;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setCountSocialLoginOptions ({int? count, bool isReload = false}){
    if(isReload){
      _countSocialLoginOptions = 0;
    }else{
      _countSocialLoginOptions = count ?? 0;
    }
  }

  Future<ResponseModel> registration(BuildContext buildContext, SignUpModel signUpModel, ConfigModel config) async {
    final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(Get.context!, listen: false);

    _isLoading = true;
    _isCheckedPhone = false;
    _registrationErrorMessage = '';
    notifyListeners();

    print("---------------------(REGISTRATION) SignUpModel: ${signUpModel.toJson()}");
    ApiResponseModel apiResponse = await authRepo!.registration(signUpModel);
    ResponseModel responseModel;
    String? token;
    String? tempToken;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper(getTranslated('registration_successful', Get.context!), isError: false);

      print("-----------------(REGISTRATION API) Api response : ${apiResponse.response?.data}");
      Map map = apiResponse.response!.data;
      if(map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      }else if(map.containsKey('token')){
        token = map["token"];
      }

      if(token != null){
        await login(buildContext, signUpModel.phone!, signUpModel.password, VerificationType.phone.name, fromPage : FromPage.registration.name);
        responseModel = ResponseModel(true, 'successful');
      }else{
        _isCheckedPhone = true;
        String type;
        String userInput;
        if(AuthHelper.isFirebaseVerificationEnable(config) && AuthHelper.isPhoneVerificationEnable(config)){
          type = VerificationType.phone.name;
          userInput = signUpModel.phone!;
        }else if(!AuthHelper.isFirebaseVerificationEnable(config) && AuthHelper.isPhoneVerificationEnable(config)){
          type = VerificationType.phone.name;
          userInput = signUpModel.phone!;
        }else {
          type = VerificationType.email.name;
          userInput = signUpModel.email!;
        }

        print('-----------------------(REGISTRATION SCREEN) is $type and $userInput');
        verificationProvider.sendVerificationCode(buildContext, config, userInput, type: type, fromPage: FromPage.login.name);
        responseModel = ResponseModel(false, tempToken);
      }

    } else {

      _registrationErrorMessage = ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
    }
    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> login(BuildContext buildContext, String userInput, String? password, String type, {required String fromPage}) async {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(Get.context!, listen: false);

    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    print("-------------------------(LOGIN)-----------------UserInput : $userInput and Password: $password and Type: $type");

    ApiResponseModel apiResponse = await authRepo!.login(userInput: userInput, password: password, type: type);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      String? token;
      String? tempToken;
      Map map = apiResponse.response!.data;
      print("------------------------ API RESPONSE : ${map.toString()}-----------------------------");
      if(map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      }else if(map.containsKey('token')){
        token = map["token"];
      }

      if(token != null){
        await updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true, isUpdate: false);
      }else if(tempToken != null){
        print("-----------------------(TEMP TOKEN) : User Input: $userInput , FromPage: $fromPage");
        await verificationProvider.sendVerificationCode(buildContext, splashProvider.configModel!, userInput, type: type, fromPage: fromPage);
      }
      responseModel = ResponseModel(token != null, 'verification');

    } else {
      _loginErrorMessage = ErrorResponseModel.fromJson(apiResponse.error).errors![0].message;
      responseModel = ResponseModel(false,_loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> deleteUser(BuildContext context) async {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    _isLoading = true;
    notifyListeners();
    ApiResponseModel? response = await authRepo?.deleteUser();
    _isLoading = false;

    if (response?.response?.statusCode == 200) {
      splashProvider.removeSharedData();
      showCustomSnackBarHelper('your_account_remove_successfully'.tr );
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }else{
      Navigator.of(Get.context!).pop();
      ApiCheckerHelper.checkApi(response!);
    }
  }

  // for forgot password

  Future<ResponseModel> forgetPassword(String userInput, String type) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.forgetPassword(userInput, type);
    ResponseModel responseModel;

    print("-------------------(FORGET PASSWORD)------------UserInput: $userInput------- and Type:$type");

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      responseModel = ResponseModel(false, ErrorResponseModel.fromJson(apiResponse.error).errors![0].message);
    }
    _isLoading = false;
    notifyListeners();

    return responseModel;
  }

  Future<ResponseModel> resetPassword(String? userInput, String? resetToken, String password, String confirmPassword, {required String type}) async {
    _isLoading = true;
    notifyListeners();

    print("------------------------------------(RESET PASSWORD)----------------UserInput: $userInput, Reset Token: $resetToken, Password: $password, ConfirmPassword: $confirmPassword and Type: $type");

    ApiResponseModel apiResponse = await authRepo!.resetPassword(userInput, resetToken, password, confirmPassword, type: type);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      print("--------------------------(RESET PASSWORD)------------${apiResponse.response?.data}");

      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {

      responseModel = ResponseModel(false, ErrorResponseModel.fromJson(apiResponse.error).errors![0].message);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo?.updateToken();
  }

  void onChangeRememberMeStatus({bool? value, bool isUpdate = true}) {
    if(value == null) {
      _isActiveRememberMe = !_isActiveRememberMe;

    }else {
      _isActiveRememberMe = value;
    }
    if(isUpdate){
      notifyListeners();
    }
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo!.clearSharedData();
  }

  void saveUserNumberAndPassword(UserLogData userLogData) {
    authRepo!.saveUserNumberAndPassword(jsonEncode(userLogData.toJson()));
  }

  UserLogData? getUserData() {
    UserLogData? userData;
    try{
      userData = UserLogData.fromJson(jsonDecode(authRepo!.getUserLogData()));
    }catch(error) {
      debugPrint('error ====> $error');

    }
    return userData;
  }

  Future<bool> clearUserLogData() async {
    return authRepo!.clearUserLog();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

  void toggleIsNumberLogin ({bool? value, bool isUpdate = true}) {
    if(value == null){
      _isNumberLogin = !_isNumberLogin;
    }else{
      _isNumberLogin = value;
    }

    if(isUpdate){
      notifyListeners();
    }
  }

  Future<GoogleSignInAuthentication> googleLogin() async {
    GoogleSignInAuthentication auth;
    googleAccount = await _googleSignIn.signIn();
    auth = await googleAccount!.authentication;
    return auth;
  }

  Future  socialLogin(SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print('-----------------(SOCIAL LOGIN API)---> ${socialLogin.toJson()}');
    ApiResponseModel apiResponse = await authRepo!.socialLogin(socialLogin);
    _isLoading = false;
    if (apiResponse.response?.statusCode == 200 && apiResponse.response != null) {
      print("-----------------------(SOCIAL LOGIN API)-----------${apiResponse.response?.data}");
      Map map = apiResponse.response?.data;
      String? message = '';
      String? token = '';
      String? tempToken = '';
      UserInfoModel? userInfoModel;

      try{
        message = map['error_message'] ?? '';
      }catch(e){
        debugPrint("Error :$e");
      }

      try{
        token = map['token'];
      }catch(e){
        debugPrint("Error :$e");
      }

      try{
        tempToken = map['temp_token'];
      }catch(e){
        debugPrint("Error :$e");
      }

      if(map.containsKey('user')){
        try{
          userInfoModel = UserInfoModel.fromJson(map['user']);
          print("--------------(SOCIAL Name)--------------${socialLogin.name}");
          print("--------------(SOCIAL Email)--------------${socialLogin.email}");
          print("--------------(SOCIAL Medium)--------------${socialLogin.medium}");
          callback(true, null, message, null, userInfoModel, socialLogin.medium, socialLogin.email, socialLogin.name);
        }catch(e){
          debugPrint("Error :$e");
        }
      }

      if(token != null){
        await updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        callback(true, token, message,null, null, null, null, null);
      }

      if(tempToken != null){
        print("--------------(SOCIAL)--------------${socialLogin.name}");
        callback(true, null, message, tempToken, null, null, socialLogin.email, socialLogin.name);
      }
      notifyListeners();
    }else {
      callback(false, '', ApiCheckerHelper.getError(apiResponse).errors?.first.message, null, null, null, null, null);
      notifyListeners();
    }
  }

  Future<void> socialLogout() async {
    final UserInfoModel? user = Provider.of<ProfileProvider>(Get.context!, listen: false).userInfoModel;
    if(user?.loginMedium?.toLowerCase() == 'google') {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      try{
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      }catch(e){
        log("Error: $e");
      }


    }else if(user?.loginMedium?.toLowerCase() == 'facebook'){
      await FacebookAuth.instance.logOut();
    }

  }

  Future updateFirebaseToken() async {
    if(await authRepo!.getDeviceToken() != '@'){
      await authRepo!.updateToken();
    }
  }

  Future<void> addOrUpdateGuest() async {
    String? fcmToken = await  authRepo?.getDeviceToken();
    ApiResponseModel apiResponse = await authRepo!.addOrUpdateGuest(fcmToken);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200
        && apiResponse.response?.data != null && apiResponse.response?.data.isNotEmpty &&  apiResponse.response?.data['guest']['id'] != null) {
      authRepo?.saveGuestId('${apiResponse.response?.data['guest']['id'].toString()}');
    }
  }

  String? getGuestId()=> isLoggedIn() ? null : authRepo?.getGuestId();

  Future<void> firebaseOtpLogin({required String phoneNumber, required String session, required String otp, bool isForgetPassword = false}) async {

    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.firebaseAuthVerify(
      session: session, phoneNumber: phoneNumber,
      otp: otp, isForgetPassword: isForgetPassword,
    );

    print("---------------(FIREBASE OTP LOGIN)--------------$phoneNumber, $session, $otp, $isForgetPassword");


    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? token;
      String? tempToken;

      print("-------------(FIREBASE API)-----------${map.toString()}");

      try{
        token = map["token"];
        tempToken = map["temp_token"];
      }catch(error){
        print("Error $error");
      }

      if(isForgetPassword) {
        Navigator.of(Get.context!).pushNamed(RouteHelper.getNewPassRoute(phoneNumber, otp));
      }else{
        if(token != null) {
          String? countryCode = PhoneNumberCheckerHelper.getCountryCode(phoneNumber);
          String? phone = PhoneNumberCheckerHelper.getPhoneNumber(phoneNumber, countryCode ?? '');
          await updateAuthToken(token);
          final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
          profileProvider.getUserInfo(true);
          saveUserNumberAndPassword(UserLogData(
            countryCode:  countryCode,
            phoneNumber: phone,
            email: null,
            password: null,
            loginType: FromPage.otp.name
          ));
          Navigator.pushReplacementNamed(Get.context!, RouteHelper.getMainRoute());

        }else if(tempToken != null){
          Navigator.of(Get.context!).pushReplacementNamed(RouteHelper.getOtpRegistration(tempToken, phoneNumber));
        }
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  void onChangeLoadingStatus(){
    _isLoading = false;
  }

  Future<void> updateAuthToken(String token) async {
    authRepo!.saveUserToken(token);
    await authRepo!.updateToken();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    final WishListProvider wishListProvider = Provider.of<WishListProvider>(Get.context!, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    clearSharedData().then((value){
      authRepo?.clearToken();
      cartProvider.getCartData(isUpdate: true);
      splashProvider.setPageIndex(0);
      socialLogout();
      wishListProvider.clearWishList();
      addOrUpdateGuest();
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel> registerWithOtp (String name, {String? email, required String phone, String? referralCode}) async{
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    print("----------------------(REGISTER WITH OTP)----------- Email : $email , Phone: $phone , Name $name and Referral Code: $referralCode");
    ApiResponseModel apiResponse = await authRepo!.registerWithOtp(name, email: email, phone: phone, referralCode: referralCode);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      print("----------------------(REGISTER WITH OTP)----------- API RESPONSE: ${apiResponse.response?.data}");
      String? token;
      Map map = apiResponse.response!.data;
      if(map.containsKey('token')){
        token = map["token"];
      }
      if(token != null){
        await updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
      }
      responseModel = ResponseModel(token != null, 'verification');
    } else {
      _loginErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage ?? '');
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<(ResponseModel?, String?)> existingAccountCheck ({required String email, required int userResponse, required String medium}) async{
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.existingAccountCheck(email: email, userResponse: userResponse, medium: medium);
    ResponseModel responseModel;
    String? token;
    String? tempToken;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {


      Map map = apiResponse.response!.data;

      if(map.containsKey('token')){
        token = map["token"];
      }

      if(map.containsKey('temp_token')){
        tempToken = map["temp_token"];
      }

      if(token != null){
        await updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'token');
      } else if(tempToken != null){
        responseModel = ResponseModel(true, 'tempToken');
      } else{
        responseModel = ResponseModel(true, '');
      }


    } else {
      _loginErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage ?? '');
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

  Future<(ResponseModel, String?)> registerWithSocialMedia (String name, {required String email, String? phone, String? referralCode}) async{
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponseModel apiResponse = await authRepo!.registerWithSocialMedia(name, email: email, phone: phone, referralCode: referralCode);
    ResponseModel responseModel;
    String? token;
    String? tempToken;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      Map map = apiResponse.response!.data;
      if(map.containsKey('token')){
        token = map["token"];
      }
      if(map.containsKey('temp_token')){
        tempToken = map["temp_token"];
      }

      if(token != null){
        await updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(true);
        responseModel = ResponseModel(true, 'verification');
      }else if(tempToken != null){
        responseModel = ResponseModel(true, 'verification');
      }else{
        responseModel = ResponseModel(false, '');
      }

    } else {
      _loginErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      showCustomSnackBarHelper(_loginErrorMessage ?? '');
      responseModel = ResponseModel(false, _loginErrorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return (responseModel, tempToken);
  }

}