import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class PaymentButtonWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final Function onTap;

  const PaymentButtonWidget({
    Key? key, required this.isSelected, required this.icon,
    required this.title, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (ctx, orderController, _) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: onTap as void Function()?,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.06)
                  : Theme.of(context).cardColor,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor.withOpacity(0.4),
                width: isSelected ? 2 : 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.12)
                      : Theme.of(context).hintColor.withOpacity(0.08),
                ),
                child: Center(child: Image.asset(icon, width: 24, height: 24)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(
                title,
                style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              )),
              if(isSelected) Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ) else Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}