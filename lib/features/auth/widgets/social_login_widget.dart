import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_grocery/features/auth/enum/social_login_options_enum.dart';
import 'package:flutter_grocery/features/auth/widgets/existing_account_bottom_sheet.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/features/auth/widgets/media_button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({super.key});


  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget> {
  SocialLoginModel socialLogin = SocialLoginModel();
  TextEditingController phoneController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void route(bool isRoute, String? token, String? errorMessage, String? tempToken, UserInfoModel? userInfoModel, String? socialLoginMedium, String? email, String? name) async {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
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
            child: ExistingAccountBottomSheet(userInfoModel: userInfoModel, socialLoginMedium: socialLoginMedium!, socialUserName: name ?? '',),
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
    final ConfigModel? configModel = Provider.of<SplashProvider>(context,listen: false).configModel;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {

        if(authProvider.countSocialLoginOptions == 1){
          return Row(children: [

            if(AuthHelper.isGoogleLoginEnable(configModel))
              Expanded(child: InkWell(
                onTap: () async {
                  try{
                    GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                    GoogleSignInAccount googleAccount = authProvider.googleAccount!;

                    print("------------------- (SOCIAL LOGIN WIDGET)----------------- Email : ${googleAccount.email} and Medium : ${SocialLoginOptionsEnum.google.name}");
                    authProvider.socialLogin(
                      SocialLoginModel(
                        email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: SocialLoginOptionsEnum.google.name,
                        name: googleAccount.displayName
                      ),
                      route
                    );
                  }catch(er){
                    debugPrint('access token error is : $er');
                  }
                },
                child: SocialLoginButtonWidget(
                  text: getTranslated('continue_with_google', context),
                  image: Images.google,
                ),

              )),

            if(AuthHelper.isFacebookLoginEnable(configModel))
              Expanded(child: InkWell(
                onTap: () async{
                  LoginResult result = await FacebookAuth.instance.login();

                  if (result.status == LoginStatus.success) {
                    Map userData = await FacebookAuth.instance.getUserData();


                    authProvider.socialLogin(
                      SocialLoginModel(
                        email: userData['email'], token: result.accessToken!.token, uniqueId: result.accessToken!.userId,
                        medium: SocialLoginOptionsEnum.facebook.name,
                        name: userData['name']
                      ), route,
                    );
                  }
                },
                child: SocialLoginButtonWidget(
                  text: getTranslated('continue_with_facebook', context),
                  image: Images.facebook,
                ),
              ),),

            if(AuthHelper.isAppleLoginEnable(configModel))
              Expanded(
                child: InkWell(
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
                      email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: SocialLoginOptionsEnum.apple.name,
                      name: credential.givenName
                    ), route);
                  },
                  child: SocialLoginButtonWidget(
                    text: getTranslated('continue_with_apple', context),
                    image: Images.appleLogo,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
          ]);
        }

        else if(authProvider.countSocialLoginOptions == 2){
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            if(AuthHelper.isGoogleLoginEnable(configModel))...[
              Expanded(child: InkWell(
                onTap: () async {
                  try{
                    GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                    GoogleSignInAccount googleAccount = authProvider.googleAccount!;


                    authProvider.socialLogin(SocialLoginModel(
                      email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: SocialLoginOptionsEnum.google.name,
                      name : googleAccount.displayName
                    ), route);


                  }catch(er){
                    debugPrint('access token error is : $er');
                  }
                },
                child: SocialLoginButtonWidget(
                  text: getTranslated('google', context),
                  image: Images.google,
                ),

              )),
              const SizedBox(width: Dimensions.paddingSizeDefault),
            ],

            if(AuthHelper.isFacebookLoginEnable(configModel))...[

              Expanded(child: InkWell(
                onTap: () async{

                  LoginResult result = await FacebookAuth.instance.login();
                  if (result.status == LoginStatus.success) {
                    Map userData = await FacebookAuth.instance.getUserData();

                    authProvider.socialLogin(
                      SocialLoginModel(
                        email: userData['email'],
                        token: result.accessToken!.token,
                        uniqueId: result.accessToken!.userId,
                        medium: SocialLoginOptionsEnum.facebook.name,
                        name: userData['name']
                      ), route,
                    );
                  }
                },
                child: SocialLoginButtonWidget(
                  text: getTranslated('facebook', context),
                  image: Images.facebook,
                ),
              )),
              AuthHelper.isAppleLoginEnable(configModel) ? const SizedBox(width: Dimensions.paddingSizeDefault) : const SizedBox.shrink(),
            ],

            if(AuthHelper.isAppleLoginEnable(configModel))...[
              Expanded(
                child: InkWell(
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
                      email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: SocialLoginOptionsEnum.apple.name,
                      name: credential.givenName
                    ), route);
                  },
                  child: SocialLoginButtonWidget(
                    text: getTranslated('apple', context),
                    image: Images.appleLogo,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],

          ],);
        }

        else if(authProvider.countSocialLoginOptions == 3){
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            if(AuthHelper.isGoogleLoginEnable(configModel))...[
              InkWell(
                onTap: () async {
                  try{
                    GoogleSignInAuthentication  auth = await authProvider.googleLogin();
                    GoogleSignInAccount googleAccount = authProvider.googleAccount!;

                    authProvider.socialLogin(SocialLoginModel(
                      email: googleAccount.email, token: auth.accessToken, uniqueId: googleAccount.id, medium: SocialLoginOptionsEnum.google.name,
                      name: googleAccount.displayName
                    ), route);


                  }catch(er){
                    debugPrint('access token error is : $er');
                  }
                },
                child: const SocialLoginButtonWidget(
                  image: Images.google,
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                ),

              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),
            ],

            if(AuthHelper.isFacebookLoginEnable(configModel))...[
              InkWell(
                onTap: () async{
                  LoginResult result = await FacebookAuth.instance.login();

                  if (result.status == LoginStatus.success) {
                    Map userData = await FacebookAuth.instance.getUserData();


                    authProvider.socialLogin(
                      SocialLoginModel(
                        email: userData['email'],
                        token: result.accessToken!.token,
                        uniqueId: result.accessToken!.userId,
                        medium: SocialLoginOptionsEnum.facebook.name,
                        name: userData['name']
                      ), route,
                    );
                  }
                },
                child: const SocialLoginButtonWidget(
                  image: Images.facebook,
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),
            ],

            if(AuthHelper.isAppleLoginEnable(configModel))...[
              InkWell(
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
                    email: credential.email, token: credential.authorizationCode, uniqueId: credential.authorizationCode, medium: SocialLoginOptionsEnum.apple.name,
                    name: credential.givenName
                  ), route);
                },
                child: SocialLoginButtonWidget(
                  image: Images.appleLogo,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                ),
              ),
            ],

          ],);
        }

        else{
          return Container();
        }
      }
    );
  }
}

class SocialLoginButtonWidget extends StatelessWidget {
  final String? text;
  final String image;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const SocialLoginButtonWidget({super.key,
    this.text, required this.image, this.color, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(
          image,
          color: color,
          height: ResponsiveHelper.isDesktop(context)
              ? 25 :ResponsiveHelper.isTab(context)
              ? 20 : 15,
          width: ResponsiveHelper.isDesktop(context)
              ? 25 : ResponsiveHelper.isTab(context)
              ? 20 : 15,
        ),


        if(text != null)...[
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Text(text!, style: poppinsSemiBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),)
        ],


      ],),
    );
  }
}



