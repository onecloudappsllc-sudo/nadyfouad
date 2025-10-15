


import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/chat/screens/chat_screen.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/features/order/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class NotificationDialogWebWidget extends StatefulWidget {
  final String? title;
  final String? body;
  final int? orderId;
  final String? image;
  final String? type;
  const NotificationDialogWebWidget({Key? key, required this.title, required this.body, required this.orderId, this.image, this.type}) : super(key: key);

  @override
  State<NotificationDialogWebWidget> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationDialogWebWidget> {

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {

    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
      //insetPadding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: CustomDirectionalityWidget(child: Text(
              '${widget.title} ${widget.orderId != null ? '(${widget.orderId})': ''}',
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            )),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Column(
              children: [
                Text(
                  widget.body!, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                ),
               if(widget.image != null)
                 const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                if(widget.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomImageWidget(
                      height: 100,
                      width: 500,
                      image: widget.image!,
                    ),
                  ),


              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Flexible(
              child: SizedBox(width: 120, height: 40,child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
                ),
                child: Text(
                  'cancel'.tr, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              )),
            ),


            const SizedBox(width: 20),

           if(widget.orderId != null || widget.type == 'message' || widget.type == 'wallet') Flexible(
             child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButtonWidget(
                  textColor: Colors.white,
                  buttonText: 'go'.tr,
                  onPressed: () async {
                    Navigator.pop(context);

                    try{
                      if(widget.orderId == null) {
                        print("-------(HERE I AM)--------");
                        Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null));
                      }else if(widget.type == 'wallet'){
                        Navigator.pushNamed(context, RouteHelper.getWalletRoute());
                      }else if(widget.orderId != null && widget.type == 'message'){
                        print("-------(HERE I AM ORDER DETAILS SCREEN)--------");
                        await orderProvider.trackOrder(widget.orderId.toString(), null, context, false, isUpdate: false);
                        Get.navigator!.push(MaterialPageRoute(
                          builder: (context) => ChatScreen(orderModel: orderProvider.trackModel),
                        ));
                      }else{
                        Get.navigator!.push(MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(orderModel: null, orderId: widget.orderId),
                        ));
                      }

                    }catch (e) {}

                  },
                ),
              ),
           ),

          ]),

        ]),
      ),
    );
  }
}
