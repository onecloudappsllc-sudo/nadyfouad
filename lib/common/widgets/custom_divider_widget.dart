import 'package:flutter/material.dart';

class CustomDividerWidget extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  const CustomDividerWidget({Key? key, this.height = 1, this.color = Colors.black, this.width = 5.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final double dashWidth = width;
        final double dashHeight = height;
        final int dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (value) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}