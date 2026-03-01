import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool isCenter;
  final bool isElevation;
  final bool fromCategory;
  final Widget? actionView;

  const CustomAppBarWidget({
    super.key, required this.title, this.isBackButtonExist = true, this.onBackPressed,
    this.isCenter = true, this.isElevation = false,this.fromCategory = false, this.actionView,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context,listen: false);

    return AppBar(
      title: Text(title!, style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: isCenter?true:false,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).textTheme.bodyLarge!.color),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: isElevation ? 2 : 0,
      actions: [
        fromCategory ? PopupMenuButton(
            elevation: 20,
            enabled: true,
            icon: Icon(Icons.more_vert,color: Theme.of(context).textTheme.bodyLarge!.color),
            onSelected: (String? value) {
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
        ) : const SizedBox(),

        actionView != null ? actionView! : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
