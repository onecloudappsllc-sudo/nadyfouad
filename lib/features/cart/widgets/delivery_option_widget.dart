import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryOptionWidget extends StatelessWidget {
  final String value;
  final String? title;
  const DeliveryOptionWidget({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String? value) => order.setOrderType(value),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Text(title!, style: order.orderType == value ? poppinsSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)
                  : poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(width: 5),
            ],
          ),
        );
      },
    );
  }
}
