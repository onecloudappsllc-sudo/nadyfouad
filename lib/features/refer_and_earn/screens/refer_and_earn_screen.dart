import 'package:dotted_border/dotted_border.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/refer_and_earn/helper/refer_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'refer_hint_widget.dart';


class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final List<String> shareItem = ['messenger', 'whatsapp', 'gmail', 'viber', 'share' ];
  final List<String?> hintList = [
    getTranslated('invite_your_friends', Get.context!),
    '${getTranslated('they_register', Get.context!)} ${AppConstants.appName} ${getTranslated('with_special_offer', Get.context!)}',
    getTranslated('you_made_your_earning', Get.context!),
  ];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : null,

      body: _isLoggedIn ? configModel != null && configModel.walletStatus! ? Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
          return profileProvider.userInfoModel != null ? Center(child: ExpandableBottomSheet(
            background: SingleChildScrollView(
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeExtraSmall,
              ),
              child: Column(
                children: [
                  Container(
                    constraints: ResponsiveHelper.isDesktop(context) ? const BoxConstraints() :
                    BoxConstraints(maxHeight: ResponsiveHelper.isDesktop(context)
                        ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.7),
                    width: ResponsiveHelper.isDesktop(context) ?  750 : double.maxFinite,
                    child: !ResponsiveHelper.isDesktop(context) ? SingleChildScrollView(
                      child: DetailsView(size: size, shareItem: shareItem, hintList: hintList),
                    ) : DetailsView(size: size, shareItem: shareItem, hintList: hintList),
                  ),

                  const FooterWebWidget(footerType: FooterType.nonSliver),
                ],
              ),
            ),
            persistentContentHeight: MediaQuery.of(context).size.height * 0.18,
            expandableContent: ResponsiveHelper.isDesktop(context)
                ? const SizedBox() : ReferHintWidget(hintList: hintList),
          ))
              : CustomLoaderWidget(color: Theme.of(context).primaryColor);
        }
      ) : NoDataWidget(title: getTranslated('not_found', context)) : const NotLoggedInWidget(),
    );
  }
}

class DetailsView extends StatelessWidget {
  const DetailsView({
    super.key,
    required Size size,
    required this.shareItem,
    required this.hintList,
  }) : _size = size;

  final Size _size;
  final List<String> shareItem;
  final List<String?> hintList;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return profileProvider.userInfoModel != null ? Column(
            children: [
              Image.asset(Images.referBanner, height: _size.height * 0.3),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Text(
                getTranslated('invite_friend_and_businesses', context),
                textAlign: TextAlign.center,
                style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeOverLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Text(
                getTranslated('copy_your_code', context),
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Text(
                getTranslated('your_personal_code', context),
                textAlign: TextAlign.center,
                style: poppinsRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge,),

              DottedBorder(
                padding: const EdgeInsets.all(4),
                borderType: BorderType.RRect,
                radius: const Radius.circular(20),
                dashPattern: const [5, 5],
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                strokeWidth: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Text(profileProvider.userInfoModel!.referCode ?? '',
                              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ),

                      InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {

                            if(profileProvider.userInfoModel!.referCode != null && profileProvider.userInfoModel!.referCode  != ''){
                              Clipboard.setData(ClipboardData(text: '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.referCode : ''}'));
                              showCustomSnackBarHelper(getTranslated('referral_code_copied', context), isError: false);
                            }
                          },
                          child: Container(
                            width: 85,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(60),
                            ),
                            child: FittedBox(
                              child: Text(getTranslated('copy', context),style: poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withOpacity(0.9),
                              )),
                            ),
                          ),
                        ),

                    ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              Text(
                getTranslated('or_share', context),
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Share.share(ReferHelper.getSignUpLink(profileProvider.userInfoModel!.referCode!)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    Images.getShareIcon('share'), height: 50, width: 50,
                  ),
                ),
              ),

              if(ResponsiveHelper.isDesktop(context))
                Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  ReferHintWidget(hintList: hintList),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ]),


            ],
          ) : const SizedBox();
        }
    );
  }
}
