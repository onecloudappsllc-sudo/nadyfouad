import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';
import 'package:flutter_grocery/features/auth/enum/verification_type_enum.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/features/profile/screens/profile_edit_screen.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/phone_number_checker_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileMenuWebWidget extends StatefulWidget {
  final FocusNode? firstNameFocus;
  final FocusNode? lastNameFocus;
  final FocusNode? emailFocus;
  final FocusNode? phoneNumberFocus;
  final FocusNode? passwordFocus;
  final FocusNode? confirmPasswordFocus;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneNumberController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final UserInfoModel? userInfoModel;
  final Function pickImage;
  final PickedFile? file;
  final String? image;


  const ProfileMenuWebWidget({
    super.key,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.emailFocus,
    required this.phoneNumberFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneNumberController,
    required this.passwordController,
    required this.confirmPasswordController,
    //function
    required this.pickImage,
    //file
    required this.file,
    required this.image,
    required this.userInfoModel,


  });

  @override
  State<ProfileMenuWebWidget> createState() => _ProfileMenuWebWidgetState();
}

class _ProfileMenuWebWidgetState extends State<ProfileMenuWebWidget> {
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final phoneToolTipKey = GlobalKey<State<Tooltip>>();
    final emailToolTipKey = GlobalKey<State<Tooltip>>();



