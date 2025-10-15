import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/menu/domain/models/menu_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/text_hover_widget.dart';
import 'package:flutter_grocery/features/menu/widgets/sign_out_dialog_widget.dart';

class ProfileHoverWidget extends StatefulWidget {
  final String? currentRoute;
  const ProfileHoverWidget({Key? key, this.currentRoute}) : super(key: key);

  @override
  State<ProfileHoverWidget> createState() => _ProfileHoverWidgetState();
}

class _ProfileHoverWidgetState extends State<ProfileHoverWidget> {
  bool isExited = false;

  @override
  Widget build(BuildContext context) {

    List<MenuModel> list = [
      MenuModel(icon: Images.profile, title: getTranslated('profile', context), route: RouteHelper.profile),
      MenuModel(icon: Images.order, title: getTranslated('my_orders', context), route: RouteHelper.orderListScreen),
      MenuModel(icon: Images.profile, title: getTranslated('log_out', context), route: 'auth'),
    ];

    return MouseRegion(
      onExit: isExited ? null : (_)=> Navigator.of(context).pop(),
      child: Container(color: Theme.of(context).cardColor, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list.map((item) => widget.currentRoute == item.route ? const SizedBox() : InkWell(
          onTap: (){
            setState(() {
              isExited = true;
            });

            if(item.route == 'auth'){
              Navigator.pop(context);

              Future.delayed(const Duration(seconds: 0), () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const SignOutDialogWidget(),
              ));


            }else{

              Navigator.pushNamed(context, item.route!);
            }

          },
          child: Column(
            children: [
              TextHoverWidget(builder: (isHover)=> Container(
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  color: isHover ? Theme.of(context).focusColor : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeExtraSmall,
                    ),
                    child: Text(item.title ?? '', overflow: TextOverflow.ellipsis, maxLines: 1, style: poppinsRegular),
                  ),

                  const Divider(height: 0, color: Colors.transparent)

                ]),
              )),

              Divider(height: 1, color: (list.indexOf(item) + 1) != list.length ? Theme.of(context).dividerColor : Colors.transparent)

            ],
          ),
        )).toList(),
      )),
    );
  }
}
