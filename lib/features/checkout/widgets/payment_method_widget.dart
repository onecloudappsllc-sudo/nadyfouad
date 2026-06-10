import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:provider/provider.dart';

class PaymentMethodWidget extends StatelessWidget {
  final Function(int index) onTap;
  final List<PaymentMethod> paymentList;
  const PaymentMethodWidget({
    Key? key, required this.onTap, required this.paymentList,
  }) : super(key: key);

  Widget _buildPaymentBadges() {
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFF1A1F71), borderRadius: BorderRadius.circular(5)),
        child: const Text('VISA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
      ),
      const SizedBox(width: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFF252525), borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: 18, height: 10,
          child: Stack(children: [
            Positioned(left: 0, child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEB001B)))),
            Positioned(left: 6, child: Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF79E1B)))),
          ]),
        ),
      ),
      const SizedBox(width: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
        child: const Text(' Pay', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      const SizedBox(width: 5),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFFE0E0E0))),
        child: const Text('G Pay', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF3C4043))),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return SingleChildScrollView(child: ListView.builder(
      itemCount: paymentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        bool isSelected = paymentList[index] == orderProvider.paymentMethod;
        bool isOffline = paymentList[index].type == 'offline';
        bool isGeidea = paymentList[index].getWayTitle == 'Visa / Master Online';

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.06) : Theme.of(context).cardColor,
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).dividerColor.withOpacity(0.4),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isGeidea ? const Color(0xFFE8F0FF) : isSelected ? Theme.of(context).primaryColor.withOpacity(0.12) : Theme.of(context).hintColor.withOpacity(0.08),
                    ),
                    child: Center(
                      child: isOffline
                          ? Image.asset(Images.offlinePayment, height: 28, fit: BoxFit.contain)
                          : isGeidea
                              ? Image.asset(Images.visaMaster, height: 28, fit: BoxFit.contain)
                              : CustomImageWidget(
                                  height: 28, fit: BoxFit.contain,
                                  image: '${splashProvider.configModel?.baseUrls?.getWayImageUrl}/${paymentList[index].getWayImage}',
                                ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      isOffline ? getTranslated('pay_offline', context) : paymentList[index].getWayTitle ?? '',
                      style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                    if(isGeidea) ...[
                      const SizedBox(height: 8),
                      _buildPaymentBadges(),
                    ],
                  ])),
                  isSelected
                      ? Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        )
                      : Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).dividerColor, width: 1.5)),
                        ),
                ]),

                if(isGeidea) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.06), borderRadius: BorderRadius.circular(10)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.info_outline, size: 14, color: Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Expanded(child: Text(
                        'في حال إلغاء الطلب أو إرجاع المنتجات، يتم إرجاع المبلغ إلى محفظتك في التطبيق ويمكن استخدامه في طلب آخر.',
                        style: poppinsRegular.copyWith(fontSize: 11, color: Colors.blue.shade700),
                        textDirection: TextDirection.rtl,
                      )),
                    ]),
                  ),
                ],

                if(isOffline && isSelected && splashProvider.offlinePaymentModelList != null)
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                    scrollDirection: Axis.horizontal,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: splashProvider.offlinePaymentModelList!.map((offlineMethod) => InkWell(
                      onTap: () {
                        orderProvider.changePaymentMethod(offlinePaymentModel: offlineMethod);
                        orderProvider.setOfflineSelectedValue(null);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(orderProvider.selectedOfflineMethod?.id == offlineMethod?.id ? 0.9 : 0.1)),
                          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                        ),
                        child: Text(offlineMethod?.methodName ?? ''),
                      ),
                    )).toList()),
                  ),

                if(isOffline && orderProvider.selectedOfflineValue != null && isSelected)
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Text(getTranslated('payment_info', context), style: poppinsMedium),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Column(children: orderProvider.selectedOfflineValue!.map((method) => Row(children: [
                      Text(method.keys.single, style: poppinsRegular),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(' :  ${method.values.single}', style: poppinsRegular),
                    ])).toList()),
                  ]),
              ]),
            ),
          ),
        );
      },
    ));
  }
}