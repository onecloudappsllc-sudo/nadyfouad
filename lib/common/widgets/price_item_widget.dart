import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class PriceItemWidget extends StatelessWidget {
  const PriceItemWidget({Key? key, required this.title, required this.subTitle, this.style}) : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: style ?? poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor)),

      CustomDirectionalityWidget(child: Text(
        subTitle,
        style: style ?? poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
    ]);
  }
}
