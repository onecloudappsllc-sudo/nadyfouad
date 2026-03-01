import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/features/order/domain/models/review_body_model.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/features/review/providers/review_provider.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/features/order/widgets/delivery_man_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/footer_web_widget.dart';

class DeliveryManReviewWidget extends StatefulWidget {
  final DeliveryMan? deliveryMan;
  final String orderID;
  const DeliveryManReviewWidget({Key? key, required this.deliveryMan, required this.orderID}) : super(key: key);

  @override
  State<DeliveryManReviewWidget> createState() => _DeliveryManReviewWidgetState();
}

class _DeliveryManReviewWidgetState extends State<DeliveryManReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Center(child: SizedBox(
            width: Dimensions.webScreenWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

              widget.deliveryMan != null ? DeliveryManWidget(deliveryMan: widget.deliveryMan) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300]!,
                    blurRadius: 5, spreadRadius: 1,
                  )],
                ),
                child: Column(children: [
                  Text(
                    getTranslated('rate_his_service', context),
                    style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(height: 30, child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return InkWell(
                        child: Icon(
                          reviewProvider.deliveryManRating < (i + 1) ? Icons.star_border : Icons.star,
                          size: 25,
                          color: reviewProvider.deliveryManRating < (i + 1)
                              ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)
                              : Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          reviewProvider.setDeliveryManRating(i + 1);
                        },
                      );
                    },
                  )),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    getTranslated('share_your_opinion', context),
                    overflow: TextOverflow.ellipsis,
                    style: poppinsMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    maxLines: 5,
                    capitalization: TextCapitalization.sentences,
                    controller: _controller,
                    hintText: getTranslated('write_your_review_here', context),
                    fillColor: Theme.of(context).cardColor,
                  ),
                  const SizedBox(height: 40),

                  // Submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      CustomButtonWidget(
                        isLoading: reviewProvider.isLoading,
                        buttonText: getTranslated('submit', context),
                        onPressed: () {
                          if (reviewProvider.deliveryManRating == 0) {
                            showCustomSnackBarHelper(getTranslated('give_a_rating', context));
                          } else if (_controller.text.isEmpty) {
                            showCustomSnackBarHelper(getTranslated('write_a_review', context));
                          } else {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            ReviewBodyModel reviewBody = ReviewBodyModel(
                              deliveryManId: widget.deliveryMan!.id.toString(),
                              rating: reviewProvider.deliveryManRating.toString(),
                              comment: _controller.text,
                              orderId: widget.orderID,
                            );
                            reviewProvider.submitDeliveryManReview(reviewBody).then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBarHelper(value.message!, isError: false);
                                _controller.text = '';
                              } else {
                                showCustomSnackBarHelper(value.message!);
                              }
                            });
                          }
                        },
                      ),

                    ]),
                  ),
                ]),
              ),

            ]),

          ))),

          const FooterWebWidget(footerType: FooterType.sliver),

        ]);
      },
    );
  }
}
