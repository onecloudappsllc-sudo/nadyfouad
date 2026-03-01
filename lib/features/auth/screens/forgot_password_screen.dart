import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/email_checker_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/auth/widgets/country_code_picker_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    double width = MediaQuery.of(context).size.width;
    final bool isFirebase = configModel.customerVerification!.status! && configModel.customerVerification?.firebase == 1;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): CustomAppBarWidget(title: getTranslated('forgot_password', context))) as PreferredSizeWidget?,
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Center(child: Container(
          width: !ResponsiveHelper.isMobile() ? 700 : width,
          padding: !ResponsiveHelper.isMobile() ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
          margin: !ResponsiveHelper.isMobile() ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : null,
          decoration: !ResponsiveHelper.isMobile() ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: Consumer<VerificationProvider>(
            builder: (context, verificationProvider, child) {
              return Column(children: [

                const SizedBox(height: 55),
                Image.asset(Images.closeLock, width: 142, height: 142, color: Theme.of(context).primaryColor),

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    const SizedBox(height: 80),

                    ( ( (configModel.forgetPassword?.phone == 1) || (configModel.forgetPassword?.firebase == 1) )
                        && (configModel.forgetPassword?.email == 1)
                    ) ? Selector<AuthProvider, bool>(
                      selector: (context, authProvider) => authProvider.isNumberLogin,
                      builder: (context, isNumberLogin, child) {
                        return CustomTextFieldWidget(
                          countryDialCode: isNumberLogin ? _countryDialCode : null,
                          onCountryChanged: (CountryCode value) => _countryDialCode = value.dialCode,
                          onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, authProvider),
                          hintText: getTranslated('enter_email_phone_number', context),
                          title: getTranslated('email_phone', context),
                          isShowBorder: true,
                          controller: _emailOrPhoneController,
                          inputType: TextInputType.emailAddress,
                        );
                      },
                    ) : ( (configModel.forgetPassword?.firebase == 1) || (configModel.forgetPassword?.phone == 1)) ?
                    Selector<AuthProvider, bool>(
                      selector: (context, authProvider) => authProvider.isNumberLogin,
                      builder: (context, isNumberLogin, child) {
                        return CustomTextFieldWidget(
                          countryDialCode: isNumberLogin ? _countryDialCode : null,
                          onCountryChanged: (CountryCode value) => _countryDialCode = value.dialCode,
                          onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, authProvider),
                          hintText: getTranslated('number_hint', context),
                          title: getTranslated('phone', context),
                          isShowBorder: true,
                          controller: _emailOrPhoneController,
                          inputType: TextInputType.phone,
                        );
                      },
                    ) : Selector<AuthProvider, bool>(
                      selector: (context, authProvider) => authProvider.isNumberLogin,
                      builder: (context, isNumberLogin, child) {
                        return CustomTextFieldWidget(
                          hintText: getTranslated('demo_gmail', context),
                          title: getTranslated('email', context),
                          isShowBorder: true,
                          controller: _emailOrPhoneController,
                          inputType: TextInputType.emailAddress,
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    SizedBox(
                      width: Dimensions.webScreenWidth, child: CustomButtonWidget(
                      isLoading: verificationProvider.isLoading || authProvider.isLoading,
                      buttonText: getTranslated('send', context),
                      onPressed: () {

                        String userInput = _emailOrPhoneController.text.trim();
                        bool isNumber = EmailCheckerHelper.isNotValid(userInput);
                        bool isNumberValid = true;

                        if(isNumber){
                          userInput = _countryDialCode! + userInput;
                          isNumberValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(userInput);
                        }

                        print("-----------------(Forgot Password)--------UserInput $userInput and $isNumber and $isNumberValid");

                        if(_emailOrPhoneController.text.isEmpty){
                          showCustomSnackBarHelper(getTranslated('enter_email_or_phone', context));
                        }else if(isNumber && !isNumberValid){
                          showCustomSnackBarHelper(getTranslated('invalid_phone_number', context));
                        }else{

                          if(AuthHelper.isFirebaseVerificationEnable(configModel) && isNumber){
                            verificationProvider.firebaseVerifyPhoneNumber(context, userInput, FromPage.forget.name, isForgetPassword: true);
                          }else{
                            authProvider.forgetPassword(userInput, isNumber ? VerificationType.phone.name : VerificationType.email.name).then((value) {
                              if (value.isSuccess) {
                                Navigator.of(Get.context!).pushNamed(RouteHelper.getVerifyRoute(userInput, FromPage.forget.name));
                              } else {
                                showCustomSnackBarHelper(value.message!);
                              }
                            });
                          }

                        }


                        // if(configModel.phoneVerification!) {
                        //   String phone = '${CountryCode.fromCountryCode(_countryDialCode!).dialCode}$email';
                        //   if (email.isEmpty) {
                        //     showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
                        //   } else {
                        //     if(isFirebase){
                        //       verificationProvider.firebaseVerifyPhoneNumber(phone, isForgetPassword: true);
                        //     }else{
                        //       authProvider.forgetPassword(phone).then((value) {
                        //         if (value.isSuccess) {
                        //           Navigator.of(context).pushNamed(RouteHelper.getVerifyRoute('forget-password', phone));
                        //         } else {
                        //           showCustomSnackBarHelper(value.message!);
                        //         }
                        //       });
                        //     }
                        //   }
                        // }else {
                        //   if (email.isEmpty) {
                        //     showCustomSnackBarHelper(getTranslated('enter_email_address', context));
                        //   } else if (EmailCheckerHelper.isNotValid(email)) {
                        //     showCustomSnackBarHelper(getTranslated('enter_valid_email', context));
                        //   } else {
                        //     authProvider.forgetPassword(email).then((value) {
                        //       if (value.isSuccess) {
                        //         Navigator.of(context).pushNamed(
                        //           RouteHelper.getVerifyRoute('forget-password', email),
                        //         );
                        //       } else {
                        //         showCustomSnackBarHelper(value.message!);
                        //       }
                        //     });
                        //   }
                        // }



                      },
                    )),
                  ]),
                ),
              ]);
            },
          ),
        ))),

        const FooterWebWidget(footerType: FooterType.sliver),

      ]),
    );
  }
}
