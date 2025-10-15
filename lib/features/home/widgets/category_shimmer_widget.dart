import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoriesShimmerWidget extends StatelessWidget {
  const CategoriesShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? (1 / 1.1) : (1 / 1.2),
        crossAxisCount: ResponsiveHelper.isWeb()?6:ResponsiveHelper.isMobilePhone()?3:ResponsiveHelper.isTab(context)?4:3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
            boxShadow: Provider.of<ThemeProvider>(context).darkTheme ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: Provider.of<CategoryProvider>(context).categoryList == null,
            child: Column(children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeLarge),
                  child: Container(color: Colors.grey[300], width: 50, height: 10),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
