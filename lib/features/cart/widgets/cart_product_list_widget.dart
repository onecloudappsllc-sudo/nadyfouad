import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartProductListWidget extends StatelessWidget {
  const CartProductListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cartProvider.cartList.length,
            itemBuilder: (context, index) {
              return CartItemWidget(cart: cartProvider.cartList[index], index: index,);
            },
          );
        }
    );
  }
}
