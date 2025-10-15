import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/product_filter_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/on_hover_widget.dart';
import 'package:flutter_grocery/common/widgets/paginated_list_widget.dart';
import 'package:flutter_grocery/common/widgets/product_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:flutter_grocery/common/widgets/web_product_shimmer_widget.dart';
import 'package:provider/provider.dart';

class AllProductListWidget extends StatefulWidget {
  const AllProductListWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  State<AllProductListWidget> createState() => _AllProductListWidgetState();
}

class _AllProductListWidgetState extends State<AllProductListWidget> {
  ProductFilterType filterType = ProductFilterType.latest;

  @override
  Widget build(BuildContext context) {
    ConfigModel? config = Provider.of<SplashProvider>(context, listen: false).configModel;
    final double screenWeight = MediaQuery.sizeOf(context).width;

    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleWidget(title: getTranslated('all_items', context)),

              PopupMenuButton<ProductFilterType>(
                padding: const EdgeInsets.all(0),
                onSelected: (ProductFilterType result) {
                  filterType = result;
                  productProvider.onChangeProductFilterType(result);
                  productProvider.getAllProductList(1, true);
                },
                itemBuilder: (BuildContext c) => <PopupMenuEntry<ProductFilterType>>[
                  PopupMenuItem<ProductFilterType>(
                    value: ProductFilterType.latest,
                    child: _PopUpItem(title: getTranslated('latest_items', context), type: ProductFilterType.latest),
                  ),

                  PopupMenuItem<ProductFilterType>(
                    value: ProductFilterType.popular,
                    child: _PopUpItem(title: getTranslated('popular_items', context), type: ProductFilterType.popular),
                  ),

                 if(config?.recommendedProductStatus ?? false) PopupMenuItem<ProductFilterType>(
                    value: ProductFilterType.recommended,
                    child: _PopUpItem(title: getTranslated('recommend_items', context), type: ProductFilterType.recommended),
                  ),

                 if(config?.trendingProductStatus ?? false) PopupMenuItem<ProductFilterType>(
                    value: ProductFilterType.trending,
                    child: _PopUpItem(title: getTranslated('trending_items', context), type: ProductFilterType.trending),
                  ),

                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                  margin: EdgeInsets.only(right: ResponsiveHelper.isDesktop(context) ? 0 :Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: Theme.of(context).primaryColor,
                    size: ResponsiveHelper.isDesktop(context) ? 25 : 20,
                  ),
                ),
              ),
            ],
          ),

          PaginatedListWidget(
            onPaginate: (int? offset) async => await productProvider.getAllProductList(offset!, false),
            offset: productProvider.allProductModel?.offset,
            totalSize: productProvider.allProductModel?.totalSize,
            limit: productProvider.allProductModel?.limit,
            scrollController: widget.scrollController,
            itemView: Column(children: [

              (productProvider.allProductModel != null && productProvider.allProductModel != null &&  productProvider.allProductModel!.products!.isEmpty) ?  NoDataWidget(
                isFooter: false, title: getTranslated('not_product_found', context),
              ) : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : ResponsiveHelper.isTab(context) ? ( screenWeight > 860 ? 0.9 : 0.60) : 0.6,
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3  : 2,
                ),
                itemCount: productProvider.allProductModel?.products != null ? productProvider.allProductModel?.products?.length : 10,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall,
                  vertical: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return productProvider.allProductModel?.products != null ?  ProductWidget(
                    product: productProvider.allProductModel!.products![index],
                    isCenter: true, isGrid: true,
                  ) : WebProductShimmerWidget(isEnabled: productProvider.allProductModel == null);
                },
              ),

            ]),
          ),
        ]);
      }
    );
  }
}

class _PopUpItem extends StatelessWidget {
  final String title;
  final ProductFilterType type;
  const _PopUpItem({
    Key? key, required this.title, required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnHoverWidget(child: Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        return Text(title, style: poppinsMedium.copyWith(
          color: type == productProvider.selectedFilterType ? Theme.of(context).primaryColor : null,
          fontSize: type == productProvider.selectedFilterType ? Dimensions.fontSizeLarge : null,
        ));
      }
    ));
  }
}
