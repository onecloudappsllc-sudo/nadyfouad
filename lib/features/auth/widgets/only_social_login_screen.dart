import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_grocery/features/auth/enum/social_login_options_enum.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class OnlySocialLoginWidget extends StatefulWidget {
  const OnlySocialLoginWidget({Key? key}) : super(key: key);



  @override
  State<OnlySocialLoginWidget> createState() => _OnlySocialLoginWidgetState();
}

class _OnlySocialLoginWidgetState extends State<OnlySocialLoginWidget> {


  void route(bool isRoute, String? token, String? errorMessage, String? tempToken, UserInfoModel? userInfoModel, String? socialLoginMedium, String? email, String? name) async {
    if (isRoute) {
      if(token != null){
        Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
      }else if(tempToken != null){
        Navigator.pushNamed(context, RouteHelper.getOtpRegistration(
          tempToken, email ?? '', userName: name ?? '',
        ));
      } else if(userInfoModel != null){
        ResponsiveHelper.showDialogOrBottomSheet(
          context,
          CustomAlertDialogWidget(
            // width: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.width * 0.3 : null,
            child: ExistingAccountBottomSheet(userInfoModel: userInfoModel, socialLoginMedium: socialLoginMedium!, socialUserName: name ?? ''),
          ),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage ?? ''), backgroundColor: Theme.of(context).colorScheme.error));
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage ?? ''), backgroundColor: Theme.of(context).colorScheme.error));
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;


    return CustomPopScopeWidget(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : null,
        body: SafeArea(child: Center(child: CustomScrollView(slivers: [

          SliverToBoxAdapter(child: Column(children: [


            Center(child: Container(
              width: size.width > 700 ? 450 : size.width,
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              padding: size.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: size.width > 700 ? BoxDecoration(
                color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.07),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0,10),
                ),],
              ) : null,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                SizedBox(
                  height: ResponsiveHelper.isDesktop(context) ? size.height * 0.03 :
                  size.height * 0.05 ,
                ),

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomAssetImageWidget(Images.appLogo,
                    height: ResponsiveHelper.isDesktop(context)
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height / 4.5,
                    fit: BoxFit.scaleDown,),
                ),

                SizedBox(height: size.height * 0.01),

                Text(getTranslated('welcome_to_eFood', context),
                  style: poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                if(AuthHelper.isGoogleLoginEnable(configModel))...[
                  Row(children: [

                    Expanded(child: Container()),

                    Expanded(flex: 4,
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return InkWell(
                          onTap: ()async{
                            try{
                              GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                              GoogleSignInAccount googleAccount = authProvider.googleAccount!;

                              authProvider.socialLogin(SocialLoginModel(
                                email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: SocialLoginOptionsEnum.google.name), route);


                            }catch(er){
                              debugPrint('access token error is : $er');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Image.asset(Images.google,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 20 :ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 20 : ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(getTranslated("continue_with_google", context), style: poppinsSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),),

                            ],),
                          ),
                        );
                      }),
                    ),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],

                if(AuthHelper.isFacebookLoginEnable(configModel))...[
                  Row(children: [

                    Expanded(child: Container()),

                    Expanded(flex: 4,
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return InkWell(
                          onTap: () async{
                            LoginResult result = await FacebookAuth.instance.login();

                            if (result.status == LoginStatus.success) {
                              Map userData = await FacebookAuth.instance.getUserData();

                              authProvider.socialLogin(
                                SocialLoginModel(
                                  email: userData['email'], token: result.accessToken!.token, uniqueId: result.accessToken!.userId,
                                  medium: SocialLoginOptionsEnum.facebook.name,
                                ), route,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Image.asset(Images.facebook,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 20 :ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 20 : ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(getTranslated("continue_with_facebook", context), style: poppinsSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),),

                            ],),
                          ),
                        );
                      }),
                    ),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],

                if(AuthHelper.isAppleLoginEnable(configModel))...[
                  Row(children: [

                    Expanded(child: Container()),

                    Expanded(flex: 4,
                      child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return InkWell(
                          onTap: () async {
                            final credential = await SignInWithApple.getAppleIDCredential(scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                              webAuthenticationOptions: WebAuthenticationOptions(
                                clientId: '${configModel?.appleLogin?.clientId}',
                                redirectUri: Uri.parse(AppConstants.baseUrl),
                              ),
                            );
                            authProvider.socialLogin(SocialLoginModel(
                              email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode,
                              medium: SocialLoginOptionsEnum.apple.name,
                            ), route);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                            ),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Image.asset(
                                Images.appleLogo, color: Theme.of(context).textTheme.bodyMedium?.color,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 20 :ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 20 : ResponsiveHelper.isTab(context)
                                    ? 20 : 15,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                              Text(getTranslated("continue_with_apple", context), style: poppinsSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              )),

                            ]),
                          ),
                        );
                      }),
                    ),

                    Expanded(child: Container()),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],

                if(configModel?.isGuestCheckout == true && !Navigator.canPop(context))...[
                  Center(child: Text(
                    getTranslated('or', context),
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Center(child: InkWell(
                    //onTap: ()=> RouterHelper.getDashboardRoute('home', ),
                    child: RichText(text: TextSpan(children: [

                      TextSpan(text: '${getTranslated('continue_as_a', context)} ',
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),

                      TextSpan(text: getTranslated('guest', context),
                        style: poppinsRegular.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                    ])),
                  )),
                  SizedBox(height: size.height * 0.03),
                ],


              ]),
            )),

            if(ResponsiveHelper.isDesktop(context)) const SizedBox(height: 50),

          ])),

          if(ResponsiveHelper.isDesktop(context)) const SliverFillRemaining(
            hasScrollBody: false,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [

              SizedBox(height: Dimensions.paddingSizeLarge),

              FooterWebWidget(footerType: FooterType.sliver),

            ]),
          ),

        ]))),
      ),
    );
  }
}

