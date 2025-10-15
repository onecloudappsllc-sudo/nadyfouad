import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/on_hover_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/dimensions.dart';

class CustomSliderListWidget extends StatefulWidget {
  final ScrollController controller;
  final double  verticalPosition;
  final double  horizontalPosition;
  final bool isShowForwardButton;
  final Widget child;
  const CustomSliderListWidget({
    Key? key,required this.controller, required this.verticalPosition,
    this.horizontalPosition = 0,
    required this.child, this.isShowForwardButton = true,
  }) : super(key: key);

  @override
  State<CustomSliderListWidget> createState() => _CustomSliderListWidgetState();
}

class _CustomSliderListWidgetState extends State<CustomSliderListWidget> {


  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    widget.controller.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    if(ResponsiveHelper.isDesktop(Get.context!)) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  void _checkScrollPosition() {
    setState(() {
      if (widget.controller.position.pixels <= 0) {
        showBackButton = false;
      } else {
        showBackButton = true;
      }

      if (widget.controller.position.pixels >= widget.controller.position.maxScrollExtent) {
        showForwardButton = false;
      } else {
        showForwardButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.isShowForwardButton && isFirstTime){
      setState(() {
        showForwardButton = true;
      });
    }
    isFirstTime = false;


    return ResponsiveHelper.isDesktop(context) ?  Stack(
      children: [
        widget.child,

        if(showBackButton) Positioned(
          top: widget.verticalPosition, left: widget.horizontalPosition,
          child: _ArrowIconButtonWidget(
            isRight: false,
            onTap: () => widget.controller.animateTo(widget.controller.offset - Dimensions.webScreenWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
          ),
        ),

        if(showForwardButton) Positioned(
          top: widget.verticalPosition, right: widget.horizontalPosition,
          child: _ArrowIconButtonWidget(
            onTap: () => widget.controller.animateTo(widget.controller.offset + Dimensions.webScreenWidth,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
          ),
        ),
      ],
    ) : widget.child;
  }
}

class _ArrowIconButtonWidget extends StatelessWidget {
  final bool isRight;
  final void Function()? onTap;
  const _ArrowIconButtonWidget({Key? key, this.isRight = true, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 40, width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).cardColor,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: OnHoverWidget(child: Icon(isRight ? Icons.arrow_forward : Icons.arrow_back, color: Theme.of(context).primaryColor, size: 25)),
      ),
    );
  }
}


