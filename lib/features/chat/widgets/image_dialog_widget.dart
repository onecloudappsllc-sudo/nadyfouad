import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';

class ImageDialogWidget extends StatelessWidget {
  final String imageUrl;
  const ImageDialogWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomImageWidget(image: imageUrl, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

          ],
        ),
      ),
    );
  }
}