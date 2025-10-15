import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

import 'partial_pay_dialog_widget.dart';

class PartialPayWidget extends StatelessWidget {
  final double totalPrice;
  const PartialPayWidget({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);


    return Consumer<OrderProvider>(builder: (ctx, orderProvider, _) {

      bool isPartialPayment = CheckOutHelper.isPartialPayment(
        configModel: splashProvider.configModel!,
        isLogin: authProvider.isLoggedIn(),
        userInfoModel:profileProvider.userInfoModel,
      );

      bool isSelected = CheckOutHelper.isPartialPaymentSelected(
        paymentMethodIndex: orderProvider.paymentMethodIndex,
        selectedPaymentMethod: orderProvider.selectedPaymentMethod,
      );

      return isPartialPayment ? Stack(
        children: [

          if(!ResponsiveHelper.isDesktop(context)) Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Opacity(
                  opacity: 0.1, child: Image.asset(Images.walletPayment, width: 80),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.01),
              border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
              borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image.asset(Images.walletBackground, height: 30, width: 30),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text(
                      PriceConverterHelper.convertPrice(
                        context, (orderProvider.partialAmount != null || isSelected)
                          && totalPrice < profileProvider.userInfoModel!.walletBalance!
                          ? totalPrice : profileProvider.userInfoModel!.walletBalance!,
                      ),
                      style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      orderProvider.partialAmount != null || isSelected
                          ? getTranslated('has_paid_by_your_wallet', context)
                          : getTranslated('your_have_balance_in_your_wallet', context),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ])),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                orderProvider.partialAmount != null || isSelected ? Row(children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    getTranslated('applied', context),
                    style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                  )
                ]) : Flexible(
                  child: Text(
                    getTranslated('do_you_want_to_use_now', context),
                    style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),
                  ),
                ),

                Consumer<LocationProvider>(
                  builder: (context, locationProvider, _) {
                    return InkWell(
                      onTap: (){
                        ScaffoldMessenger.of(context).clearSnackBars();

                        if(orderProvider.partialAmount != null || isSelected){
                          orderProvider.changePartialPayment();
                          orderProvider.savePaymentMethod(index: null, method: null);
                        }else{
                          showDialog(context: context, builder: (ctx)=> PartialPayDialogWidget(
                            isPartialPay: profileProvider.userInfoModel!.walletBalance! < totalPrice,
                            totalPrice: totalPrice,
                          ));
                        }
                      },
                      child: locationProvider.addressList == null && orderProvider.isDistanceLoading ? const SizedBox() : Container(
                        decoration: BoxDecoration(
                          color: orderProvider.partialAmount != null || isSelected ? Theme.of(context).cardColor : Theme.of(context).primaryColor,
                          border: Border.all(color: orderProvider.partialAmount != null || isSelected ? Colors.red : Theme.of(context).primaryColor, width: 0.5),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          orderProvider.partialAmount != null || isSelected ? getTranslated('remove', context): getTranslated('use', context),
                          style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: orderProvider.partialAmount != null || isSelected ? Colors.red : Colors.white),
                        ),
                      ),
                    );
                  }
                ),

              ]),

              isSelected ? Text(
                '${getTranslated('remaining_wallet_balance', context)}: ${PriceConverterHelper.convertPrice(context, profileProvider.userInfoModel!.walletBalance! - totalPrice)}',
                style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ) : const SizedBox(),

            ]),
          ),


        ],
      ) : const SizedBox();
    }
    );

  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();


    // Path number 1


    paint.color = Color(0xffffffff).withOpacity(0);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    canvas.drawPath(path, paint);


    // Path number 2


    paint.color = Color(0xffff5252).withOpacity(1);
    path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(size.width * 0.09, size.height * 0.93, size.width * 0.11, size.height * 0.78, size.width * 0.11, size.height * 0.66);
    path.cubicTo(size.width * 0.11, size.height * 0.49, size.width * 0.16, size.height * 0.37, size.width / 4, size.height * 0.28);
    path.cubicTo(size.width * 0.36, size.height * 0.23, size.width * 0.54, size.height * 0.18, size.width * 0.68, size.height * 0.16);
    path.cubicTo(size.width * 0.81, size.height * 0.13, size.width * 0.89, size.height * 0.07, size.width * 0.98, 0);
    path.cubicTo(size.width * 0.94, 0, size.width * 0.86, 0, size.width * 0.84, 0);
    path.cubicTo(size.width * 0.56, 0, size.width * 0.28, 0, 0, 0);
    path.cubicTo(0, 0, 0, size.height, 0, size.height);
    canvas.drawPath(path, paint);


    // Path number 3


    paint.color = Color(0xffffab40).withOpacity(1);
    path = Path();
    path.lineTo(size.width, size.height / 5);
    path.cubicTo(size.width, size.height / 5, size.width * 0.94, size.height * 0.88, size.width * 0.65, size.height * 0.93);
    path.cubicTo(size.width * 0.36, size.height * 0.97, size.width / 5, size.height, size.width / 5, size.height);
    path.cubicTo(size.width / 5, size.height, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, size.width, size.height / 5, size.width, size.height / 5);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
