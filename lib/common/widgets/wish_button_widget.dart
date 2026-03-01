import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';


class WishButtonWidget extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;
  const WishButtonWidget({super.key, required this.product, this.edgeInset = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(builder: (context, wishList, child) {
      return Tooltip(
        message: getTranslated('click_to_add_to_your_wish_list', context),
        child: InkWell(
          onTap: () {
            if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              List<int?> productIdList =[];
              productIdList.add(product!.id);
        
              wishList.wishIdList.contains(product!.id) ? wishList.removeFromWishList(product!, context)
                  : wishList.addToWishList(product!,context);
            }else{
              showCustomSnackBarHelper(getTranslated('now_you_are_in_guest_mode', context));
            }
        
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)),
            ),
            child: Padding(
              padding: edgeInset,
              child: Icon(
                wishList.wishIdList.contains(product!.id)
                    ? Icons.favorite : Icons.favorite_border,
                color: wishList.wishIdList.contains(product!.id)
                    ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
                size: Dimensions.paddingSizeLarge,
              ),
            ),
          ),
        ),
      );
    });
  }
}
