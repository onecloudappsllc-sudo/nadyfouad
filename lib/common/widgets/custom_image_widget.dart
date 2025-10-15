import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isNotification;
  final String placeholder;

  const CustomImageWidget({
    Key? key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholderImage = placeholder.isNotEmpty
        ? placeholder
        : Images.placeHolder;

    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => CustomAssetImageWidget(
        placeholderImage,
        height: height,
        width: width,
        fit: fit,
      ),
      errorWidget: (context, url, error) => CustomAssetImageWidget(
        placeholderImage,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
