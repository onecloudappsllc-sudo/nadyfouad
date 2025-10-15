import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/features/home/widgets/home_item_widget.dart';
import 'package:flutter_grocery/features/home/widgets/title_with_time_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class FlashDealHomeCardWidget extends StatelessWidget {
  const FlashDealHomeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(builder: (context, flashDealProvider, child) {
      return (flashDealProvider.flashDealModel?.products?.isEmpty ?? false) || (flashDealProvider.duration?.isNegative ?? false)
          ? const SizedBox() :
      Column(children: [

        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.flashSale)),
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            padding: EdgeInsets.only(
              left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0, top: Dimensions.paddingSizeDefault, bottom: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeSmall,
            ),
            child: ResponsiveHelper.isDesktop(context) ? Row(children: [

              TitleWithTimeWidget(
                isDetailsPage: false,
                title: '',
                eventDuration: flashDealProvider.duration,
                onTap: () => Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.flashSale)),
              ),


              Flexible(child: HomeItemWidget(productList: flashDealProvider.flashDealModel?.products)),


            ]) : Column(children: [

              TitleWithTimeWidget(
                isDetailsPage: false,
                title: '',
                eventDuration: flashDealProvider.duration,
              ),

              HomeItemWidget(productList: flashDealProvider.flashDealModel?.products, isFlashDeal: true),

              InkWell(
                onTap: () => Navigator.pushNamed(context, RouteHelper.getHomeItemRoute(ProductType.flashSale)),
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'view_all'.tr,
                      style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor.withOpacity(0.8)),
                    ),

                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                      size: 15,
                    ),
                  ]),
                ),
              ),

            ]),

          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
      ]);
    });
  }
}
