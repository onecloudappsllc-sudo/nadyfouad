import 'package:flutter/material.dart';

class UpsideExpansionWidget extends StatefulWidget {
  const UpsideExpansionWidget({
    super.key, required this.children,
    required this.title,
  });

  final List<Widget> children;
  final Widget title;

  @override
  State<UpsideExpansionWidget> createState() => _UpsideExpansionWidgetState();
}

class _UpsideExpansionWidgetState extends State<UpsideExpansionWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if(expanded){
            expanded = false;
          }else{
            expanded = true;
          }
          setState(() {});
        },
        child: Icon(expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Theme.of(context).hintColor),
      ),

      if (expanded) ... widget.children,

      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          dense: true,
          // controller: controller,
          tilePadding: EdgeInsets.zero,
          shape: Border.all(color: Colors.transparent, width: 0),
          collapsedShape: Border.all(color: Colors.transparent, width: 0),
          title: widget.title,
          onExpansionChanged: (newExpanded) {
            setState(() {
              expanded = newExpanded;
              // widget.onChange(expanded);
            });
          },
          trailing: const SizedBox.shrink(), // Remove the default icon
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          showTrailingIcon: false,
          children: const [],
        ),
      )
    ]);
  }
}