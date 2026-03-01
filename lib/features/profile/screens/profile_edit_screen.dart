import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/profile/widgets/profile_menu_web_widget.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {

  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  FocusNode? firstNameFocus;
  FocusNode? lastNameFocus;
  FocusNode? emailFocus;
  FocusNode? phoneFocus;
  FocusNode? passwordFocus;
  FocusNode? confirmPasswordFocus;

  String? countryCode;
  final phoneToolTipKey = GlobalKey<State<Tooltip>>();
  final emailToolTipKey = GlobalKey<State<Tooltip>>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _initLoading();

  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ConfigModel config = splashProvider.configModel!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
          onPressed: () {
            splashProvider.setPageIndex(0);
            Navigator.of(context).pop();
          },
        ),
        title: Text(getTranslated('update_profile', context),
          style: poppinsMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          )),
      ),
      body: ResponsiveHelper.isDesktop(context) ?  Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return ProfileMenuWebWidget(
            file: profileProvider.data,
            pickImage: profileProvider.pickImage,
            confirmPasswordController: _confirmPasswordController,
            confirmPasswordFocus: confirmPasswordFocus,
            emailController: _emailController,
            firstNameController: _firstNameController,
            firstNameFocus: firstNameFocus,
            lastNameController: _lastNameController,
            lastNameFocus: lastNameFocus,
            emailFocus: emailFocus,
            passwordController: _passwordController,
            passwordFocus: passwordFocus,
            phoneNumberController: _phoneController,
            phoneNumberFocus: phoneFocus,
            image: profileProvider.userInfoModel?.image,
            userInfoModel: profileProvider.userInfoModel,
          );
        }) :
      SafeArea(child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Center(child: SizedBox(width: Dimensions.webScreenWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // for profile image
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.getGreyColor(context), width: 3),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    if(ResponsiveHelper.isMobilePhone()) {
                      profileProvider.choosePhoto();
                    }else {
                      profileProvider.pickImage();
                    }
                  },
                  child: Stack(clipBehavior: Clip.none, children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profileProvider.file != null ? Image.file(
                        profileProvider.file!, width: 80, height: 80, fit: BoxFit.fill,
                      ) : profileProvider.data != null ? Image.network(
                        profileProvider.data!.path, width: 80,
                        height: 80, fit: BoxFit.fill,
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CustomImageWidget(
                          placeholder: Images.placeHolder,
                          width: 80, height: 80, fit: BoxFit.cover,
                          image: profileProvider.userInfoModel != null ? '${splashProvider.baseUrls!.customerImageUrl}''/${profileProvider.userInfoModel!.image}' : '',
                        ),
                      ),
                    ),

                    Positioned(bottom: 5, right: 0,
                      child: Image.asset(
                        Images.camera, width: 24, height: 24,
                      ),
                    ),

                  ]),
                ),
              ),

              const SizedBox(height: 10),
              //mobileNumber,email,gender
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // for first name section
                  CustomTextFieldWidget(
                    title: getTranslated('first_name', context),
                    hintText: getTranslated('enter_first_name', context),
                    isShowBorder: true,
                    controller: _firstNameController,
                    focusNode: firstNameFocus,
                    nextFocus: lastNameFocus,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // for Last name section
                  CustomTextFieldWidget(
                    title: getTranslated('last_name', context),
                    hintText: getTranslated('enter_last_name', context),
                    isShowBorder: true,
                    controller: _lastNameController,
                    focusNode: lastNameFocus,
                    nextFocus: emailFocus,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // for email section
                  Selector<VerificationProvider, bool>(
                    selector: (context, verificationProvider) => verificationProvider.isLoading,
                    builder: (context, isLoading, child) {
                      return CustomTextFieldWidget(
                        title: getTranslated('email', context),
                        hintText: getTranslated('enter_email_address', context),
                        isShowBorder: true,
                        controller: _emailController,
                        focusNode: emailFocus,
                        nextFocus: phoneFocus,
                        inputType: TextInputType.emailAddress,
                        isShowSuffixIcon: true,
                        isToolTipSuffix: AuthHelper.isEmailVerificationEnable(config) && _emailController!.text.isNotEmpty? true : false,
                        toolTipMessage: profileProvider.userInfoModel?.emailVerifiedAt == null ? getTranslated('email_not_verified', context) : '',
                        toolTipKey: emailToolTipKey,
                        suffixAssetUrl: AuthHelper.isEmailVerificationEnable(config) && profileProvider.userInfoModel?.emailVerifiedAt == null ? Images.notVerifiedProfileIcon : Images.verifiedProfileIcon,
                        onSuffixTap: (){

                          if(profileProvider.userInfoModel?.emailVerifiedAt == null){
                            final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                            final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
                            verificationProvider.sendVerificationCode(
                              context, configModel!, _emailController?.text.trim() ?? '', type: VerificationType.email.name, fromPage: FromPage.profile.name,
                            );
                          }

                        },

                      );
                    }
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // for Phone Number section
                  Selector<AuthProvider, bool>(
                    selector: (context, authProvider) => authProvider.isNumberLogin,
                    builder: (context, isNumberLogin, child) {

                      final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                      print("---------------------(IS NUMBER LOGIN)--------------${authProvider.isNumberLogin}");

                      return Selector<VerificationProvider, bool>(
                        selector: (context, verificationProvider) => verificationProvider.isLoading,
                        builder: (context, isLoading, child) {
                          return CustomTextFieldWidget(
                            countryDialCode: isNumberLogin ? countryCode : null,
                            onCountryChanged: (CountryCode value) => countryCode = value.dialCode,
                            onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, authProvider),
                            title: getTranslated('phone_number', context),
                            hintText: getTranslated('enter_phone_number', context),
                            isEnabled: profileProvider.userInfoModel?.isPhoneVerified == 0,
                            isShowBorder: true,
                            controller: _phoneController,
                            isShowSuffixIcon: true,
                            fillColor: Theme.of(context).hintColor.withOpacity(0.08),
                            isToolTipSuffix: AuthHelper.isPhoneVerificationEnable(splashProvider.configModel) ? true : false,
                            toolTipMessage: profileProvider.userInfoModel?.isPhoneVerified == 0 ? getTranslated('phone_number_not_verified', context) : getTranslated('cant_update_phone_number',context),
                            toolTipKey: phoneToolTipKey,
                            suffixAssetUrl: AuthHelper.isPhoneVerificationEnable(config) && profileProvider.userInfoModel?.isPhoneVerified == 0 ? Images.notVerifiedProfileIcon : Images.verifiedProfileIcon,
                            focusNode: phoneFocus,
                            nextFocus: passwordFocus,
                            inputType: TextInputType.phone,

                            onSuffixTap: (){

                              final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                              final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
                              String userInput = (countryCode ?? '') + (_phoneController?.text.trim() ?? '');
                              verificationProvider.sendVerificationCode(
                                context, configModel!, userInput, type: VerificationType.phone.name, fromPage: FromPage.profile.name,
                              );

                            },

                          );
                        }
                      );

                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    title: getTranslated('password', context),
                    hintText: getTranslated('password_hint', context),
                    isShowBorder: true,
                    isPassword: true,
                    isShowSuffixIcon: true,
                    controller: _passwordController,
                    focusNode: passwordFocus,
                    nextFocus: confirmPasswordFocus,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    title: getTranslated('confirm_password', context),
                    hintText: getTranslated('password_hint', context),
                    isShowBorder: true,
                    isPassword: true,
                    isShowSuffixIcon: true,
                    controller: _confirmPasswordController,
                    focusNode: confirmPasswordFocus,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                ]),
              ),

              !profileProvider.isLoading && profileProvider.userInfoModel != null ? TextButton(
                onPressed: () async => _onSubmit(),
                child: Container(height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(getTranslated('save', context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Dimensions.paddingSizeDefault,
                    ),
                  )),
                ),
              ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),

            ]),
          )),
        );
      })),
    );
  }


  Future<void> _initLoading() async {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    emailFocus = FocusNode();
    phoneFocus = FocusNode();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();

    if(profileProvider.userInfoModel == null) {
      await profileProvider.getUserInfo(true, isUpdate: false).then((_){
        _firstNameController?.text = profileProvider.userInfoModel?.fName ?? '';
        _lastNameController?.text = profileProvider.userInfoModel?.lName ?? '';
        _emailController?.text = profileProvider.userInfoModel?.email ?? '';

        if(profileProvider.userInfoModel?.phone?.isNotEmpty ?? false){
          authProvider.toggleIsNumberLogin(value: true, isUpdate: false);
          countryCode = PhoneNumberCheckerHelper.getCountryCode(profileProvider.userInfoModel?.phone);
          _phoneController?.text = PhoneNumberCheckerHelper.getPhoneNumber(profileProvider.userInfoModel?.phone ?? '', countryCode ?? '')!;
          profileProvider.setCountryCode(countryCode ?? '',  isUpdate: true);
        }
      });
    }else{
      _firstNameController?.text = profileProvider.userInfoModel?.fName ?? '';
      _lastNameController?.text = profileProvider.userInfoModel?.lName ?? '';
      _emailController?.text = profileProvider.userInfoModel?.email ?? '';

      if(profileProvider.userInfoModel?.phone?.isNotEmpty ?? false){
        print("-------------------------(ORIGINAL ELSE)---------------${profileProvider.userInfoModel?.phone ?? ''} ");
        authProvider.toggleIsNumberLogin(value: true, isUpdate: false);
        countryCode = PhoneNumberCheckerHelper.getCountryCode(profileProvider.userInfoModel?.phone);
        _phoneController?.text = PhoneNumberCheckerHelper.getPhoneNumber(profileProvider.userInfoModel?.phone ?? '', countryCode ?? '')!;
        profileProvider.setCountryCode(countryCode ?? '',  isUpdate: false);

        print("-----------------(COUNTRY CODE ELSE) $countryCode and ------------(PHONE)----------${_phoneController?.text}");

      }
    }


    // _firstNameController?.text = profileProvider.userInfoModel?.fName ?? '';
    // _lastNameController?.text = profileProvider.userInfoModel?.lName ?? '';
    // _emailController?.text = profileProvider.userInfoModel?.email ?? '';
    //
    // if(profileProvider.userInfoModel?.phone?.isNotEmpty ?? false){
    //   print("-------------------------(ORIGINAL)---------------${profileProvider.userInfoModel?.phone ?? ''} ");
    //   authProvider.toggleIsNumberLogin(value: true, isUpdate: false);
    //   countryCode = PhoneNumberCheckerHelper.getCountryCode(profileProvider.userInfoModel?.phone);
    //   _phoneController?.text = PhoneNumberCheckerHelper.getPhoneNumber(profileProvider.userInfoModel?.phone ?? '', countryCode ?? '')!;
    //
    //   print("-----------------(COUNTRY CODE) $countryCode and ------------(PHONE)----------${_phoneController?.text}");
    //
    // }

  }

  Future<void> _onSubmit() async {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    String firstName = _firstNameController?.text.trim() ?? '';
    String lastName = _lastNameController?.text.trim() ?? '';
    String phoneNumber = (countryCode ?? '') + (_phoneController?.text.trim() ?? '');

    bool isPhoneValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phoneNumber);

    String password = _passwordController?.text.trim() ?? '';
    String confirmPassword = _confirmPasswordController?.text.trim() ?? '';
    if (profileProvider.userInfoModel?.fName == firstName &&
        profileProvider.userInfoModel?.lName == lastName &&
        profileProvider.userInfoModel?.phone == phoneNumber &&
        profileProvider.userInfoModel?.email == _emailController?.text
        && profileProvider.file == null && profileProvider.data == null && password.isEmpty && confirmPassword.isEmpty) {

      showCustomSnackBarHelper(getTranslated('change_something_to_update', context));

    }else if (firstName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_first_name', context));

    }else if (lastName.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_last_name', context));

    }else if (phoneNumber.isEmpty) {
      showCustomSnackBarHelper(getTranslated('enter_phone_number', context));

    }else if(!isPhoneValid){
      showCustomSnackBarHelper(getTranslated('invalid_phone_number', context));
    } else if((password.isNotEmpty && password.length < 6) || (confirmPassword.isNotEmpty && confirmPassword.length < 6)) {
      showCustomSnackBarHelper(getTranslated('password_should_be', context));

    } else if(password != confirmPassword) {
      showCustomSnackBarHelper(getTranslated('password_did_not_match', context));

    } else {
      UserInfoModel? updateUserInfoModel = profileProvider.userInfoModel;
      updateUserInfoModel?.fName = _firstNameController?.text;
      updateUserInfoModel?.lName = _lastNameController?.text;
      updateUserInfoModel?.phone = phoneNumber;
      updateUserInfoModel?.email = _emailController?.text;

      print("---------------------(PHONE)-------------------$phoneNumber");
      ResponseModel responseModel = await profileProvider.updateUserInfo(
        updateUserInfoModel!, password,
        profileProvider.file, profileProvider.data,
        authProvider.getUserToken(),
      );

      if (responseModel.isSuccess) {
        profileProvider.getUserInfo(true);
        _passwordController?.text = '';
        _confirmPasswordController?.text = '';

        showCustomSnackBarHelper('updated_successfully'.tr, isError: false);

      } else {
        showCustomSnackBarHelper(responseModel.message!, isError: true);

      }
      setState(() {});
    }
  }
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismiss by tapping outside
    builder: (BuildContext context) {
      return const CustomLoaderWidget(
        color: Colors.white,
      );
      // return Dialog(
      //
      //   backgroundColor: Colors.white,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSizeSmall)), // Rectangle shape
      //   ),
      //   child: ConstrainedBox(
      //     constraints: const BoxConstraints(minWidth: 50, maxWidth: 100),
      //     child: const Padding(
      //       padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      //       child: Column(mainAxisSize: MainAxisSize.min, children: [
      //         Center(child: CircularProgressIndicator(),
      //         ),
      //       ]),
      //     ),
      //   ),
      // );
    },
  );
}