    return CustomScrollView(slivers: [

      SliverToBoxAdapter(child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
        return Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Stack(children: [

              Column(children: [

                Container( height: 150, color: Theme.of(context).primaryColor.withOpacity(0.5),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 240.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                    profileProvider.userInfoModel != null ? Text(
                      '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    ) : const SizedBox(height: Dimensions.paddingSizeDefault, width: 150),

                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    profileProvider.userInfoModel != null ? Text(
                      profileProvider.userInfoModel!.email ?? '',
                      style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    ) : const SizedBox(height: 15, width: 100),

                  ]),
                ),
                const SizedBox(height: 100),

                SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      SizedBox(width: 400, child: CustomTextFieldWidget(
                        hintText: 'John',
                        isShowBorder: true,
                        title: getTranslated('first_name', context),
                        controller: widget.firstNameController,
                        focusNode: widget.firstNameFocus,
                        nextFocus: widget.lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // for email section
                      SizedBox(width: 400, child: Selector<VerificationProvider, bool>(
                        selector: (context, verificationProvider) => verificationProvider.isLoading,
                        builder: (context, isLoading, child) {
                          return CustomTextFieldWidget(
                            hintText: getTranslated('demo_gmail', context),
                            title: getTranslated('email', context),
                            isShowBorder: true,
                            controller: widget.emailController,
                            isEnabled: true,
                            focusNode: widget.emailFocus,
                            nextFocus: widget.phoneNumberFocus,
                            inputType: TextInputType.emailAddress,
                            isShowSuffixIcon: true,
                            isToolTipSuffix: AuthHelper.isEmailVerificationEnable(splashProvider.configModel) && widget.emailController!.text.isNotEmpty? true : false,
                            toolTipMessage: profileProvider.userInfoModel?.emailVerifiedAt == null ? getTranslated('email_not_verified', context) : '',
                            toolTipKey: emailToolTipKey,
                            suffixAssetUrl: AuthHelper.isEmailVerificationEnable(splashProvider.configModel) && profileProvider.userInfoModel?.emailVerifiedAt == null ? Images.notVerifiedProfileIcon : Images.verifiedProfileIcon,
                            onSuffixTap: (){

                              if(profileProvider.userInfoModel?.emailVerifiedAt == null){
                                final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                                final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(context, listen: false);

                                verificationProvider.sendVerificationCode(
                                  context, configModel!, widget.emailController?.text.trim() ?? '', type: VerificationType.email.name, fromPage: FromPage.profile.name,
                                );
                              }


                            },

                          );
                        }
                      )),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      SizedBox(width: 400,
                        child: CustomTextFieldWidget(
                          title: getTranslated('password', context),
                          hintText: getTranslated('password_hint', context),
                          isShowBorder: true,
                          controller: widget.passwordController,
                          focusNode: widget.passwordFocus,
                          nextFocus: widget.confirmPasswordFocus,
                          isPassword: true,
                          isShowSuffixIcon: true,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                    ]),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      SizedBox(width: 400, child: CustomTextFieldWidget(
                        title: getTranslated('last_name', context),
                        hintText: 'Doe',
                        isShowBorder: true,
                        controller: widget.lastNameController,
                        focusNode: widget.lastNameFocus,
                        nextFocus: widget.phoneNumberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      )),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      //for phone Number section
                      SizedBox(width: 400, child: Selector<AuthProvider, bool>(
                        selector: (context, authProvider) => authProvider.isNumberLogin,
                        builder: (context, isNumberLogin, child) {
                          final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
                          print("---------------------(IS NUMBER LOGIN)--------------${authProvider.isNumberLogin}");

                          return Selector<ProfileProvider, String?>(
                            selector: (context, profileProvider) => profileProvider.countryCode,
                            builder: (context, countryCode, child) {
                              return Selector<VerificationProvider, bool>(
                                selector: (context, verificationProvider) => verificationProvider.isLoading,
                                builder: (context, isLoading, child) {
                                  return CustomTextFieldWidget(
                                    countryDialCode: isNumberLogin ?  countryCode : null,
                                    onCountryChanged: (CountryCode value){
                                      profileProvider.setCountryCode(value.dialCode ?? '');
                                    },
                                    onChanged: (String text) => AuthHelper.identifyEmailOrNumber(text, authProvider),
                                    title: getTranslated('phone_number', context),
                                    hintText: getTranslated('enter_phone_number', context),
                                    isShowBorder: true,
                                    controller: widget.phoneNumberController,
                                    focusNode: widget.phoneNumberFocus,
                                    nextFocus: widget.passwordFocus,
                                    inputType: TextInputType.phone,
                                    fillColor: Theme.of(context).hintColor.withOpacity(0.08),
                                    isEnabled: profileProvider.userInfoModel?.isPhoneVerified == 0,
                                    isShowSuffixIcon: true,
                                    isToolTipSuffix: AuthHelper.isPhoneVerificationEnable(splashProvider.configModel) ? true : false,
                                    toolTipMessage: profileProvider.userInfoModel?.isPhoneVerified == 0 ? getTranslated('phone_number_not_verified', context) : getTranslated('cant_update_phone_number',context),
                                    toolTipKey: phoneToolTipKey,
                                    suffixAssetUrl: AuthHelper.isPhoneVerificationEnable(splashProvider.configModel) && profileProvider.userInfoModel?.isPhoneVerified == 0 ? Images.notVerifiedProfileIcon : Images.verifiedProfileIcon,
                                    onSuffixTap: (){

                                      final configModel = Provider.of<SplashProvider>(context, listen : false).configModel;
                                      final VerificationProvider verificationProvider = Provider.of<VerificationProvider>(context, listen: false);
                                      String userInput = (countryCode ?? '') + (widget.phoneNumberController?.text.trim() ?? '');
                                      verificationProvider.sendVerificationCode(
                                        context, configModel!, userInput, type: VerificationType.phone.name, fromPage: FromPage.profile.name,
                                      );

                                    },

                                  );
                                }
                              );
                            }
                          );
                        },
                      )),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        SizedBox(width: 400, child: CustomTextFieldWidget(
                          title: getTranslated('confirm_password', context),
                          hintText: getTranslated('password_hint', context),
                          isShowBorder: true,
                          controller: widget.confirmPasswordController,
                          focusNode: widget.confirmPasswordFocus,
                          isPassword: true,
                          isShowSuffixIcon: true,
                          inputAction: TextInputAction.done,
                        )),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                      ]),

                    ]),
                    const SizedBox(height: 55.0)

                  ]),

                  SizedBox(width: 180.0, child: CustomButtonWidget(
                    isLoading: profileProvider.isLoading,
                    buttonText: getTranslated('update_profile', context),
                    onPressed: () async => _onSubmit(),
                  )),
                ])),

              ]),

              Positioned(left: 30, top: 45, child: Stack(children: [

                Container(height: 180, width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: const Offset(0, 8.8) )],
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: ClipOval(
                      child: profileProvider.file != null
                          ?  Image.file(profileProvider.file!, width: 80, height: 80, fit: BoxFit.contain) : profileProvider.data != null
                          ?  Image.network(profileProvider.data!.path, width: 80, height: 80, fit: BoxFit.fill) : CustomImageWidget(
                        placeholder: Images.placeHolder, height: 170, width: 170, fit: BoxFit.cover,
                        image: '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image ?? widget.image}',
                      ),
                    ),
                  ),

                Positioned(bottom: 10, right: 10, child: InkWell(
                    onTap: widget.pickImage as void Function()?,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,color: Colors.white60),
                    ),
                  )),

              ])),

        ])));

      })),
      const FooterWebWidget(footerType: FooterType.sliver),

    ]);
  }



  Future<void> _onSubmit() async {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    String firstName = widget.firstNameController?.text.trim() ?? '';
    String lastName = widget.lastNameController?.text.trim() ?? '';
    String password = widget.passwordController?.text.trim() ?? '';
    String confirmPassword = widget.confirmPasswordController?.text.trim() ?? '';
    String email = widget.emailController?.text.trim() ?? '';

    String phoneNumber = (profileProvider.countryCode ?? '') + (widget.phoneNumberController?.text.trim() ?? '');
    print('--------------(PHONE NUMBER)-----------$phoneNumber');

    bool isPhoneValid = PhoneNumberCheckerHelper.isPhoneValidWithCountryCode(phoneNumber);

    if (profileProvider.userInfoModel?.fName == firstName &&
        profileProvider.userInfoModel?.lName == lastName &&
        profileProvider.userInfoModel?.phone == phoneNumber &&
        profileProvider.userInfoModel?.email == email && widget.file == null
        && password.isEmpty && confirmPassword.isEmpty) {
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
      UserInfoModel updateUserInfoModel = UserInfoModel();
      updateUserInfoModel.fName = firstName;
      updateUserInfoModel.lName = lastName;
      updateUserInfoModel.phone = phoneNumber;
      updateUserInfoModel.email = email;
      String pass = password;

      ResponseModel responseModel = await profileProvider.updateUserInfo(
        updateUserInfoModel, pass,
        profileProvider.file, profileProvider.data,
        Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      );

      if (responseModel.isSuccess) {
        profileProvider.getUserInfo(true);
        widget.passwordController?.text = '';
        widget.confirmPasswordController?.text = '';
        showCustomSnackBarHelper('updated_successfully'.tr, isError: false);

      } else {
        showCustomSnackBarHelper(responseModel.message!, isError: true);

      }
      setState(() {});
    }
  }
}
