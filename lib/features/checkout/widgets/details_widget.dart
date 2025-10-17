import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/checkout/domain/models/check_out_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/checkout/widgets/amount_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/image_note_upload_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/payment_section_widget.dart';
import 'package:provider/provider.dart';

import 'partial_pay_widget.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    super.key,
    required this.paymentList,
    required this.noteController,
  });

  final List<PaymentMethod> paymentList;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    CheckOutModel? checkOutData = Provider.of<OrderProvider>(context, listen: false).getCheckOutData;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      const PaymentSectionWidget(),

      PartialPayWidget(totalPrice: (checkOutData?.amount ?? 0) + (checkOutData?.deliveryCharge ?? 0)),

      const ImageNoteUploadWidget(),

      CustomShadowWidget(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(getTranslated('add_delivery_note', context), style: poppinsRegular),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomTextFieldWidget(
            fillColor: Theme.of(context).canvasColor,
            isShowBorder: true,
            controller: noteController,
            hintText: getTranslated('type', context),
            maxLines: 5,
            inputType: TextInputType.multiline,
            inputAction: TextInputAction.newline,
            capitalization: TextCapitalization.sentences,
          ),
        ]),
      ),


    ]);
  }
}


