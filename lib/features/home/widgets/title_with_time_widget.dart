import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


class TitleWithTimeWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final Duration? eventDuration;
  final bool? isDetailsPage;
  const TitleWithTimeWidget({Key? key, required this.title, this.onTap, this.eventDuration, this.isDetailsPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFlashDealScreen = ModalRoute.of(context)!.settings.name == RouteHelper.getHomeItemRoute(ProductType.flashSale);
    int? days, hours, minutes, seconds;
    if (eventDuration != null) {
      days = eventDuration!.inDays;
      hours = eventDuration!.inHours - days * 24;
      minutes = eventDuration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 15,vertical: 12) : const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault,
      ),
      child: Consumer<FlashDealProvider>(
        builder: (context, flashDealProvider, _) {
          return flashDealProvider.flashDealModel != null ? ResponsiveHelper.isDesktop(context) && !isDetailsPage! ? Column(children: [

            const CustomAssetImageWidget(Images.flashSale, width: 195, height: 140),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            if(eventDuration != null && !isFlashDealScreen)
              Row(children: [
                  const SizedBox(width: 5),
                  TimerBox(time: days, day: 'day'.tr),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  TimerBox(time: hours, day: 'hour'.tr),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  TimerBox(time: minutes, day: 'min'.tr),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  TimerBox(time: seconds, day: 'sec'.tr),
                ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            onTap != null ? InkWell(
              onTap: onTap as void Function()?,
              child: Row(children: [
                Text(
                  'view_all'.tr,
                  style: ResponsiveHelper.isDesktop(context)
                      ?  poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor.withOpacity(0.8)),
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).primaryColor,
                    size: ResponsiveHelper.isDesktop(context) ? 20 : 15,
                  ),
                ),
              ]),
            ) : const SizedBox.shrink(),

            if(isFlashDealScreen && eventDuration != null)
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const SizedBox(width: 5),
                TimerBox(time: days, day: 'day'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: hours, day: 'hour'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: minutes, day: 'min'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: seconds, day: 'sec'.tr),
              ]),
          ]) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            CustomAssetImageWidget(Images.flashSale, width: isDetailsPage! && ResponsiveHelper.isDesktop(context) ? 130 : 60, height: isDetailsPage! && ResponsiveHelper.isDesktop(context) ? 90 : 70),
            const SizedBox(width: Dimensions.paddingSizeLarge),

            if(eventDuration != null && !isFlashDealScreen)
              Row(children: [
                const SizedBox(width: 5),
                TimerBox(time: days, day: 'day'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: hours, day: 'hour'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: minutes, day: 'min'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: seconds, day: 'sec'.tr),
              ]),

            if(isFlashDealScreen && eventDuration != null)
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const SizedBox(width: 5),
                TimerBox(time: days, day: 'day'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: hours, day: 'hour'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: minutes, day: 'min'.tr),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                TimerBox(time: seconds, day: 'sec'.tr),
              ]),

          ]) : Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Column(children: [


              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(height: 40, width: 80, color: Theme.of(context).shadowColor),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Container(
                  height: 50,  color: Theme.of(context).shadowColor.withOpacity(0.2),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(width: 50),

                    Container(
                      height: 40, width: 40,
                      decoration:  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Container(
                      height: 40, width: 40,
                      decoration:  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                    ),

                  ]),
                ),
              ]),
              const SizedBox(height: 10),
            ]),
          );
        }
      )
    );
  }
}

class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;
  final String? day;

  const TimerBox({Key? key, required this.time, this.isBorder = false, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: ResponsiveHelper.isDesktop(context) ? 40 : MediaQuery.of(context).size.width / 9.5,
        height: ResponsiveHelper.isDesktop(context) ? 40 : MediaQuery.of(context).size.width/9.5,
        decoration: BoxDecoration(
          color: isBorder ? null : Theme.of(context).primaryColor,
          border: isBorder ? Border.all(width: 2, color: Theme.of(context).primaryColor) : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(time! < 10 ? '0$time' : time.toString(),
                style: poppinsRegular.copyWith(
                  color: isBorder ? Theme.of(context).primaryColor : Colors.white,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
      ),

      Text(day!, style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),

    ]);
  }
}
