import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/enums/app_mode_enum.dart';
import 'package:flutter_grocery/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/email_checker_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/footer_web_widget.dart';
import '../../../common/widgets/web_app_bar_widget.dart';

class VerificationScreen extends StatefulWidget {
  final String userInput;
  final String fromPage;
  final String? session;
  const VerificationScreen({super.key,this.session, required this.userInput, required this.fromPage});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController inputPinTextController = TextEditingController();

  @override
  void initState() {
    final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
    verificationProvider.startVerifyTimer();
    verificationProvider.updateVerificationCode('', 6, isUpdate: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final isPhone = EmailCheckerHelper.isNotValid(widget.userInput);
    final ConfigModel? config = Provider.of<SplashProvider>(context, listen: false).configModel;
    final bool isFirebaseOTP = AuthHelper.isCustomerVerificationEnable(config) && AuthHelper.isFirebaseVerificationEnable(config);

    print("----------------------(VERIFICATION SCREEN)------${widget.userInput} and ${widget.fromPage}");

    String userInput = widget.userInput;
    if(!userInput.contains('+') && isPhone) {
      userInput = '+${widget.userInput.replaceAll(' ', '')}';
    }

    print("----------------------(VERIFICATION SCREEN)------AFTER MODIFICATION $userInput and ${widget.fromPage}");

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : CustomAppBarWidget(
        title: getTranslated('otp_verification', context),
      )) as PreferredSizeWidget?,
      body: SafeArea(child: CustomScrollView(slivers: [

        SliverToBoxAdapter(
          child: SizedBox(
            height: !ResponsiveHelper.isMobile() ? size.height * 0.04 : 0,
          ),
        ),

        SliverToBoxAdapter(child: Center(child: SizedBox(
          // /width: Dimensions.webScreenWidth,
          child: Consumer<VerificationProvider>(builder: (context, verificationProvider, child) => Container(
            width: !ResponsiveHelper.isMobile() ? 450 : width,
            padding: !ResponsiveHelper.isMobile() ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
            margin: !ResponsiveHelper.isMobile() ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : null,
            decoration: !ResponsiveHelper.isMobile() ? BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
            ) : null,
            child: Column(children: [

              const SizedBox(height: 55),

              Image.asset(
                isPhone ? Images.phoneVerificationBackgroundIcon : Images.emailVerificationBackgroundIcon,
                width: 142, height: 142,
                //color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 40),

              Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(child: Text(
                  '${getTranslated('we_have_sent_verification_code', context)} ${widget.userInput}',
                  textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                )),
              ),

              if(AppMode.demo == AppConstants.appMode && !isFirebaseOTP)
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Text(getTranslated('for_demo_purpose_use', context), style: poppinsMedium.copyWith(
                    color: Theme.of(context).disabledColor,
                  )),
                ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.04, vertical: Dimensions.paddingSizeDefault),
                child: PinCodeTextField(
                  controller: inputPinTextController,
                  length: 6,
                    appContext: context,
                    obscureText: false,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Theme.of(context).primaryColor.withOpacity(.2),
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Theme.of(context).cardColor,
                      inactiveColor: Theme.of(context).primaryColor.withOpacity(.2),
                      activeColor: Theme.of(context).primaryColor.withOpacity(.4),
                      activeFillColor: Theme.of(context).cardColor,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onChanged: (query)=> verificationProvider.updateVerificationCode(query, 6),
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),



                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    print('verification------status-----> ${verificationProvider.resendLoadingStatus}');
                    int? days, hours, minutes, seconds;

                    Duration duration = Duration(seconds: verificationProvider.currentTime ?? 0);
                    days = duration.inDays;
                    hours = duration.inHours - days * 24;
                    minutes = duration.inMinutes - (24 * days * 60) - (hours * 60);
                    seconds = duration.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);

                    return Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text(getTranslated('did_not_receive_the_code', context), style: poppinsMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        verificationProvider.resendLoadingStatus ? CustomLoaderWidget(
                          color: Theme.of(context).primaryColor,
                        ) : TextButton(
                          onPressed: verificationProvider.currentTime! > 0 ? null :  () async {

                            if(widget.fromPage != FromPage.forget.name){
                              await verificationProvider.sendVerificationCode(context, config!,
                                userInput, type: isPhone ? VerificationType.phone.name : VerificationType.email.name, fromPage: widget.fromPage
                              );
                            }else{
                              bool isNumber = EmailCheckerHelper.isNotValid(userInput);
                              if(isNumber && isFirebaseOTP){
                                verificationProvider.firebaseVerifyPhoneNumber(context, userInput, widget.fromPage, isForgetPassword: true);
                              }else{
                                await authProvider.forgetPassword(userInput, isNumber? VerificationType.phone.name : VerificationType.email.name,
                                ).then((value) {

                                  verificationProvider.startVerifyTimer();
                                  if (value.isSuccess) {
                                    showCustomSnackBarHelper(getTranslated('resend_code_successful', Get.context!), isError: false);
                                  } else {
                                    showCustomSnackBarHelper(value.message!);
                                  }

                                });
                              }
                            }

                              // if (widget.fromSignUp) {
                              //   await verificationProvider.sendVerificationCode(config, SignUpModel(phone: widget.emailAddress, email: widget.emailAddress));
                              //   verificationProvider.startVerifyTimer();
                              //
                              // } else {
                              //   if(isFirebaseOTP) {
                              //     verificationProvider.firebaseVerifyPhoneNumber('${widget.emailAddress?.trim()}', isForgetPassword: true);
                              //
                              //   }else{
                              //     await authProvider.forgetPassword(widget.emailAddress).then((value) {
                              //       verificationProvider.startVerifyTimer();
                              //
                              //       if (value.isSuccess) {
                              //         showCustomSnackBarHelper('resend_code_successful', isError: false);
                              //       } else {
                              //         showCustomSnackBarHelper(value.message!);
                              //       }
                              //     });
                              //   }
                              // }

                            },
                            child: CustomDirectionalityWidget(
                              child: Text((verificationProvider.currentTime != null && verificationProvider.currentTime! > 0)
                                  ? '${getTranslated('resend', context)} (${minutes > 0 ? '${minutes}m :' : ''}${seconds}s)'
                                  : getTranslated('resend_it', context), textAlign: TextAlign.end,
                                  style: poppinsMedium.copyWith(
                                    color: verificationProvider.currentTime != null && verificationProvider.currentTime! > 0 ?
                                    Theme.of(context).disabledColor : Theme.of(context).primaryColor.withOpacity(.6),
                                  ),),
                            ),
                          ),
                        ],
                      ) ,
                      const SizedBox(height: 48),

                      (verificationProvider.isEnableVerificationCode && !verificationProvider.resendLoadingStatus) ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: SizedBox(width: 200, child: CustomButtonWidget(
                          isLoading: verificationProvider.isLoading || (isFirebaseOTP && authProvider.isLoading),
                          buttonText: getTranslated('verify', context),
                          onPressed: () {
                            if (widget.fromPage == FromPage.otp.name) {
                              if(isPhone && AuthHelper.isFirebaseVerificationEnable(config)){
                                authProvider.firebaseOtpLogin(
                                  phoneNumber: widget.userInput,
                                  session: '${widget.session}',
                                  otp: verificationProvider.verificationCode,
                                );
                              }else if(isPhone && AuthHelper.isPhoneVerificationEnable(config)){
                                verificationProvider.verifyPhoneForOtp(userInput).then((value){
                                  final (responseModel, tempToken) = value;
                                  if((responseModel != null && responseModel.isSuccess) && tempToken == null) {

                                    print("-------------------AFTER VERIFY OTP-------------Remember Me : ${authProvider.isActiveRememberMe}");
                                    print("-------------------AFTER VERIFY OTP-------------User Input : $userInput");
                                    print("-------------------AFTER VERIFY OTP-------------Country Code : ${PhoneNumberCheckerHelper.getCountryCode(userInput)!}");

                                    if (authProvider.isActiveRememberMe) {
                                      String userCountryCode = PhoneNumberCheckerHelper.getCountryCode(userInput)!;
                                      print("-------------------AFTER VERIFY OTP-------------Phone : ${PhoneNumberCheckerHelper.getPhoneNumber(userInput, userCountryCode)}");
                                      authProvider.saveUserNumberAndPassword(UserLogData(
                                        countryCode:  userCountryCode,
                                        phoneNumber: PhoneNumberCheckerHelper.getPhoneNumber(userInput, userCountryCode),
                                        email: null,
                                        password: null,
                                        loginType: FromPage.otp.name,
                                      ));
                                    } else {
                                      authProvider.clearUserLogData();
                                    }
                                    Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);

                                  }else if((responseModel != null && responseModel.isSuccess) && tempToken != null){
                                    Navigator.pushReplacementNamed(Get.context!, RouteHelper.getOtpRegistration(tempToken, userInput));
                                  }

                                });
                              }
                            }else if (widget.fromPage == FromPage.login.name) {
                              if(AuthHelper.isCustomerVerificationEnable(config)){
                                if(isPhone && isFirebaseOTP){
                                  authProvider.firebaseOtpLogin(
                                    phoneNumber: userInput,
                                    session: '${widget.session}',
                                    otp: verificationProvider.verificationCode,
                                  );
                                }else if(isPhone && AuthHelper.isPhoneVerificationEnable(config)){
                                  verificationProvider.verifyPhone(userInput.trim()).then((value) {
                                    if (value.isSuccess) {
                                      if (authProvider.isActiveRememberMe) {
                                        String userCountryCode = PhoneNumberCheckerHelper.getCountryCode(userInput)!;
                                        print("-------------------AFTER VERIFY OTP-------------Phone : ${PhoneNumberCheckerHelper.getPhoneNumber(userInput, userCountryCode)}");
                                        authProvider.saveUserNumberAndPassword(UserLogData(
                                          countryCode:  userCountryCode,
                                          phoneNumber: PhoneNumberCheckerHelper.getPhoneNumber(userInput, userCountryCode),
                                          email: null,
                                          password: null,
                                          loginType: FromPage.login.name,
                                        ));
                                      } else {
                                        authProvider.clearUserLogData();
                                      }
                                      Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
                                    }
                                  });
                                }else if(!isPhone && AuthHelper.isEmailVerificationEnable(config)){
                                  print("-----------------------(Verification Screen)---------------UserInput: $userInput");
                                  verificationProvider.verifyEmail(userInput).then((value) {
                                    if (value.isSuccess) {
                                      if (authProvider.isActiveRememberMe) {
                                        authProvider.saveUserNumberAndPassword(UserLogData(
                                          countryCode:  null,
                                          phoneNumber: null,
                                          email: userInput,
                                          password: null,
                                          loginType: FromPage.login.name,
                                        ));
                                      }
                                      Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
                                    }
                                  });
                                }
                              }
                            }else if(widget.fromPage == FromPage.profile.name){

                              String type = isPhone ? 'phone': 'email';
                              verificationProvider.verifyProfileInfo(userInput, type, widget.session).then((value){
                                if(value.isSuccess) {
                                  Navigator.pushReplacementNamed(Get.context!, RouteHelper.getProfileEditRoute());
                                }
                              });

                            }else {
                              if(isFirebaseOTP && isPhone) {
                                authProvider.firebaseOtpLogin(
                                  phoneNumber: userInput,
                                  session: '${widget.session}',
                                  otp: verificationProvider.verificationCode,
                                  isForgetPassword: true,
                                );
                              }else{
                                verificationProvider.verifyToken(widget.userInput).then((value) {
                                  if(value.isSuccess) {
                                    print("-----(VERIFICATION SCREEN)--------UserInput : ${widget.userInput} and VerificationCode: ${verificationProvider.verificationCode}");

                                    Navigator.of(Get.context!).pushReplacementNamed(
                                        RouteHelper.getNewPassRoute(widget.userInput, verificationProvider.verificationCode));
                                  }else {
                                    showCustomSnackBarHelper(value.message!);
                                  }
                                });
                              }

                            }
                          },
                        )),
                      ) : const SizedBox.shrink(),
                      const SizedBox(height: 48),

                    ]);
                  }
                ),
              ],
            ),
          )),
        ))),

        const FooterWebWidget(footerType: FooterType.sliver),
      ])),
    );
  }
}
