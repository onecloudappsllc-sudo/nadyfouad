import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);


    return Center(child: SizedBox(
      width: Dimensions.webScreenWidth,
      child: ResponsiveHelper.isDesktop(context) ? Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(height: 150,  color:  Theme.of(context).primaryColor.withOpacity(0.5)),

          Positioned(left: 30, top: 45, child: Container(
            height: 180, width: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: const Offset(0, 8.8) )],
            ),
            child: ClipOval(child: CustomImageWidget(
              placeholder: Images.placeHolder,
              height: 170, width: 170, fit: BoxFit.cover,
              image: '${splashProvider.baseUrls?.customerImageUrl}/${ profileProvider.userInfoModel?.image}',
            )),
          )),

          Positioned(bottom: -10, right: 10, child: InkWell(
            onTap: ()=> Navigator.pushNamed(context, RouteHelper.getProfileEditRoute()),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Row(children: [
                const Icon(Icons.edit,size: Dimensions.paddingSizeDefault,color: Colors.white),

                Text(getTranslated('edit', context), style: poppinsMedium.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Colors.white,
                )),
              ]),
            ),
          ))
        ]),

        const SizedBox(height: 100),

      ]) : Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: ColorResources.getGreyColor(context), width: 2),
              shape: BoxShape.circle,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: profileProvider.file == null ? CustomImageWidget(
                placeholder: Images.placeHolder,
                width: 100, height: 100, fit: BoxFit.cover,
                image: '${splashProvider.baseUrls?.customerImageUrl}/${profileProvider.userInfoModel?.image}',
              ) : Image.file(
                profileProvider.file!, width: 100, height: 100, fit: BoxFit.fill,
              ),
            ),
          ),

          Positioned(right: -10, child: TextButton(
            onPressed: ()=> Navigator.pushNamed(context, RouteHelper.getProfileEditRoute()),
            child: Text(getTranslated('edit', context), style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            )),
          )),
        ]),
      ]),
    ));
  }
}
