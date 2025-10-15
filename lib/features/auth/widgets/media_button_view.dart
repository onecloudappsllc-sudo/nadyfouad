import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';

class MediaButtonView extends StatelessWidget {
  final Function onTap;
  final String image;
  const MediaButtonView({Key? key, required this.onTap, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onTap(),
      child: Container(
        height: ResponsiveHelper.isDesktop(context) ? 50 : 40,
        width: ResponsiveHelper.isDesktop(context)? 130 : ResponsiveHelper.isTab(context) ? 110 : 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSizeTen)),
        ),
        child:   Image.asset(
          image,
          height: ResponsiveHelper.isDesktop(context)
              ? 30 : ResponsiveHelper.isTab(context)
              ? 25 : 20,
          width: ResponsiveHelper.isDesktop(context)
              ? 30 :ResponsiveHelper.isTab(context)
              ? 25 : 20,
        ),
      ),
    );
  }
}
