import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class KeyValueItemWidget extends StatelessWidget {
  final String item;
  final String value;

  const KeyValueItemWidget({
    Key? key, required this.item, required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item, style: poppinsRegular,maxLines: 1, overflow: TextOverflow.ellipsis),
        // const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(flex: 2, child: Text(' : $value',
          style: poppinsRegular, maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    );
  }
}
