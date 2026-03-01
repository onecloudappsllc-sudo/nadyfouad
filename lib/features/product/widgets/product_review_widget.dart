import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductReviewWidget extends StatelessWidget {
  final ActiveReview reviewModel;
  const ProductReviewWidget({Key? key, required this.reviewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(child: CustomImageWidget(
            image: '${splashProvider.baseUrls?.customerImageUrl}/${reviewModel.customer?.image ?? ''}',
            height: 50, width: 50, fit: BoxFit.cover,
          )),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Expanded(
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
                Text(
                  reviewModel.customer != null ? '${reviewModel.customer?.fName ?? ''} ${reviewModel.customer?.lName ?? ''}' : getTranslated('user_not_available', context),
                  style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),

                if(reviewModel.createdAt != null) Text(DateConverterHelper.getDateToDateDifference(
                  DateConverterHelper.convertStringToDatetime(reviewModel.createdAt!), context,
                )),


              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(children: [

                const Icon(Icons.star_rounded, color: ColorResources.ratingColor, size: 20),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('${reviewModel.rating}', style: poppinsRegular.copyWith(color: ColorResources.ratingColor)),

              ]),
              SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall),

              Text(reviewModel.comment ?? '', style: poppinsRegular),

            ]),
          ),

        ]),
      ]),
    );
  }
}

class ReviewShimmer extends StatelessWidget {
  const ReviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(height: 30, width: 30, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Container(height: 15, width: 100, color: Colors.white),
            const Expanded(child: SizedBox()),
            Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 5),
            Container(height: 15, width: 20, color: Colors.white),
          ]),
          const SizedBox(height: 5),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.white),
          const SizedBox(height: 3),
          Container(height: 15, width: MediaQuery.of(context).size.width, color: Colors.white),
        ]),
      ),
    );
  }
}

