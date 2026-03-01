import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TrackOrderShimmerWidget extends StatelessWidget {
  const TrackOrderShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(child: Center(child: SizedBox(
        width: Dimensions.webScreenWidth,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 0.5, blurRadius: 0.5)
                ],
              ),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(height: 14, width: 200, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                  Container(height: 14, width: 50, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                ]),

                const Divider(height: Dimensions.paddingSizeDefault),

                Column(
                  children: [

                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(height: 20, width: 20, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 20),

                      Container(height: 14, width: 200, decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize:MainAxisSize.min, children: [
                      Container(height: 20, width: 20, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 20),

                      Container(height: 14, width: 250, decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                      )),
                    ]),
                  ],
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),



              ]),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [1, 2, 3, 4, 5, 6].map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: ListTile(
                  title: Container(height: 20, width: 20, decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                  )),
                  leading: Container(height: 40, width: 40, decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor.withOpacity(0.5), borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  )),
                ),
              )).toList()),
            ),
          ]),
        ))));

  }
}
