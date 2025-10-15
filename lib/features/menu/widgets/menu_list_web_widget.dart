
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/menu/domain/models/menu_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:provider/provider.dart';

import '../../../helper/dialog_helper.dart';
import 'acount_delete_dialog_widget.dart';
import 'menu_item_web_widget.dart';

class MenuListWebWidget extends StatelessWidget {
  final bool isLoggedIn;
  const MenuListWebWidget({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final splashProvider =  Provider.of<SplashProvider>(context, listen: false);


    final List<MenuModel> menuList = [
      MenuModel(icon: Images.orderList, title: getTranslated('my_order', context), route:  RouteHelper.orderListScreen),
      MenuModel(icon: Images.trackOrder, title: getTranslated('track_order', context), route: RouteHelper.orderSearchScreen),

      MenuModel(icon: Images.editProfile, title: getTranslated('profile', context), route: isLoggedIn
          ? null : RouteHelper.getLoginRoute()),
      MenuModel(icon: Images.addressList, title: getTranslated('address', context), route: RouteHelper.address),
      MenuModel(icon: Images.customerSupport, title: getTranslated('live_chat', context), route: RouteHelper.getChatRoute(orderModel: null)),
      MenuModel(icon: Images.coupon, title: getTranslated('coupon', context), route: RouteHelper.coupon),
      MenuModel(icon: Images.notification, title: getTranslated('notification', context), route: RouteHelper.notification),

      if(splashProvider.configModel!.walletStatus!)
        MenuModel(icon: Images.wallet, title: getTranslated('wallet', context), route: RouteHelper.getWalletRoute()),
      if(splashProvider.configModel!.loyaltyPointStatus!)
        MenuModel(icon: Images.loyaltyPoint, title: getTranslated('loyalty_point', context), route: RouteHelper.getLoyaltyScreen()),

      MenuModel(icon: Images.message, title: getTranslated('contact_us', context), route: RouteHelper.getContactRoute()),
      MenuModel(icon: Images.privacyPolicy, title: getTranslated('privacy_policy', context), route: RouteHelper.getPolicyRoute()),
      MenuModel(icon: Images.termsAndConditions, title: getTranslated('terms_and_condition', context), route: RouteHelper.getTermsRoute()),

      if(splashProvider.configModel!.returnPolicyStatus!)
      MenuModel(icon: Images.returnPolicy, title: getTranslated('return_policy', context), route: RouteHelper.getReturnPolicyRoute()),

      if(splashProvider.configModel!.refundPolicyStatus!)
      MenuModel(icon: Images.refundPolicy, title: getTranslated('refund_policy', context), route: RouteHelper.getRefundPolicyRoute()),

      if(splashProvider.configModel!.cancellationPolicyStatus!)
      MenuModel(icon: Images.cancellationPolicy, title: getTranslated('cancellation_policy', context), route: RouteHelper.getCancellationPolicyRoute()),

      MenuModel(icon: Images.aboutUs, title: getTranslated('about_us', context), route: RouteHelper.getAboutUsRoute()),

      MenuModel(icon: isLoggedIn ? Images.logOut : Images.logIn, title: getTranslated(isLoggedIn ? 'log_out' : 'login', context), route: 'auth'),

    ];


    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Center(
        child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {

          if((splashProvider.configModel?.referEarnStatus ?? false)
              && profileProvider.userInfoModel?.referCode != null) {
            final MenuModel referMenu = MenuModel(
              icon: Images.referralIcon,
              title: getTranslated('referAndEarn', context),
              route: RouteHelper.getReferAndEarnRoute(),
            );
            menuList.removeWhere((menu) => menu.route == referMenu.route);
            menuList.insert(6, referMenu);

            if(!menuList.contains(referMenu)){

            }
          }

          return SizedBox(width: Dimensions.webScreenWidth, child: Stack(children: [
            Column(children: [
              Container(
                height: 150,
                color:  Theme.of(context).primaryColor.withOpacity(0.5),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 240.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                      '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    ) : const SizedBox(height: Dimensions.paddingSizeDefault, width: 150) : Column(
                      children: [
                        const SizedBox(height: 80),

                        Text(
                          getTranslated('guest', context),
                          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),
                      ],
                    ),

                    if(isLoggedIn) Column(
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          profileProvider.userInfoModel?.email ?? '',
                          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),
                      ],
                    ),


                  ],
                ),

              ),
              const SizedBox(height: 100),

              Builder(
                  builder: (context) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
                        mainAxisSpacing: Dimensions.paddingSizeExtraLarge,
                      ),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) => MenuItemWebWidget(menu: menuList[index]),
                    );
                  }
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ]),

            Positioned(left: 30, top: 45, child: Container(
              height: 180, width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: const Offset(0, 8.8) )],
                color: Theme.of(context).secondaryHeaderColor,
              ),
              // decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
              //     boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: const Offset(0, 8.8) )]),
              child: ClipOval(
                child: isLoggedIn ? CustomImageWidget(
                  placeholder: Images.placeHolder, height: 170, width: 170, fit: BoxFit.cover,
                  image: '${splashProvider.baseUrls?.customerImageUrl}/''${profileProvider.userInfoModel?.image ?? ''}',
                ) : const CustomAssetImageWidget(Images.placeHolder, height: 170, width: 170, fit: BoxFit.cover),
              ),
            )),

            Positioned(right: 0, top: 140, child: isLoggedIn ? Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: InkWell(
                onTap: (){
                  showDialogHelper(context,
                      AccountDeleteDialogWidget(
                        icon: Icons.question_mark_sharp,
                        title: getTranslated('are_you_sure_to_delete_account', context),
                        description: getTranslated('it_will_remove_your_all_information', context),
                        onTapFalseText:getTranslated('no', context),
                        onTapTrueText: getTranslated('yes', context),
                        isFailed: true,
                        onTapFalse: () => Navigator.of(context).pop(),
                        onTapTrue: () => Provider.of<AuthProvider>(context, listen: false).deleteUser(context),
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                child: Row(children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: 16),
                  ),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text(getTranslated('delete_account', context)),
                  ),

                ],),
              ),
            ) : const SizedBox()),

          ]));
        }),
      )),

      const FooterWebWidget(footerType: FooterType.sliver),
    ]);
  }
}


