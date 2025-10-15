import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_button_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_product_list_widget.dart';
import 'package:flutter_grocery/helper/cart_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/common/widgets/app_bar_base_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_details_widget.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    _couponController.clear();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType('delivery', notify: false);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);


    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone() ? null: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : const AppBarBaseWidget()) as PreferredSizeWidget?,
      body: Center(
        child: Consumer<CouponProvider>(builder: (context, couponProvider, _) {
            return Consumer<CartProvider>(
              builder: (context, cart, child) {

                double itemPrice = 0;
                double discount = 0;
                double tax = 0;

                for (var cartModel in cart.cartList) {
                  itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
                  discount = discount + (cartModel.discount! * cartModel.quantity!);
                  tax = tax + (cartModel.tax! * cartModel.quantity!);
                }

                double subTotal = itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
                bool isFreeDelivery = subTotal >= configModel.freeDeliveryOverAmount! && configModel.freeDeliveryStatus! || couponProvider.coupon?.couponType == 'free_delivery';

                double total = subTotal - discount - Provider.of<CouponProvider>(context).discount!;

                double weight = 0.0;
                weight = CartHelper.weightCalculation(cartProvider.cartList);

                return cart.cartList.isNotEmpty
                    ? !ResponsiveHelper.isDesktop(context) ? Column(children: [
                      Expanded(child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          // Product
                            const CartProductListWidget(),
                            //const SizedBox(height: Dimensions.paddingSizeDefault),

                            CartDetailsWidget(
                            couponController: _couponController, total: total,
                            isFreeDelivery: isFreeDelivery,
                            itemPrice: itemPrice, tax: tax,
                            discount: discount),
                            const SizedBox(height: 40),
                          ]),
                        )),
                      )),

                      CartButtonWidget(
                        subTotal: subTotal,
                        configModel: configModel,
                        itemPrice: itemPrice,
                        total: total,
                        isFreeDelivery: isFreeDelivery,
                        discount: discount,
                        tax: tax,
                        weight: weight,
                      ),
                    ])
                    : CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                        child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Expanded(flex: 6, child: Container(
                                 padding: const EdgeInsets.only(
                                   left: Dimensions.paddingSizeLarge,
                                   right: Dimensions.paddingSizeLarge,
                                   top: Dimensions.paddingSizeLarge,
                                   bottom: Dimensions.paddingSizeSmall,
                                 ),
                                 decoration: BoxDecoration(
                                   color: Theme.of(context).cardColor,
                                   borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSizeDefault)),
                                   boxShadow: [
                                     BoxShadow(color: Colors.grey.withOpacity(0.01), spreadRadius: 1, blurRadius: 1),
                                   ],
                                 ),
                                 child: const CartProductListWidget(),
                               )),
                              const SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(flex:4, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                                CartDetailsWidget(
                                  couponController: _couponController,
                                  total: total,
                                  isFreeDelivery: isFreeDelivery,
                                  itemPrice: itemPrice, tax: tax,
                                  discount: discount,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),

                                CartButtonWidget(
                                  subTotal: subTotal,
                                  configModel: configModel,
                                  itemPrice: itemPrice,
                                  total: total,
                                  isFreeDelivery: isFreeDelivery,
                                  discount: discount,
                                  tax: tax,
                                  weight: weight,
                                ),
                              ]))

                            ],
                          ),
                        ))),
                      ),


                     const FooterWebWidget(footerType: FooterType.sliver),

                ]) :  NoDataWidget(image: Images.favouriteNoDataImage, title: getTranslated('empty_shopping_bag', context));
              },
            );
          }
        ),
      ),
    );
  }

}






