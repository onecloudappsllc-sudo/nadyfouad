import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_zoom_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/wish_button_widget.dart';
import 'package:flutter_grocery/features/product/widgets/details_app_bar_widget.dart';
import 'package:flutter_grocery/features/product/widgets/product_description_widget.dart';
import 'package:flutter_grocery/features/product/widgets/product_image_widget.dart';
import 'package:flutter_grocery/features/product/widgets/product_title_widget.dart';
import 'package:flutter_grocery/features/product/widgets/quantity_button_widget.dart';
import 'package:flutter_grocery/features/product/widgets/selected_product_widget.dart';
import 'package:flutter_grocery/features/product/widgets/variation_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/cart_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;
  final bool? fromSearch;
  const ProductDetailsScreen({Key? key, required this.productId, this.fromSearch = false}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>  with TickerProviderStateMixin {
  int _tabIndex = 0;
  bool showSeeMoreButton = true;

  @override
  void initState() {

    Provider.of<ProductProvider>(context, listen: false).getProductDetails('${widget.productId}', searchQuery: widget.fromSearch!);
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).onSelectProductStatus(0, false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())  : DetailsAppBarWidget(key: UniqueKey(), title: 'product_details'.tr),

      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return  Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            double? priceWithQuantity = 0;
            CartModel? cartModel;

            if(productProvider.product != null) {


              cartModel = CartHelper.getCartModel(productProvider.product!, quantity: cartProvider.quantity, variationIndexList: cartProvider.variationIndex);

              cartProvider.setExistData(cartProvider.isExistInCart(cartModel));

              print('price --------> ${cartModel?.price}');

              double? priceWithDiscount = PriceConverterHelper.convertWithDiscount(
                cartModel?.price, productProvider.product?.discount,
                productProvider.product?.discountType,
              );


              if(cartProvider.cartIndex != null) {
                priceWithQuantity = (priceWithDiscount ?? 0) * (cartProvider.cartList[cartProvider.cartIndex!].quantity!);

              }else {
                priceWithQuantity = (priceWithDiscount ?? 0) * cartProvider.quantity;

              }
            }

            return productProvider.product != null ? !ResponsiveHelper.isDesktop(context) ? Column(
              children: [
                Expanded(child: SingleChildScrollView(
                  physics: ResponsiveHelper.isMobilePhone() ? const BouncingScrollPhysics() : null,
                  child: Center(
                    child: SizedBox(
                      width: Dimensions.webScreenWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(children: [
                            ProductImageWidget(productModel: productProvider.product),

                            SizedBox(height: 60, child: productProvider.product?.image != null ? SelectedImageWidget(productModel: productProvider.product) : const SizedBox(),),

                            ProductTitleWidget(product: productProvider.product, stock: cartModel?.stock, cartIndex: cartProvider.cartIndex),

                            VariationWidget(product: productProvider.product),

                            Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children: [

                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  CustomDirectionalityWidget(child: Text(
                                    PriceConverterHelper.convertPrice(context, priceWithQuantity),
                                    style: poppinsBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                    ),
                                  )),
                                ]),

                                Builder(
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).disabledColor.withOpacity(0.07),
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                                        ),

                                        child: Row(children: [
                                          QuantityButtonWidget(
                                            isIncrement: false, quantity: cartProvider.quantity,
                                            stock: cartModel?.stock, cartIndex: cartProvider.cartIndex,
                                            maxOrderQuantity: productProvider.product!.maximumOrderQuantity,
                                          ),
                                          const SizedBox(width: 15),

                                          Text(
                                            cartProvider.cartIndex != null ? cartProvider.cartList[cartProvider.cartIndex!].quantity.toString() : cartProvider.quantity.toString(),
                                            style: poppinsBold.copyWith(color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(width: 15),

                                          QuantityButtonWidget(
                                            isIncrement: true, quantity: cartProvider.quantity,
                                            stock: cartModel?.stock, cartIndex: cartProvider.cartIndex,
                                            maxOrderQuantity: productProvider.product!.maximumOrderQuantity,
                                          ),
                                        ]),
                                      );
                                    }
                                ),

                              ]),
                            ),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ProductDescriptionWidget(
                            showSeeMoreButton: showSeeMoreButton,
                            tabIndex: _tabIndex,
                            onTabChange: (int index) {
                              setState(() {
                                _tabIndex = index;
                              });
                            },
                            onChangeButtonStatus: (bool status) {
                              setState(() {
                                showSeeMoreButton = status;
                              });
                            },
                          )

                        ],
                      ),
                    ),
                  ),
                )),

                Center(child: SizedBox(width: Dimensions.webScreenWidth, child: CustomButtonWidget(
                  icon: Icons.shopping_cart,
                  margin: Dimensions.paddingSizeSmall,
                  buttonText: getTranslated(cartProvider.cartIndex != null ? 'already_added' : (cartModel?.stock ?? 0) <= 0 ? 'out_of_stock' : 'add_to_card', context),
                  onPressed: (cartProvider.cartIndex == null && (cartModel?.stock ?? 0) > 0) ? () {
                    if (cartProvider.cartIndex == null && (cartModel?.stock ?? 0) > 0) {
                      cartProvider.addToCart(cartModel!);


                      showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);

                    } else {
                      showCustomSnackBarHelper(getTranslated('already_added', context));
                    }
                  } : null,
                ))),
              ],
            ) : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Center(
                      child: SizedBox(
                        width: Dimensions.webScreenWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Expanded(flex: 4, child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(height: 350, child: CustomZoomWidget(
                                      image: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                                        child: CustomImageWidget(
                                          image: '${splashProvider.baseUrls?.productImageUrl}/${(productProvider.product?.image?.isNotEmpty ?? false)
                                              ? productProvider.product!.image![cartProvider.productSelect] : ''}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),

                                    Positioned(
                                      top: 10, right: 10,
                                      child: WishButtonWidget(product: productProvider.product, edgeInset: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                SizedBox(height: 70, child: productProvider.product!.image != null ? SelectedImageWidget(productModel: productProvider.product) : const SizedBox(),),
                              ],
                            )),

                            const SizedBox(width: 30),
                            Expanded(flex: 6,child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  ProductTitleWidget(product: productProvider.product, stock: cartModel?.stock, cartIndex: cartProvider.cartIndex),

                                  VariationWidget(product: productProvider.product),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                    Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    CustomDirectionalityWidget(child: Text(
                                      PriceConverterHelper.convertPrice(context, priceWithQuantity),
                                      style: poppinsBold.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeMaxLarge,
                                      ),
                                    )),
                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeDefault),


                                  Row(
                                    children: [

                                      Builder(
                                          builder: (context) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).disabledColor.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                                              ),

                                              child: Row(children: [
                                                QuantityButtonWidget(
                                                  isIncrement: false, quantity: cartProvider.quantity,
                                                  stock: cartModel?.stock, cartIndex: cartProvider.cartIndex,
                                                  maxOrderQuantity: productProvider.product!.maximumOrderQuantity,
                                                ),
                                                const SizedBox(width: 15),

                                                Consumer<CartProvider>(builder: (context, cart, child) {
                                                  return Text(cart.cartIndex != null ? cart.cartList[cart.cartIndex!].quantity.toString()
                                                      : cart.quantity.toString(), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)
                                                  );
                                                }),
                                                const SizedBox(width: 15),

                                                QuantityButtonWidget(
                                                  isIncrement: true, quantity: cartProvider.quantity,
                                                  stock: cartModel?.stock, cartIndex: cartProvider.cartIndex,
                                                  maxOrderQuantity: productProvider.product?.maximumOrderQuantity,
                                                ),
                                              ]),
                                            );
                                          }
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),

                                      Builder(
                                        builder: (context) => Center(
                                          child: SizedBox(
                                            width: 200,
                                            child: CustomButtonWidget(
                                              icon: Icons.shopping_cart,
                                              buttonText: getTranslated(cartProvider.cartIndex != null ? 'already_added' : (cartModel?.stock ?? 0) <= 0 ? 'out_of_stock' : 'add_to_card', context),
                                              onPressed: (cartProvider.cartIndex == null && (cartModel?.stock ?? 0) > 0) ? () {
                                                if (cartProvider.cartIndex == null && (cartModel?.stock ?? 0) > 0) {
                                                  cartProvider.addToCart(cartModel!);

                                                  showCustomSnackBarHelper(getTranslated('added_to_cart', context), isError: false);

                                                } else {
                                                  showCustomSnackBarHelper(getTranslated('already_added', context));
                                                }
                                              } : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                          ],),
                      ),
                    ),
                    //Description
                    const SizedBox(height : Dimensions.paddingSizeExtraLarge),

                    Center(child: SizedBox(width: Dimensions.webScreenWidth, child: ProductDescriptionWidget(
                      showSeeMoreButton: showSeeMoreButton,
                      tabIndex: _tabIndex,
                      onTabChange: (int index) {
                        setState(() {
                          _tabIndex = index;
                        });
                      },
                      onChangeButtonStatus: (bool status) {
                        setState(() {
                          showSeeMoreButton = status;
                        });
                      },
                    ))),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                  ]),
                ),

                const FooterWebWidget(footerType: FooterType.sliver),
              ],
            ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor));
          },
        );
      }),
    );
  }
}







