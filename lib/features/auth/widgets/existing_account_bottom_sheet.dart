import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_mask_info.dart';
import 'package:flutter_grocery/features/auth/domain/models/user_log_data.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ExistingAccountBottomSheet extends StatefulWidget {
  final UserInfoModel userInfoModel;
  final String socialLoginMedium;
  final String socialUserName;
  const ExistingAccountBottomSheet({
    super.key,
    required this.userInfoModel,
    required this.socialLoginMedium,
    required this.socialUserName
  });


  @override
  State<ExistingAccountBottomSheet> createState() => _ExistingAccountBottomSheetState();
}

class _ExistingAccountBottomSheetState extends State<ExistingAccountBottomSheet> {
  @override
  Widget build(BuildContext context) {

    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final Size size = MediaQuery.of(context).size;

    print("--------------------------(EXISTING ACCOUNT)---------------UserInfoModel : ${widget.userInfoModel.toJson()} and Medium : ${widget.socialLoginMedium} and UserName : ${widget.socialUserName}");

    return Column(mainAxisSize: MainAxisSize.min, children: [

      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.08 : size.height * 0.015),

      CircleAvatar(
        radius: size.height * 0.05,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? size.height * 0.1 : 40),
          child: CustomImageWidget(
            image: widget.userInfoModel.image != null ? "${configModel?.baseUrls?.customerImageUrl}/${widget.userInfoModel.image}" : '',
            fit: BoxFit.fill,
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Text("${widget.userInfoModel.fName} ${widget.userInfoModel.lName}",
        style: poppinsRegular.copyWith(
          fontSize: Dimensions.fontSizeDefault,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      Text(getTranslated('is_it_you', context),
        style: poppinsBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Padding(padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? size.width * 0.03 : size.height * 0.02),
        child: RichText(textAlign: TextAlign.center, text: TextSpan(children:[

          TextSpan(
              text: getTranslated('it_looks_like_the_email', context),
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.5),
              ),
            ),

          TextSpan(
              text: ' ${CustomMaskInfo.maskedEmail(widget.userInfoModel.email ?? '')} ',
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor,
              ),
            ),

          TextSpan(
              text: getTranslated('already_used_existing_account', context),
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).hintColor.withOpacity(0.5),
              ),
            ),

        ])),
      ),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.03 : size.height * 0.02),

      Row(children: [

        Expanded(child: Container()),

        Expanded(flex: 3, child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButtonWidget(
              backgroundColor: Theme.of(context).hintColor,
              isLoading: authProvider.isLoading,
              buttonText: getTranslated('no', context),
              onPressed: (){

                print("----------------------(EXISTING ACCOUNT BOTTOM SHEET)-------Email: ${widget.userInfoModel.email} and Medium: ${widget.socialLoginMedium}");

                if(!authProvider.isLoading){
                  Navigator.pop(context);
                  authProvider.existingAccountCheck(email: widget.userInfoModel.email!, userResponse: 0, medium: widget.socialLoginMedium).then((value){
                    final (responseModel, tempToken) = value;
                    print("--------------- EXISTING API RESPONSE - Message is ${responseModel?.message}");
                    if(responseModel != null && responseModel.isSuccess && responseModel.message == 'tempToken'){
                      Navigator.pushReplacementNamed(
                        Get.context!,
                        RouteHelper.getOtpRegistration(tempToken, widget.userInfoModel.email!, userName: widget.socialUserName),
                      );
                    }
                  });
                }

              },
            );
          }
        )),

        Expanded(child: Container()),

        Expanded(flex: 3,child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return CustomButtonWidget(
              isLoading: authProvider.isLoading,
              buttonText: getTranslated('yes_its_me', context),
              onPressed: (){

                print("----------------------(EXISTING ACCOUNT BOTTOM SHEET)-------Email: ${widget.userInfoModel.email} and Medium: ${widget.socialLoginMedium}");

                if(!authProvider.isLoading){
                  Navigator.pop(context);
                  authProvider.existingAccountCheck(email: widget.userInfoModel.email!, userResponse: 1, medium: widget.socialLoginMedium).then((value){
                    final (responseModel, tempToken) = value;
                    print("--------------- EXISTING API RESPONSE - Message is ${responseModel?.message}");
                    if(responseModel != null && responseModel.isSuccess && responseModel.message == 'token') {
                      authProvider.saveUserNumberAndPassword(
                        UserLogData(
                          phoneNumber: widget.userInfoModel.phone,
                          email: widget.userInfoModel.email,
                          password: null,
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(Get.context!, RouteHelper.getMainRoute(), (route) => false);
                    }
                  });
                }
              },
            );
          }
        )),

        Expanded(child: Container()),

      ],),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? size.height * 0.04 : Dimensions.paddingSizeLarge),


    ],);
  }
}