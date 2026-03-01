import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SubCategoriesShimmerWidget extends StatelessWidget {
  const SubCategoriesShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).subCategoryList == null,
          child: Container(
            height: 40,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
          ),
        );
      },
    );
  }
}
