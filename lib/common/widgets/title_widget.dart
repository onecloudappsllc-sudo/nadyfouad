import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/text_hover_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;
  const TitleWidget({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: ResponsiveHelper.isDesktop(context) ? ColorResources.getAppBarHeaderColor(context) : Theme.of(context).canvasColor,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : 15, vertical: 12),
      margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 5, vertical: 10) : EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title!,
          style: poppinsBold.copyWith(fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        onTap != null ? InkWell(
          onTap: onTap as void Function()?,
          child: TextHoverWidget(
            builder: (bool isHovered)=> Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Text(
                'view_all'.tr,
                style: poppinsRegular.copyWith(
                  fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeLarge : Dimensions.fontSizeSmall,
                  color: isHovered ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
                ),
              ),
            )),
        ) : const SizedBox(),
      ]),
    );
  }
}
