import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_single_child_list_widget.dart';
import 'package:flutter_grocery/features/order/providers/image_note_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ImageNoteUploadWidget extends StatelessWidget {
  const ImageNoteUploadWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    return (configModel?.orderImageStatus ?? false) ?  CustomShadowWidget(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
      child: Consumer<OrderImageNoteProvider>(
        builder: (context, imageNoteProvider, _) {
          return Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(configModel?.orderImageLabelName ?? '', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text('(${getTranslated('max_size', context)})', style: poppinsRegular.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: Dimensions.fontSizeSmall,
                ), maxLines: 2, overflow: TextOverflow.ellipsis,),
              ]),

              Flexible(child: TextButton(
                onPressed: ()=> _onImageUpload(context),
                child: Text(
                  getTranslated( 'add', context),
                  style: poppinsRegular.copyWith(color: Theme.of(context).primaryColor),
                ),
              )),
            ]),
            const Divider(height: 1),

            if(imageNoteProvider.imageFiles?.isEmpty ?? false) InkWell(
              onTap: ()=> _onImageUpload(context),
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: Stack(children: [
                    Container(width: 100, height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                        child: CustomAssetImageWidget(Images.placeHolder),
                      ),
                    ),

                    Positioned(top: 0, right: 0, child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Icon(Icons.file_upload_outlined,color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
                          )),
                    )),

                  ]),
              ),
            ),


            CustomSingleChildListWidget(
              scrollDirection: Axis.horizontal,
              itemCount: imageNoteProvider.imageFiles?.length ?? 0,
              itemBuilder: (index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [
                    Container(width: 100, height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                        child: ResponsiveHelper.isWeb()? Image.network(imageNoteProvider.imageFiles![index]!.path, width: 100, height: 100,
                          fit: BoxFit.cover,
                        ):Image.file(File(imageNoteProvider.imageFiles![index]!.path), width: 100, height: 100,
                          fit: BoxFit.cover,
                        ),
                      ) ,
                    ),

                    Positioned(top: 0, right: 0, child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: InkWell(
                        onTap :() => imageNoteProvider.removeImage(index),
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Icon(Icons.clear,color: Colors.red,size: 15,),
                            )),

                      ),
                    )),

                  ]),
                );
              },
            ),




          ]);
        }
      ),
    ) : const SizedBox();
  }


  void _onImageUpload(BuildContext context) {
    final OrderImageNoteProvider orderImageNoteProvider = Provider.of<OrderImageNoteProvider>(context, listen: false);

    if(kIsWeb) {
      orderImageNoteProvider.onPickImage(false);

    }else {
      ResponsiveHelper.showDialogOrBottomSheet(context,  CustomAlertDialogWidget(
        child: Column(children: [
          ListTile(
            onTap: (){
              Navigator.pop(context);
              orderImageNoteProvider.onPickImage(false, fromCamera: true);
            },
            leading: const Icon(Icons.camera_alt),
            title: Text(getTranslated('camera', context)),
          ),

          ListTile(
            onTap: (){
              Navigator.pop(context);
              orderImageNoteProvider.onPickImage(false);
            },                          leading: const Icon(Icons.image),
            title: Text(getTranslated('media', context)),
          ),

        ]),
      ));
    }
  }
}
