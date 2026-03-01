import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/screens/send_otp_screen.dart';
import 'package:flutter_grocery/features/auth/widgets/only_social_login_screen.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
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
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailOrPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  bool email = true;
  bool phone =false;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _initLoading();
  }


  @override
  void dispose() {
    _emailOrPhoneController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Current Route : ${ModalRoute.of(context)?.settings.name}");

    double width = MediaQuery.of(context).size.width;
    final configModel = Provider.of<SplashProvider>(context,listen: false).configModel!;

    if(!AuthHelper.isManualLoginEnable(configModel) && !AuthHelper.isOtpLoginEnable(configModel)){
      return const OnlySocialLoginWidget();
    }else if(!AuthHelper.isManualLoginEnable(configModel)){
      return const SendOtpScreen();
    }else{
      return CustomPopScopeWidget(child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : null,
        body: SafeArea(child: CustomScrollView(slivers: [

          if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeLarge)),

          SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
            child: Center(child: Container(
              width: ResponsiveHelper.isMobile() ? width : 500,
              padding: !ResponsiveHelper.isMobile() ? const EdgeInsets.symmetric(horizontal: 50,vertical: 50) :  width > 500 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: !ResponsiveHelper.isMobile() ? BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) => Form(key: _formKeyLogin, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Center(child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Image.asset(
                      Images.appLogo, height: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height / 4.5,
                      fit: BoxFit.scaleDown,
                    ),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Selector<AuthProvider, bool>(
                    selector: (context, authProvider) => authProvider.isNumberLogin,
                    builder: (context, isNumberLogin, child) {
                      return CustomTextFieldWidget(

                        countryDialCode: isNumberLogin ? countryCode : null,
                        onCountryChanged: (CountryCode value) => countryCode = value.dialCode,
                        onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, authProvider),

                        hintText: getTranslated('demo_gmail', context),
                        title: getTranslated('email_phone', context),
                        isShowBorder: true,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        controller: _emailOrPhoneController,
                        inputType: TextInputType.emailAddress,

                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: getTranslated('password_hint', context),
                    title: getTranslated('password', context),
                    isShowBorder: true,
                    isPassword: true,
                    isShowSuffixIcon: true,
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  // for remember me section
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    InkWell(
                      onTap: () => authProvider.onChangeRememberMeStatus(),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [

                          Container(width: 18, height: 18,
                            decoration: BoxDecoration(
                              color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                              border: Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: authProvider.isActiveRememberMe
                                ? const Icon(Icons.done, color: Colors.white, size: 17)
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Text(getTranslated('remember_me', context),
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),

                        ]),
                      ),
                    ),

                    InkWell(
                      onTap: ()=> Navigator.of(context).pushNamed(RouteHelper.forgetPassword, arguments: const ForgotPasswordScreen()),
                      child: Padding(padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getTranslated('forgot_password', context),
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    authProvider.loginErrorMessage!.isNotEmpty
                        ? CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: Dimensions.radiusSizeSmall)
                        : const SizedBox.shrink(),
                    const SizedBox(width: 8),

                    Expanded(child: Text(
                      authProvider.loginErrorMessage ?? "",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // for login button
                  CustomButtonWidget(
                    isLoading: authProvider.isLoading,
                    buttonText: getTranslated('sign_in', context),
                    onPressed: () async => _login(),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  if(AuthHelper.isOtpOrSocialLoginEnable(configModel))...[
                    Center(child: Text(getTranslated('OR', context), style: poppinsRegular.copyWith(fontSize: 12))),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    if(AuthHelper.isOtpLoginEnable(configModel))...[
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                        Text(getTranslated('sign_in_with', context),
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        InkWell(
                          onTap: () => Navigator.pushNamed(context, RouteHelper.getSendOtpScreen()),
                          child: Text(getTranslated('otp', context),
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(context).primaryColor,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],

                    if(AuthHelper.isSocialMediaLoginEnable(configModel)
                        && ((AuthHelper.isFacebookLoginEnable(configModel)
                            || AuthHelper.isGoogleLoginEnable(configModel) || AuthHelper.isAppleLoginEnable(configModel))))...[

                      const Center(child: SocialLoginWidget()),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                    ],
                  ],

                  InkWell(
                    onTap: ()=> Navigator.of(context).pushNamed(RouteHelper.getCreateAccount()),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text("${getTranslated('do_not_have_an_account', context)} ",
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Text(getTranslated('sign_up_here', context),
                        style: poppinsRegular.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if((configModel.isGuestCheckout ?? false) && (!Navigator.canPop(context) || ResponsiveHelper.isDesktop(context)))...[
                    Center(child: TextButton(
                      style: TextButton.styleFrom(minimumSize: const Size(1, 40)),
                      onPressed: () =>Navigator.pushReplacementNamed(context, RouteHelper.menu),
                      child: RichText(text: TextSpan(children: [

                        TextSpan(text: '${getTranslated('continue_as_a', context)} ',  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.6))),
                        TextSpan(text: getTranslated('guest', context), style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor)),

                      ])),
                    )),
                  ],

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                ])),
              ),
            )),
          )),

          const FooterWebWidget(footerType: FooterType.sliver),

        ])),

      ));
    }

  }

  void _initLoading() {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.onChangeLoadingStatus();
    authProvider.socialLogout();

    _formKeyLogin = GlobalKey<FormState>();
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    authProvider.setCountSocialLoginOptions(isReload: true);
    int count = AuthHelper.countSocialLoginOptions(configModel);
    authProvider.setCountSocialLoginOptions(count: count, isReload: false);
    authProvider.onChangeRememberMeStatus(value: false, isUpdate: false);
    authProvider.toggleIsNumberLogin(value: false, isUpdate: false);

    UserLogData? userData = authProvider.getUserData();
    print("------------USER DATA---------------${userData?.toJson()}");
    if(userData != null && userData.loginType == FromPage.login.name) {
      if(userData.phoneNumber != null){
        _emailOrPhoneController!.text = PhoneNumberCheckerHelper.getPhoneNumber(userData.phoneNumber ?? '', userData.countryCode ?? '') ?? '';
        authProvider.toggleIsNumberLogin(value: true, isUpdate: false);
        print("--------------------IS Number Login-----------------${authProvider.isNumberLogin}");
        countryCode ??= userData.countryCode;
        print("--------------------Country CODE---------------- ${userData.countryCode}");
      }else if(userData.email != null){
        _emailOrPhoneController!.text = userData.email ?? '';
      }
      _passwordController?.text = userData.password ?? '';
    }else{
      countryCode ??= CountryCode.fromCountryCode(configModel.country!).dialCode;
    }
  }

  void _login() {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String userInput = _emailOrPhoneController?.text.trim() ?? '';
    String password = _passwordController?.text.trim() ?? '';

    if (userInput.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_email_or_phone', context));
    }else if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));
    }else if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));
    }else {

      bool isNumber = PhoneNumberCheckerHelper.isValidPhone(userInput);
      if(isNumber){
        userInput = countryCode! + userInput;
      }

      String type = isNumber? VerificationType.phone.name : VerificationType.email.name;

      authProvider.login(context, userInput, password, type, fromPage: FromPage.login.name).then((status) async {
         if (status.isSuccess) {
          if (authProvider.isActiveRememberMe) {
            authProvider.saveUserNumberAndPassword(UserLogData(
              countryCode:  countryCode,
              phoneNumber: isNumber ? userInput : null,
              email: isNumber ? null : userInput,
              password: password,
              loginType: FromPage.login.name,
            ));
          }else {
            authProvider.clearUserLogData();
          }
          Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.menu, (route) => false);
        }
      });

    }
  }

}
