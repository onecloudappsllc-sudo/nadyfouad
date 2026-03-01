import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/features/order/domain/models/order_details_model.dart';
import 'package:flutter_grocery/features/order/domain/models/review_body_model.dart';
import 'package:flutter_grocery/features/order/widgets/ordered_product_list_widget.dart';
import 'package:flutter_grocery/features/review/providers/review_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/footer_web_widget.dart';

class ProductReviewWidget extends StatelessWidget {
  final List<OrderDetailsModel> orderDetailsList;
  const ProductReviewWidget({Key? key, required this.orderDetailsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Center(child: SizedBox(
            width: Dimensions.webScreenWidth,
            child: ListView.builder(
              itemCount: orderDetailsList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))],
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  ),
                  child: Column(
                    children: [

                      // Product details
                      OrderedProductItem(orderDetailsModel:  orderDetailsList[index], fromReview: true),
                      const Divider(height: Dimensions.paddingSizeLarge),

                      // Rate
                      Text(
                        getTranslated('rate_the_order', context),
                        style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)), overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return InkWell(
                              child: Icon(
                                reviewProvider.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                                size: 25,
                                color: reviewProvider.ratingList[index] < (i + 1)
                                    ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                                    : Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                if(!reviewProvider.submitList[index]) {
                                  reviewProvider.setRating(index, i + 1);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Text(
                        getTranslated('share_your_opinion', context),
                        style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)), overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        maxLines: 3,
                        capitalization: TextCapitalization.sentences,
                        isEnabled: !reviewProvider.submitList[index],
                        hintText: getTranslated('write_your_review_here', context),
                        fillColor: Theme.of(context).cardColor,
                        onChanged: (text) {
                          reviewProvider.setReview(index, text);
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Submit button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Column(
                          children: [
                            !reviewProvider.loadingList[index] ? CustomButtonWidget(
                              buttonText: getTranslated(reviewProvider.submitList[index] ? 'submitted' : 'submit', context),
                              onPressed: reviewProvider.submitList[index] ? null : () {
                                if(!reviewProvider.submitList[index]) {
                                  if (reviewProvider.ratingList[index] == 0) {
                                    showCustomSnackBarHelper(getTranslated('give_a_rating', context));
                                  } else if (reviewProvider.reviewList[index].isEmpty) {
                                    showCustomSnackBarHelper(getTranslated('write_a_review', context));
                                  } else {
                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    ReviewBodyModel reviewBody = ReviewBodyModel(
                                      productId: orderDetailsList[index].productId.toString(),
                                      rating: reviewProvider.ratingList[index].toString(),
                                      comment: reviewProvider.reviewList[index],
                                      orderId: orderDetailsList[index].orderId.toString(),
                                    );
                                    reviewProvider.submitReview(index, reviewBody).then((value) {
                                      if (value.isSuccess) {
                                        showCustomSnackBarHelper(value.message!, isError: false);
                                        reviewProvider.setReview(index, '');
                                      } else {
                                        showCustomSnackBarHelper(value.message!);
                                      }
                                    });
                                  }
                                }
                              },
                            ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ))),

          const FooterWebWidget(footerType: FooterType.sliver),

        ]);
      },
    );
  }
}
