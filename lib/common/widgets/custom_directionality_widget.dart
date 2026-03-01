import 'package:flutter/material.dart';

class CustomDirectionalityWidget extends StatelessWidget {
  final Widget child;
  const CustomDirectionalityWidget({Key? key,  required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}