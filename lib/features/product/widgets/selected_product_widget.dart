import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SelectedImageWidget extends StatelessWidget {
  final Product? productModel;

  const SelectedImageWidget({Key? key, this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<ProductProvider>(builder: (context, productProvider, child) {
      return ListView.builder(
          itemCount: productProvider.product?.image?.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: InkWell(
                onTap: () {
                  cartProvider.onSelectProductStatus(index, true);
                },
                child: Container(
                  padding: EdgeInsets.all(cartProvider.productSelect == index ? 3 : 2),
                  width: ResponsiveHelper.isDesktop(context) ? 70 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                    border: Border.all(
                      color: cartProvider.productSelect == index
                          ? Theme.of(context).primaryColor
                          : ColorResources.getGreyColor(context),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                    child: CustomImageWidget(image: '${splashProvider.baseUrls?.productImageUrl}/${productProvider.product?.image?[index]}',
                      width: ResponsiveHelper.isDesktop(context) ? 70 : 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          });
    });

  }



}
