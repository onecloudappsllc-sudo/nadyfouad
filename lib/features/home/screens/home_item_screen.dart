import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/paginated_list_widget.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/product_widget.dart';
import 'package:flutter_grocery/features/home/widgets/title_with_time_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

class HomeItemScreen extends StatefulWidget {
  final String? productType;

  const HomeItemScreen({Key? key, this.productType}) : super(key: key);

  @override
  State<HomeItemScreen> createState() => _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  late int pageSize;
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {

    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.sizeOf(context);
    final double imageWidth = ResponsiveHelper.isDesktop(context) ? Dimensions.webScreenWidth : screenSize.width;


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context) ? const PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: WebAppBarWidget())
          : CustomAppBarWidget(title:  getTranslated(widget.productType, context),
      )) as PreferredSizeWidget?,
      body: Center(child: CustomScrollView(controller: scrollController, slivers: [
        SliverToBoxAdapter(child: Column(children: [
          ResponsiveHelper.isDesktop(context) ? const SizedBox(height: 20) : const SizedBox.shrink(),

          if(ResponsiveHelper.isDesktop(context) && widget.productType != ProductType.flashSale)
            SizedBox(width: Dimensions.webScreenWidth,child: TitleWidget(
              title:  getTranslated('${widget.productType}', context),
            )),

          if(widget.productType == ProductType.flashSale)
            SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
              Consumer<FlashDealProvider>(builder: (context, flashDealProvider, _) {
                return flashDealProvider.flashDealModel != null ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                    child: CustomImageWidget(
                      width: imageWidth,
                      height: imageWidth / 3,
                      image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.flashSaleImageUrl}'
                          '/${flashDealProvider.flashDealModel?.flashDeal?.banner ?? ''}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ) : const SizedBox();
              }),

              Consumer<FlashDealProvider>(builder: (context, flashDealProvider, _) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: TitleWithTimeWidget(
                    isDetailsPage: true,
                    title: getTranslated('flash_deal', context),
                    eventDuration: flashDealProvider.duration,
                  ),
                );
              }
              ),
            ])),

          SizedBox(width: Dimensions.webScreenWidth, child: Consumer<FlashDealProvider>(
              builder: (context, flashDealProvider, child) {
                return Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {

                    ProductModel? productModel;

                    switch(widget.productType) {

                      case ProductType.dailyItem :
                        productModel = productProvider.dailyProductModel;
                        break;

                      case ProductType.featuredItem :
                        productModel = productProvider.featuredProductModel;
                        break;

                      case ProductType.mostReviewed :
                        productModel = productProvider.mostViewedProductModel;
                        break;

                      case ProductType.flashSale :
                        productModel = flashDealProvider.flashDealModel;
                        break;
                    }

                    return productModel == null ? CustomLoaderWidget(
                      color: Theme.of(context).primaryColor,
                    ) : (productModel.products?.isNotEmpty ?? false) ? PaginatedListWidget(
                      totalSize: productModel.totalSize,
                      offset: productModel.offset,
                      limit: productModel.limit,
                      onPaginate: (int? offset) async {
                        if(widget.productType == ProductType.flashSale) {
                          await flashDealProvider.getFlashDealProducts(offset ?? 1);

                        }else {
                          await productProvider.getItemList(offset ?? 1, productType:  widget.productType);

                        }
                      },
                      scrollController: scrollController,
                      itemView: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                          childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : (1/1.6),
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 2,
                        ),

                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productModel.products?.length,
                        itemBuilder: (context ,index) {
                          return ProductWidget(product: productModel!.products![index], isGrid: true, isCenter: true);
                        },
                      ),
                    ) :  NoDataWidget(title: getTranslated('product_not_found', context));
                  },
                );
              }
          )),
        ])),

        const FooterWebWidget(footerType: FooterType.sliver),
      ])),
    );
  }
}
