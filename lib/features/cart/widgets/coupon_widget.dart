import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget({super.key, required this.couponController, required this.total});

  final TextEditingController couponController;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, couponProvider, child) {
        return DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(Dimensions.radiusSizeDefault),
          color: Theme.of(context).primaryColor,
          strokeWidth: 2,
          dashPattern: const [5, 5],
          child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeExtraSmall),
            child: SizedBox(height: 50, child: Row(children: [

              Image.asset(Images.couponApply, height: 30, width: 30),

              Expanded(child: TextField(
                controller: couponController,
                style: poppinsMedium,
                decoration: InputDecoration(
                  hintText: getTranslated('enter_promo_code', context),
                  hintStyle: poppinsRegular.copyWith(color: Theme.of(context).hintColor),
                  isDense: true,
                  filled: true,
                  enabled: couponProvider.discount == 0,
                  fillColor: Theme.of(context).cardColor,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                ),
              )),

              InkWell(
                onTap: () {
                  if (couponController.text.isNotEmpty && !couponProvider.isLoading) {
                    if (couponProvider.discount! < 1) {
                      couponProvider.applyCoupon(couponController.text, total);
                    } else {
                      couponProvider.removeCouponData(true);
                    }
                  }else {
                    showCustomSnackBarHelper(getTranslated('invalid_code_or_failed', context),isError: true);
                  }
                },
                child: couponProvider.discount! <= 0 ? Container(
                  height: 40, width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSizeTen),),
                  ),
                  child: !couponProvider.isLoading ? Text(
                    getTranslated('apply', context),
                    style: poppinsMedium.copyWith(color: Colors.white),
                  ) : const Center(child: SizedBox(
                    height: Dimensions.paddingSizeExtraLarge, width: Dimensions.paddingSizeExtraLarge,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )),
                ) : Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
              ),
            ],),
            )),
        );
      },
    );
  }
}