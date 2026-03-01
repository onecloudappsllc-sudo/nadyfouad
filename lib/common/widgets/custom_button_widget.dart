import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Function? onPressed;
  final double margin;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final IconData? icon;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomButtonWidget({
    Key? key, required this.buttonText,
    required this.onPressed,
    this.margin = 0,
    this.textColor,
    this.borderRadius = 10,
    this.backgroundColor,
    this.width,
    this.height,
    this.icon,
    this.textStyle,
    this.isLoading = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? (onPressed == null ? Theme.of(context).hintColor.withOpacity(0.6) : Theme.of(context).primaryColor),
          minimumSize: Size( Dimensions.webScreenWidth,  height ?? 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          side: borderColor != null ? BorderSide(color: borderColor!, width: 1) : null,
        ),
        child: isLoading ?
        Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(getTranslated('loading', context), style: poppinsMedium.copyWith(color: Colors.white)),
        ]),
        ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            child: Icon(icon, color: textColor ?? Theme.of(context).cardColor),
          ) : const SizedBox(),

          Text(buttonText ?? '', textAlign: TextAlign.center,  style: textStyle ?? poppinsMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: textColor ?? Theme.of(context).cardColor,
          )) ,

        ]),
      ),
    );
  }
}
