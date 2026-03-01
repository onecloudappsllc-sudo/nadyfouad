import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool isSelected;

  const CategoryItemWidget({Key? key, required this.title, required this.icon, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor
      ),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            //padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? ColorResources.getCategoryBgColor(context)
                    : ColorResources.getGreyLightColor(context).withOpacity(0.05)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImageWidget(
                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/$icon',
                fit: BoxFit.cover, width: 100, height: 100,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: Text(title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: poppinsSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: isSelected ? Theme.of(context).canvasColor : Theme.of(context).textTheme.bodyLarge?.color
                )),
          ),
        ]),
      ),
    );
  }
}
