
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool isComplete;
  final bool haveTopBar;
  final String? title;
  final String? subTitle;
  final Widget? child;
  final double height;
  final String? statusImage;
  final Widget? trailing;
  final Widget? subTitleWidget;
  final Color? color;

  const CustomStepperWidget({Key? key,
    required this.title, required this.isActive,
    this.child, this.haveTopBar = true, this.height = 30,
    this.statusImage = Images.order, this.subTitle,
    required this.isComplete, this.trailing, this.subTitleWidget, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ?
    WebStepper(
      title: title, isActive: isActive, isComplete: isComplete,
      subTitleWidget: subTitleWidget, statusImage: statusImage,
      haveTopBar: haveTopBar,
      color: color,
    ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if(haveTopBar) Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            height: height,
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: DashedLineVerticalPainter(isActive: isComplete),
            ),
          ),

          child == null ? const SizedBox() : child!,
        ],
      ),



      if(title != null) ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Image.asset(
              statusImage!, width: 30,
              color: Theme.of(context).primaryColor.withOpacity(isComplete ? 1 : 0.5),
            ),
          ),
        ),
        title: Text(title!, style: poppinsMedium.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: isComplete ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
        )),
        subtitle: subTitleWidget ?? (subTitle != null ? Text(subTitle!, style: poppinsRegular.copyWith(color: Theme.of(context).disabledColor)) : const SizedBox()),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if(trailing != null) trailing!,
          if(trailing != null) const SizedBox(width: Dimensions.paddingSizeSmall),

          if(isActive) Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size:  35),
        ]),
      ),

    ]);
  }
}


class DashedLineVerticalPainter extends CustomPainter {
  final bool? isActive;
  final Axis? axis;
  DashedLineVerticalPainter({this.isActive = false, this.axis = Axis.vertical});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 6, dashSpace = 3, startY = 0, dashWidth = 6, startX = 0;

    if(axis == Axis.vertical){
      final paint = Paint()
        ..color = isActive! ?  Theme.of(Get.context!).primaryColor : Theme.of(Get.context!).disabledColor
        ..strokeWidth = size.width;
      while (startY < size.height) {
        canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
        startY += dashHeight + dashSpace;
      }
    }else{
      final paint = Paint()
        ..color = isActive! ?  Theme.of(Get.context!).primaryColor : Theme.of(Get.context!).disabledColor
        ..strokeWidth = size.height;
      while (startX < size.width) {
        canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WebStepper extends StatelessWidget {
  final bool isActive;
  final bool isComplete;
  final bool haveTopBar;
  final String? title;
  final String? subTitle;
  final Widget? child;
  final double width;
  final String? statusImage;
  final Widget? trailing;
  final Widget? subTitleWidget;
  final Color? color;


  const WebStepper({Key? key,
    required this.title, required this.isActive,
    this.child, this.haveTopBar = true, this.width = 50,
    this.statusImage = Images.order, this.subTitle,
    required this.isComplete, this.trailing, this.subTitleWidget, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CustomAssetImageWidget(
                  statusImage!, width: 30,
                  color: Theme.of(context).primaryColor.withOpacity(isComplete ? 1 : 0.5),
                ),
              ),

           if(haveTopBar) CustomPaint(
              size: const Size(120, 2),
              painter: DashedLineVerticalPainter(isActive: isComplete, axis: Axis.horizontal),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          Text(title!, style: poppinsMedium.copyWith(color: color ?? Theme.of(context).primaryColor)),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          if(isActive) Icon(Icons.check_circle, color: color ?? Theme.of(context).primaryColor, size:  20),


        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),


        if(subTitleWidget != null) subTitleWidget!,

      ]),
    );
  }
}

