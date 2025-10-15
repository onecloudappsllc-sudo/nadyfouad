import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class OtpRegistrationScreen extends StatefulWidget {
  final String tempToken;
  final String userInput;
  final String? userName;
  const OtpRegistrationScreen({super.key, required this.tempToken, required this.userInput, this.userName});

  @override
  State<OtpRegistrationScreen> createState() => _OtpRegistrationScreenState();
}

class _OtpRegistrationScreenState extends State<OtpRegistrationScreen> {

  TextEditingController? _emailController;
  TextEditingController? _nameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _referCodeController;
  String? countryCode;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _referCodeController = TextEditingController();

    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    countryCode ??= CountryCode.fromCountryCode(configModel?.country ?? '').dialCode;

    if(widget.userName != null && widget.userName!.isNotEmpty){
      _nameController?.text = widget.userName!;
    }

  }


  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;

    bool isNumber = PhoneNumberCheckerHelper.isValidPhone(widget.userInput.trim().replaceAll('+', ''));

    print("-----------------------------------OTP REGISTRATION PAGE: TempToken ${widget.tempToken} , UserInput ${widget.userInput} and UserName ${widget.userName}");

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget()) : PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: CustomAppBarWidget(
          isBackButtonExist: true,
          title: '',
          onBackPressed: (){
            if(Navigator.canPop(context)){
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(child: Center(
        child: CustomScrollView(slivers: [

          if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeLarge)),

          SliverToBoxAdapter(child: Center(child: Container(
            width: width > 700 ? 400 : width,
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
            padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
            decoration: width > 700 ? BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
            ) : null,
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              SizedBox(height: size.height * 0.05),

              Consumer<SplashProvider>(
                builder: (context, splash, child) {
                  return Directionality(textDirection: TextDirection.ltr,
                    child: Image.asset(
                      Images.appLogo, height: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height / 4.5,
                      fit: BoxFit.scaleDown,
                    ),
                  );
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: Center(child: Column(children: [

                  Text(getTranslated('just_one_step_away_will_help_make_your_profile', context),
                    textAlign: TextAlign.center,
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomTextFieldWidget(
                    isShowBorder: true,
                    controller: _nameController,
                    inputType: TextInputType.emailAddress,
                    title: getTranslated('name', context),
                    hintText: getTranslated('write_your_name', context),
                    prefixAssetUrl: Images.userIcon,
                    isShowPrefixIcon: true,
                    prefixAssetImageColor: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  isNumber ? CustomTextFieldWidget(
                    hintText: getTranslated('demo_gmail', context),
                    isShowBorder: true,
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    title: getTranslated('email', context),
                    prefixAssetUrl: Images.emailIcon,
                    isShowPrefixIcon: true,
                    prefixAssetImageColor: Theme.of(context).hintColor,
                  ): CustomTextFieldWidget(
                    countryDialCode: countryCode,
                    onCountryChanged: (CountryCode value) => countryCode = value.dialCode,
                    //hintText: getTranslated('demo_gmail', context),
                    isShowBorder: true,
                    hintText: '',
                    controller: _phoneNumberController,
                    inputType: TextInputType.phone,
                    title: getTranslated('mobile_number', context),
                    //prefixIconColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  CustomTextFieldWidget(
                    isShowBorder: true,
                    isShowPrefixIcon: true,
                    prefixAssetUrl: Images.referralIcon,
                    prefixAssetImageColor: Theme.of(context).hintColor,
                    hintText: getTranslated('hint_refer_text', context),
                    controller: _referCodeController,
                    inputType: TextInputType.text,
                    title: getTranslated('referral_code', context),
                    //prefixIconColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButtonWidget(
                        isLoading: authProvider.isLoading,
                        buttonText: getTranslated('done', context),
                        textStyle: poppinsBold.copyWith(
                          color: Theme.of(context).cardColor,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        onPressed: (){

                          String name = _nameController!.text.trim();
                          String email = _emailController!.text.trim();
                          String phone = _phoneNumberController!.text.trim();

                          if (_nameController!.text.isEmpty) {
                            showCustomSnackBarHelper(getTranslated('enter_your_name', context));
                          }else if(!isNumber && phone.isEmpty){
                            showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
                          } else{
                            if(isNumber){
                              print("---------------------(OTP REGISTRATION)-------------Name $name , Email $email , Phone ${widget.userInput} and Referral Code ${_referCodeController?.text}");
                              authProvider.registerWithOtp(name, email: email, phone: widget.userInput, referralCode: _referCodeController?.text.trim()).then((value){
                                if(value.isSuccess) {
                                  print("---------------------(OTP REGISTRATION)------------- ACTIVE REMEMBER ME : ${authProvider.isActiveRememberMe}");
                                  if (authProvider.isActiveRememberMe) {

                                    String userCountryCode = PhoneNumberCheckerHelper.getCountryCode(widget.userInput)!;

                                    authProvider.saveUserNumberAndPassword(UserLogData(
                                      countryCode:  userCountryCode,
                                      phoneNumber: PhoneNumberCheckerHelper.getPhoneNumber(widget.userInput, userCountryCode),
                                      email: email,
                                      password: null,
                                      loginType: FromPage.otp.name,
                                    ));

                                  } else {
                                    authProvider.clearUserLogData();
                                  }
                                  Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
                                }
                              });
                            }else{
                              phone = countryCode! + phone;
                              bool isNumberValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phone);

                              print("---------------------------(OTP REGISTRATION SCREEN) $phone and $isNumberValid");
                              if(!isNumberValid){
                                showCustomSnackBarHelper(getTranslated('invalid_phone_number', context));
                              }else{
                                print("----------------(OTP REGISTRATION SCREEN) Name: $name, Email: ${widget.userInput} and Phone: $phone");

                                authProvider.registerWithSocialMedia(name, email: widget.userInput, phone: phone, referralCode: _referCodeController?.text.trim()).then((value){
                                  final (responseModel, tempToken) = value;
                                  if(responseModel.isSuccess && tempToken == null) {
                                    authProvider.clearUserLogData();
                                    Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route)=> false);
                                  }else if(responseModel.isSuccess && tempToken != null){
                                    final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(Get.context!, listen: false);
                                    final ConfigModel configModel = Provider.of<SplashProvider>(Get.context!, listen: false).configModel!;

                                    print("----------------------------(OTP REGISTRATION SCREEN)-------Phone: $phone, Type: ${VerificationType.phone.name}");

                                    verificationProvider.sendVerificationCode(context, configModel, phone, type: VerificationType.phone.name, fromPage: FromPage.login.name);
                                  }
                                });
                              }

                            }

                          }
                        },
                      );
                    },
                  ),
                ])),
              ),

              if(ResponsiveHelper.isDesktop(context))
                SizedBox(height: size.height * 0.05),


            ])),
          ))),

          if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeExtraLarge)),

          if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  // SizedBox(height: Dimensions.paddingSizeLarge),
              FooterWebWidget(footerType: FooterType.nonSliver),
            ]),
          ),

        ]),
      )),
    );
  }
}
