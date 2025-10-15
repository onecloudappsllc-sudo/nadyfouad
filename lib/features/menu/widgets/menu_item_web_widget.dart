
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/menu/domain/models/menu_model.dart';
import 'package:flutter_grocery/features/menu/widgets/sign_out_dialog_widget.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class MenuItemWebWidget extends StatelessWidget {
  final MenuModel menu;
  const MenuItemWebWidget({Key? key, required this.menu}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if(menu.route == 'version') {

        }else if (menu.title == getTranslated('profile', context)){
          if(isLogin){
            Navigator.pushNamed(context, RouteHelper.getProfileEditRoute());
          }else {
            Navigator.pushNamed(context, RouteHelper.getLoginRoute());
          }
        }else if(menu.route == 'auth'){
          isLogin ? showDialog(
            context: context, barrierDismissible: false, builder: (context) => const SignOutDialogWidget(),
          ) : Navigator.pushNamed(context, RouteHelper.getLoginRoute());
        }else{
          Navigator.pushNamed(context, menu.route!);
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menu.iconWidget != null ? menu.iconWidget! : CustomAssetImageWidget(
              menu.icon, width: 50, height: 50,
              color: menu.route == 'auth' && isLogin ? Theme.of(context).colorScheme.error.withOpacity(0.7) : Theme.of(context).textTheme.bodyLarge?.color,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(menu.title!, style: poppinsRegular),
          ],
        ),
      ),
    );
  }
}
