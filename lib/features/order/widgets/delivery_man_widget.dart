import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  const DeliveryManWidget({Key? key, required this.deliveryMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200]!, spreadRadius: 0.5, blurRadius: 0.5)
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: CustomImageWidget(
              placeholder: Images.placeHolder,
              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${deliveryMan!.image}',
              height: 40, width: 40, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${deliveryMan?.fName} ${deliveryMan?.lName}',
                  style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
                Text(
                  '${deliveryMan?.email}',
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              launchUrlString('tel:${deliveryMan!.phone}');
            },
            icon: Image.asset(Images.call, color: Theme.of(context).primaryColor, width: 30, height: 30),
          ),
        ],
      ),
    );
  }
}
