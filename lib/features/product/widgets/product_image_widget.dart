import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/wish_button_widget.dart';
import 'package:flutter_grocery/features/product/screens/product_image_screen.dart';
import 'package:provider/provider.dart';

class ProductImageWidget extends StatelessWidget {
  final Product? productModel;
  const ProductImageWidget({Key? key, required this.productModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context,listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              RouteHelper.getProductImagesRoute(productModel!.name, jsonEncode(productModel!.image), '' ?? ''),
              arguments: ProductImageScreen(imageList: productModel!.image, title: productModel!.name, baseUrl: splashProvider.baseUrls?.productImageUrl),
            ),

            child: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: ResponsiveHelper.isDesktop(context) ? 350 : MediaQuery.of(context).size.height * 0.4,
                  child: PageView.builder(
                    itemCount: productModel?.image?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CustomImageWidget(
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productModel!.image![cartProvider.productSelect]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      Provider.of<CartProvider>(context, listen: false).onSelectProductStatus(index, true);
                      Provider.of<ProductProvider>(context, listen: false).setImageSliderSelectedIndex(index);
                    },
                  ),
                );
              }
            ),
          ),

          Positioned(
            top: 26, right: 26,
            child: WishButtonWidget(product: productModel, edgeInset: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall)),
          )

        ]),
      ],
    );
  }

}
