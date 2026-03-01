
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/wallet_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/menu/screens/menu_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/bonus_slider_widget.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/wallet_card_widget.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/wallet_history_list_widget.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/wallet_uses_manual_widget.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  final String? token;
  final String? status;
  const WalletScreen({Key? key, this.token, this.status}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _isLoggedIn = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();
  List<PopupMenuEntry> entryList = [];


  @override
  void initState() {
    super.initState();
    final walletProvide = Provider.of<WalletAndLoyaltyProvider>(context, listen: false);

    walletProvide.setCurrentTabButton(0, isUpdate: false);
    walletProvide.insertFilterList();
    walletProvide.setWalletFilerType('all', isUpdate: false);

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if(widget.status != null &&  widget.status!.contains('success')){

        if(!kIsWeb || (kIsWeb && widget.token != null && walletProvide.checkToken(widget.token!))){
          showCustomSnackBarHelper(getTranslated('add_fund_successful', context), isError: false);
        }

      }else if(widget.status != null && widget.status!.contains('fail')){
        showCustomSnackBarHelper(getTranslated('add_fund_failed', context));
      }
    });

    if(_isLoggedIn){
      walletProvide.getWalletBonusList(false);
      Provider.of<ProfileProvider>(Get.context!, listen: false).getUserInfo(true);
      walletProvide.getLoyaltyTransactionList('1', false, true, isEarning: walletProvide.selectedTabButtonIndex == 1);

      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent
            && walletProvide.transactionList != null
            && !walletProvide.isLoading) {

          int pageSize = (walletProvide.popularPageSize! / 10).ceil();
          if (walletProvide.offset < pageSize) {
            walletProvide.setOffset = walletProvide.offset + 1;
            walletProvide.updatePagination(true);


            walletProvide.getLoyaltyTransactionList(
              walletProvide.offset.toString(), false, true, isEarning: walletProvide.selectedTabButtonIndex == 1,
            );
          }
        }
      });
    }

  }
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return WillPopScope(
      onWillPop: () async {
        if(!Navigator.canPop(context)){
          Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => const MenuScreen(),
          ), (route) => false);
          return false;
        }else{
          Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
          return false;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
            : null,

        body: Consumer<WalletAndLoyaltyProvider>(builder: (context, walletProvider, _) {
          entryList = WalletHelper.getPopupMenuList(walletFilterList: walletProvider.walletFilterList, type: walletProvider.type);

          return RefreshIndicator(
            onRefresh: () async{
              walletProvider.getLoyaltyTransactionList('1', true, true);
              Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true);
            },
            child: _isLoggedIn ? configModel != null && configModel.walletStatus! ? CustomScrollView(controller: scrollController, slivers: [
                if(!ResponsiveHelper.isDesktop(context)) SliverAppBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  expandedHeight: 200,
                  collapsedHeight: 200,
                  pinned: true, floating: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                      child: WalletCardWidget(),
                    ),
                  ),
                ),

               if(!ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault).copyWith(bottom: Dimensions.paddingSizeDefault),
                  child: _WalletTitleView(entryList: entryList),
                )),

              if(!ResponsiveHelper.isDesktop(context)) SliverToBoxAdapter(child: Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      return _isLoggedIn ? profileProvider.userInfoModel != null ? const SizedBox(width: Dimensions.webScreenWidth, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BonusSliderWidget(),

                          WalletHistoryListWidget(),
                        ],
                      )) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)) : const NotLoggedInWidget();
                    }
                )),

              if(ResponsiveHelper.isDesktop(context))  SliverToBoxAdapter(child: Center(child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Expanded(flex: 1, child: CustomShadowWidget(
                    margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      SizedBox(height: Dimensions.paddingSizeDefault),

                      WalletCardWidget(),
                      SizedBox(height: Dimensions.paddingSizeDefault),

                      WalletUsesManualWidget(),
                    ]),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(flex: 2, child: CustomShadowWidget(
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      const WebBonusView(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: _WalletTitleView(entryList: entryList),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      const WalletHistoryListWidget()




                    ]),
                  )),
                ]),
              ))),

              const FooterWebWidget(footerType: FooterType.sliver),

            ]) : NoDataWidget(title: getTranslated('not_found', context)) : const NotLoggedInWidget(),
          );
        }),
      ),
    );
  }
}


class _WalletTitleView extends StatelessWidget {
  const _WalletTitleView({
    Key? key,
    required this.entryList,
  }) : super(key: key);

  final List<PopupMenuEntry> entryList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getTranslated('wallet_history', context), style: poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

        Consumer<WalletAndLoyaltyProvider>(builder: (context, walletProvider, _) {
          return PopupMenuButton<dynamic>(
              offset: const Offset(-20, 20),
              itemBuilder: (BuildContext context) => entryList,
              onSelected: (dynamic value) {
                walletProvider.setWalletFilerType(walletProvider.walletFilterList[value].value!);
                walletProvider.getLoyaltyTransactionList('1', false, true);
              },
              padding: const EdgeInsets.symmetric(horizontal: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSizeDefault)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                ),
                child: Icon(Icons.short_text, color: Theme.of(context).textTheme.displayLarge?.color),
              ),
            );
        }),
      ]),
    );
  }
}


class TabButtonModel{
  final String? buttonText;
  final String buttonIcon;
  final Function onTap;

  TabButtonModel(this.buttonText, this.buttonIcon, this.onTap);


}






