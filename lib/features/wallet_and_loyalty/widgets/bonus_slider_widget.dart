import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/domain/models/wallet_bonus_model.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_single_child_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BonusSliderWidget extends StatefulWidget {
  const BonusSliderWidget({Key? key}) : super(key: key);

  @override
  State<BonusSliderWidget> createState() => _BonusSliderWidgetState();
}

class _BonusSliderWidgetState extends State<BonusSliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final bool isAddFundActive = Provider.of<SplashProvider>(context, listen: false).configModel!.isAddFundToWallet!;

    return isAddFundActive ? Consumer<WalletAndLoyaltyProvider>(builder: (context, walletProvider, _) {
      
      return Column(mainAxisSize: MainAxisSize.min, children: [
        if(walletProvider.walletBonusList != null && walletProvider.walletBonusList!.isNotEmpty) CarouselSlider.builder(
          itemCount: walletProvider.walletBonusList?.length,
          options: CarouselOptions(
              aspectRatio:   2.9,
              // enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          itemBuilder: (ctx, index, realIdx) => BonusItemView(
            walletBonusModel: walletProvider.walletBonusList![index],
          ),
        ),

        if(walletProvider.walletBonusList != null) Row(mainAxisAlignment: MainAxisAlignment.center, children: walletProvider.walletBonusList!.map((b) {
          int index = walletProvider.walletBonusList!.indexOf(b);
          return Container(
            width: 8.0, height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Theme.of(context).primaryColor : Colors.black12,
            ),
          );
        }).toList()),
      ]);
    }) : const SizedBox();
  }
}

class WebBonusView extends StatelessWidget{
  const WebBonusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAddFundActive = Provider.of<SplashProvider>(context, listen: false).configModel!.isAddFundToWallet!;
    return  isAddFundActive ?  Consumer<WalletAndLoyaltyProvider>(builder: (context, walletProvider, _) {

      return CustomSingleChildListWidget(
        itemCount: walletProvider.walletBonusList == null ? 3 : walletProvider.walletBonusList!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (index)=> walletProvider.walletBonusList == null ? const WebBonusShimmer() : BonusItemView(
          walletBonusModel: walletProvider.walletBonusList![index],
        ),
      );
    }) : const SizedBox();
  }

}


class BonusItemView extends StatelessWidget {
  final WalletBonusModel walletBonusModel;
  const BonusItemView({Key? key, required this.walletBonusModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.isDesktop(context) ? 150 : 120,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
        image: const DecorationImage(
          image: AssetImage(Images.walletBanner), fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
      width: ResponsiveHelper.isDesktop(context) ? 400 : double.maxFinite,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

        Text(walletBonusModel.title ?? '', style: poppinsMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.fontSizeLarge,
        ), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        if(walletBonusModel.endDate != null)
          Text('${getTranslated('valid_till', context)} ${DateConverterHelper.estimatedDate(walletBonusModel.endDate!)}', style: poppinsRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
        )),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Flexible(child: Text(walletBonusModel.minimumAddAmount != null && walletBonusModel.minimumAddAmount! > 0
              ? '${getTranslated('add_minimum', context)} ${PriceConverterHelper.convertPrice(context, walletBonusModel.minimumAddAmount)} ${getTranslated('and_enjoy_bonus', context)} '
              '${
              walletBonusModel.bonusType == 'percentage'
                  ? '${walletBonusModel.bonusAmount} %'
                  : PriceConverterHelper.convertPrice(context, walletBonusModel.bonusAmount)}'
              :  '${getTranslated('add_fund_to_wallet_add_enjoy', context)} ${
              walletBonusModel.bonusType == 'percentage'
                  ? '${walletBonusModel.bonusAmount} %'
                  : PriceConverterHelper.convertPrice(context, walletBonusModel.bonusAmount)} ${getTranslated('more', context)}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: poppinsRegular.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeSmall,
              ))),
      ]),
    );
  }
}


class WebBonusShimmer extends StatelessWidget {
  const WebBonusShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.isDesktop(context) ? 35 : Dimensions.paddingSizeSmall,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4)),
          image: const DecorationImage(
            image: AssetImage(Images.walletBanner), fit: BoxFit.contain,
            alignment: Alignment.centerRight,
          ),
        ),
        width: ResponsiveHelper.isMobile() ? double.maxFinite : 400 ,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Container(height: 10, width: 120, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),


          Container(height: 10, width: 50, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Container(height: 10, width: 80, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),

        ]),
      ),
    );
  }
}




