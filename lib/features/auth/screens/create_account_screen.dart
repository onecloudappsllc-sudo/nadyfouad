import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/auth/domain/models/signup_model.dart';
import 'package:flutter_grocery/helper/email_checker_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/features/auth/screens/login_screen.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {

  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referTextFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  String? countryCode;

  @override
  void initState() {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).dialCode;
    Provider.of<AuthProvider>(context, listen: false).updateRegistrationErrorMessage('', false);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final config = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) :null,
      body: Consumer<AuthProvider>(builder: (context, authProvider, child) => SafeArea(
        child: CustomScrollView(slivers: [

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Center(child: Column(children: [
              Container(
                width: width > 700 ? 700 : width,
                padding: ResponsiveHelper.isDesktop(context)
                    ? const EdgeInsets.symmetric(horizontal: 50,vertical: 50) : width > 700
                    ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                decoration: width > 700 ? BoxDecoration(
                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                ) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    Center(child: Text(
                      getTranslated('create_account', context),
                      style: poppinsMedium.copyWith(fontSize: 24, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    )),
                    const SizedBox(height: 30),

                    // for first name section
                    CustomTextFieldWidget(
                      title: getTranslated('first_name', context),
                      hintText: 'John',
                      isShowBorder: true,
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      nextFocus: _lastNameFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // for last name section
                    CustomTextFieldWidget(
                      title: getTranslated('last_name', context),
                      hintText: 'Doe',
                      isShowBorder: true,
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // for phone section
                    CustomTextFieldWidget(
                      countryDialCode: countryCode,
                      onCountryChanged: (CountryCode value) {
                        countryCode = value.dialCode;
                        print("---------------Here $countryCode");
                      },
                      hintText: getTranslated('number_hint', context),
                      isShowBorder: true,
                      controller: _numberController,
                      inputType: TextInputType.phone,
                      title: getTranslated('mobile_number', context),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // for email section
                    CustomTextFieldWidget(
                      title: getTranslated('email', context),
                      hintText: getTranslated('demo_gmail', context),
                      isShowBorder: true,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: config.referEarnStatus! ? _referTextFocus : _passwordFocus,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    //refer code
                    if(config.referEarnStatus!)...[
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        CustomTextFieldWidget(
                          title: '${ getTranslated('refer_code', context)} (${getTranslated('optional', context)})',
                          hintText: '',
                          isShowBorder: true,
                          controller: _referTextController,
                          focusNode: _referTextFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.text,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                      ],),
                    ],

                    // for password section
                    CustomTextFieldWidget(
                      title: getTranslated('password', context),
                      hintText: getTranslated('password_hint', context),
                      isShowBorder: true,
                      isPassword: true,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      isShowSuffixIcon: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    // for confirm password section
                    CustomTextFieldWidget(
                      title: getTranslated('confirm_password', context),
                      hintText: getTranslated('password_hint', context),
                      isShowBorder: true,
                      isPassword: true,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      isShowSuffixIcon: true,
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(height : Dimensions.paddingSizeLarge),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        authProvider.registrationErrorMessage!.isNotEmpty
                            ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                            : const SizedBox.shrink(),
                        const SizedBox(width: 8),

                        Expanded(child: Text(
                          authProvider.registrationErrorMessage ?? "",
                          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        )),

                      ],
                    ),

                    // for signup button
                    const SizedBox(height: 10),

                    CustomButtonWidget(
                      isLoading: authProvider.isLoading,
                      buttonText: getTranslated('signup', context),
                      onPressed: ()=> _onSignUpPress(config),
                    ),

                    // for already an account
                    const SizedBox(height: 11),

                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(RouteHelper.login, arguments: const LoginScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            getTranslated('already_have_account', context),
                            style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.6)),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Text(
                            getTranslated('login', context),
                            style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                          ),

                        ]),
                      ),
                    ),
                  ],
                ),
              ),

              ResponsiveHelper.isDesktop(context) ? const SizedBox(height: 50,) : const SizedBox(),


            ])),
          )),

          const FooterWebWidget(footerType: FooterType.sliver),

        ]),
      )),
    );
  }

  void _onSignUpPress(ConfigModel config) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String number = _numberController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    String phoneWithCountryCode = (countryCode ?? '') + number;
    bool isPhoneValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phoneWithCountryCode);

    if (firstName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_first_name', context));

    }else if (lastName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_last_name', context));

    }else if (number.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_phone_number', context));

    }else if(!isPhoneValid){
      showCustomSnackBarHelper(getTranslated('invalid_phone_number', context));

    }else if (password.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_password', context));

    }else if (password.length < 6) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));

    }else if (confirmPassword.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_confirm_password', context));

    }else if(password != confirmPassword) {
      showCustomSnackBarHelper(getTranslated('password_did_not_match', context));

    }else if (email.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_email_address', context));

    }else if (EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper(getTranslated('enter_valid_email', context));

    }else {

      print("--------------------(CREATE NEW ACCOUNT) $countryCode and $number");
      SignUpModel signUpModel = SignUpModel(
        fName: firstName,
        lName: lastName,
        email: email,
        password: password,
        phone: '$countryCode$number',
        referralCode: _referTextController.text.trim(),
      );

      print("---------------------(CREATE NEW ACCOUNT) SignUpModel: ${signUpModel.toJson()}");
      authProvider.registration(context, signUpModel, config).then((status) async {
        if (status.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.menu, (route) => false);
        }
      });
    }
  }

}
