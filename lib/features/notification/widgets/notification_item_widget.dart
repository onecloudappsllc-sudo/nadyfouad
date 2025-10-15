import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/notification/domain/models/notification_model.dart';
import 'package:flutter_grocery/features/notification/widgets/notification_dialog_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    Key? key,
    required this.notification, required this.isTitle,
  }) : super(key: key);

  final NotificationModel notification;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) {
          return NotificationDialogWidget(notificationModel: notification);
        });
      },
      hoverColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isTitle ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
            child: Text(DateConverterHelper.isoStringToLocalDateOnly(notification.createdAt!)),
          ) : const SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 50, width: 50,
                        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomImageWidget(
                            placeholder: Images.placeHolder,
                            image: '${splashProvider.baseUrls?.notificationImageUrl}/${notification.image}',
                            height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ) ,
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          notification.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                        subtitle: Text(notification.description ?? '',
                          style: poppinsLight.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Container(height: 1, color: ColorResources.getGreyColor(context).withOpacity(.2))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
