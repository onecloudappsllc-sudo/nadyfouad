import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextHoverWidget extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  const TextHoverWidget({Key? key,required this.builder}) : super(key: key);

  @override
  State<TextHoverWidget> createState() => _TextHoverWidgetState();
}

class _TextHoverWidgetState extends State<TextHoverWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: widget.builder(isHovered),
      ),
    ) : widget.builder(false);
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
