import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

void showCustomSnackBarHelper(String message, {bool isError = true, Duration? duration, Widget? content, EdgeInsetsGeometry? margin, Color? backgroundColor, EdgeInsetsGeometry? padding}) {
  ScaffoldMessenger.of(Get.context!).clearSnackBars();
  final double width = MediaQuery.of(Get.context!).size.width;
  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(key: UniqueKey(), content: content ??  Text(message, style: poppinsLight.copyWith(color: Colors.white),),
      margin: ResponsiveHelper.isDesktop(Get.context!) ? margin ??  EdgeInsets.only(
        right: width * 0.75, bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeExtraSmall,
      ) : null,
      duration: duration ?? const Duration(milliseconds: 4000),
      behavior: ResponsiveHelper.isDesktop(Get.context!) ? SnackBarBehavior.floating : SnackBarBehavior.fixed ,
      dismissDirection: DismissDirection.down,
      backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
    padding: padding,

      ),
  );
}
