import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WalletShimmerWidget extends StatelessWidget {
  final bool isEnable;
  const WalletShimmerWidget({Key? key, required this.isEnable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: UniqueKey(),
      physics:  const NeverScrollableScrollPhysics(),
      shrinkWrap:  true,
      itemCount: 10,
      padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 28 : 25),
      itemBuilder: (context, index) {
        return Container(
          margin:  const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08))
          ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnable,
            child: Column(children: [
              ListTile(
                leading: CircleAvatar(backgroundColor: Theme.of(context).shadowColor),
                title: Container(height: 14, width: 100, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                subtitle: Container(height: 10, width: 60, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                trailing: Container(height: 10, width: 80, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),

              ),
              Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault), child: Divider(color: Theme.of(context).disabledColor)),
            ]),
          ),
        );
      },
    );
  }
}