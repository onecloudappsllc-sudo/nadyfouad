import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/home/widgets/category_page_widget.dart';
import 'package:flutter_grocery/features/home/widgets/category_shimmer_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  ScrollController scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<CategoryProvider>(builder: (context, categoryProvider, child) {
      return categoryProvider.categoryList == null ? const CategoriesShimmerWidget() : (categoryProvider.categoryList?.isNotEmpty ?? false) ? Column(children: [

        TitleWidget(title: getTranslated('popular_categories', context)),

        ResponsiveHelper.isDesktop(context) ? CategoryWebWidget(scrollController: scrollController) : GridView.builder(
          itemCount: (categoryProvider.categoryList?.length ?? 0) > 7 ? 8 : categoryProvider.categoryList?.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isMobilePhone() ? 4 : ResponsiveHelper.isTab(context) ? 4 :3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            return Center(
              child: InkWell(
                onTap: () {
                  if (index == 7) {
                    ResponsiveHelper.isMobilePhone() ? splashProvider.setPageIndex(1) : const SizedBox();
                    ResponsiveHelper.isWeb() ? Navigator.pushNamed(context, RouteHelper.categories) : const SizedBox();

                  } else {
                    categoryProvider.onChangeSelectIndex(-1,notify: false);
                    Navigator.of(context).pushNamed(
                      RouteHelper.getCategoryProductsRoute(categoryId: '${categoryProvider.categoryList![index].id}'),
                    );
                  }
                },
                child: Column(children: [
                  Expanded(flex: 6, child: Container(
                    margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ),
                    child: index != 7 ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CustomImageWidget(
                          image: '${splashProvider.baseUrls?.categoryImageUrl}/${categoryProvider.categoryList?[index].image}',
                          fit: BoxFit.cover, height: 70, width: 70,
                        ),
                      ),
                    ) : Container(
                      height: 70, width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Text('${(categoryProvider.categoryList?.length ?? 0) - 7}+', style: poppinsRegular.copyWith(color: Theme.of(context).cardColor)),
                    ),
                  )),

                  Expanded(
                    flex: ResponsiveHelper.isDesktop(context) ? 3 : 2,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        index != 7 ? categoryProvider.categoryList![index].name! : getTranslated('view_all', context),
                        style: poppinsRegular,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ]) : const SizedBox();

    });
  }
}

