import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/providers/localization_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/home/providers/banner_provider.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/features/home/widgets/all_product_list_widget.dart';
import 'package:flutter_grocery/features/home/widgets/banners_widget.dart';
import 'package:flutter_grocery/features/home/widgets/category_web_widget.dart';
import 'package:flutter_grocery/features/home/widgets/flash_deal_home_card_widget.dart';
import 'package:flutter_grocery/features/home/widgets/home_item_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, BuildContext context, {bool fromLanguage = false}) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final flashDealProvider = Provider.of<FlashDealProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final withLListProvider = Provider.of<WishListProvider>(context, listen: false);
    final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    ConfigModel? config = Provider.of<SplashProvider>(context, listen: false).configModel;
    if(reload) {
      Provider.of<SplashProvider>(context, listen: false).initConfig();
      Provider.of<SplashProvider>(context, listen: false).getDeliveryInfo();
    }
    if(fromLanguage && (authProvider.isLoggedIn() || (config?.isGuestCheckout ?? false) )) {
      localizationProvider.changeLanguage();
    }
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, reload);

    Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);



    if(productProvider.dailyProductModel == null) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.dailyItem);

    }

    if(productProvider.featuredProductModel == null) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.featuredItem);

    }

    if(productProvider.mostViewedProductModel == null) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.mostReviewed);

    }

    productProvider.getAllProductList(1, reload, isUpdate: false);

    if(authProvider.isLoggedIn()) {
       withLListProvider.getWishListProduct();
    }

    if((config?.flashDealProductStatus ?? false) && flashDealProvider.flashDealModel == null) {
       flashDealProvider.getFlashDealProducts(1, isUpdate: false);
    }

  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<SplashProvider>(builder: (context, splashProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await HomeScreen.loadData(true, context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Scaffold(
            appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())  : null,
            body: CustomScrollView(controller: scrollController, slivers: [
              SliverToBoxAdapter(child: Center(child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Column(children: [

                  Consumer<BannerProvider>(builder: (context, banner, child) {
                    return (banner.bannerList?.isEmpty ?? false) ? const SizedBox() : const BannersWidget();
                  }),


                  /// Category
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall,
                    ),
                    child: const CategoryWidget(),
                  ),


                  /// Flash Deal
                  if(splashProvider.configModel?.flashDealProductStatus ?? false)const FlashDealHomeCardWidget(),


                  Consumer<ProductProvider>(builder: (context, productProvider, child) {
                    bool isDalyProduct = (productProvider.dailyProductModel == null || (productProvider.dailyProductModel?.products?.isNotEmpty ?? false));
                    bool isFeaturedProduct = (productProvider.featuredProductModel == null || ( productProvider.featuredProductModel?.products?.isNotEmpty ?? false));
                    bool isMostViewedProduct = (productProvider.mostViewedProductModel == null || (productProvider.mostViewedProductModel?.products?.isNotEmpty ?? false));

                    return Column(children: [
                      isDalyProduct ?  Column(children: [
                        TitleWidget(title: getTranslated('daily_needs', context) ,onTap: () {
                          Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.dailyItem));
                        }),

                        HomeItemWidget(productList: productProvider.dailyProductModel?.products),

                      ]) : const SizedBox(),

                      if((splashProvider.configModel?.featuredProductStatus ?? false) && isFeaturedProduct) Column(children: [
                        TitleWidget(title: getTranslated(ProductType.featuredItem, context) ,onTap: () {
                          Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.featuredItem));
                        }),

                        HomeItemWidget(productList: productProvider.featuredProductModel?.products, isFeaturedItem: true),
                      ]),


                      if((splashProvider.configModel?.mostReviewedProductStatus ?? false) && isMostViewedProduct) Column(children: [
                        TitleWidget(title: getTranslated(ProductType.mostReviewed, context) ,onTap: () {
                          Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.mostReviewed));
                        }),

                        HomeItemWidget(productList: productProvider.mostViewedProductModel?.products),

                      ])
                    ]);
                  }),


                  ResponsiveHelper.isMobilePhone() ? const SizedBox(height: 10) : const SizedBox.shrink(),

                  AllProductListWidget(scrollController: scrollController),


                ]),
              ))),

              if(ResponsiveHelper.isWeb())...[
                const FooterWebWidget(footerType: FooterType.sliver)
              ],



            ]),
          ),
        );
      }
    );
  }
}


