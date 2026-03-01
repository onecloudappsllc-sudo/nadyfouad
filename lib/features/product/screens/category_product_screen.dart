
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/product_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/web_product_shimmer_widget.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/product/widgets/category_cart_title_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryId;
  final String? subCategoryName;
  const
  CategoryProductScreen({Key? key,required this.categoryId, this.subCategoryName}) : super(key: key);

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {

  void _loadData(BuildContext context) async {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    if (categoryProvider.selectedCategoryIndex == -1) {

      categoryProvider.getCategory(int.tryParse(widget.categoryId), context);

      categoryProvider.getSubCategoryList(context, widget.categoryId);

      categoryProvider.initCategoryProductList(widget.categoryId);
    }
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    String? appBarText = 'Sub Categories';
    if(widget.subCategoryName != null && widget.subCategoryName != 'null') {
      appBarText = widget.subCategoryName;
    }else{
      appBarText =  categoryProvider.categoryModel?.name ?? 'name';
    }
    categoryProvider.initializeAllSortBy(context);

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : CustomAppBarWidget(
        title: appBarText,
        isCenter: false, isElevation: true,fromCategory: true,
      )) as PreferredSizeWidget?,
      body: Consumer<CategoryProvider>(
          builder: (context, productProvider, child) {
            return Column(
              crossAxisAlignment: ResponsiveHelper.isDesktop(context)? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70,width: Dimensions.webScreenWidth, child: Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child){
                      return categoryProvider.subCategoryList != null ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        height: 32,
                        child: SizedBox(
                          width: ResponsiveHelper.isDesktop(context)? 1170 : MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                                    child: InkWell(
                                      onTap: (){
                                        categoryProvider.onChangeSelectIndex(-1);
                                        productProvider.initCategoryProductList(widget.categoryId);
                                      },
                                      hoverColor: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                            color: categoryProvider.selectedCategoryIndex == -1 ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                            borderRadius: BorderRadius.circular(7)),
                                        child: Text(
                                          getTranslated('all', context),
                                          style: poppinsRegular.copyWith(
                                            color: categoryProvider.selectedCategoryIndex == -1 ? Theme.of(context).canvasColor : Colors.black ,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: categoryProvider.subCategoryList!.length ,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index){
                                        return InkWell(
                                          onTap: (){
                                            categoryProvider.onChangeSelectIndex(index);

                                            productProvider.initCategoryProductList('${categoryProvider.subCategoryList![index].id}');

                                          },
                                          hoverColor: Colors.transparent,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                                color: categoryProvider.selectedCategoryIndex == index ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                                                borderRadius: BorderRadius.circular(7)),
                                            child: Text(
                                              categoryProvider.subCategoryList?[index].name ?? '',
                                              style: poppinsRegular.copyWith(
                                                color:  categoryProvider.selectedCategoryIndex == index ? Theme.of(context).canvasColor : Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ])),
                              ),
                              // if(ResponsiveHelper.isDesktop(context)) Spacer(),
                              if(ResponsiveHelper.isDesktop(context)) PopupMenuButton(
                                  elevation: 20,
                                  enabled: true,
                                  icon: Icon(Icons.more_vert,color: Theme.of(context).textTheme.bodyLarge?.color),
                                  onSelected: (dynamic value) {
                                    int index = categoryProvider.allSortBy.indexOf(value);

                                    categoryProvider.sortCategoryProduct(index);
                                  },

                                  itemBuilder:(context) {
                                    return categoryProvider.allSortBy.map((choice) {
                                      return PopupMenuItem(
                                        value: choice,
                                        child: Text(getTranslated(choice, context)),
                                      );
                                    }).toList();
                                  }
                              )
                            ],
                          ),
                        ),
                      ) : const _SubcategoryTitleShimmer();
                    }),),

                Expanded(child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(child: productProvider.subCategoryProductList.isNotEmpty ? Center(
                    child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
                          childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : (1/1.8),
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : 2,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeSmall),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productProvider.subCategoryProductList.length,
                        shrinkWrap: true,

                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(product: productProvider.subCategoryProductList[index], isCenter: true, isGrid: true);
                        },

                      ),
                    ),
                  ) : Center(child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: (productProvider.hasData ?? false) ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: _ProductShimmer(isEnabled: true),
                    ) : NoDataWidget(isFooter: false, title: getTranslated('not_product_found', context)),

                  ))),


                  const FooterWebWidget(footerType: FooterType.sliver),
                ])),

                const CategoryCartTitleWidget(),

              ],
            );
          }
      ),
    );
  }
}



class _SubcategoryTitleShimmer extends StatelessWidget{
  const _SubcategoryTitleShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: 20),
        itemCount: 5 ,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                    color:  Theme.of(context).textTheme.titleLarge!.color,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 20, width: 60,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.getGreyColor(context),
                  ),
                ),
              ),
            ),
          );
        });
  }
}


class _ProductShimmer extends StatelessWidget {
  final bool isEnabled;

  const _ProductShimmer({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 10,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1/1.4) : (1/1.6),
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 2 : 2,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => const WebProductShimmerWidget(isEnabled: true),
      itemCount: 20,
    );
  }
}
