import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/app_bar_base_widget.dart';
import 'package:flutter_grocery/helper/dialog_helper.dart';
import 'package:flutter_grocery/common/widgets/main_app_bar_widget.dart';
import 'package:flutter_grocery/features/menu/widgets/currency_dialog_widget.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../widgets/acount_delete_dialog_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()
          ? null : (ResponsiveHelper.isDesktop(context)
          ? const MainAppBarWidget(): const AppBarBaseWidget()) as PreferredSizeWidget?,

      body: Center(
        child: SizedBox(
          width: 1170,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            children: [
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                value: Provider.of<ThemeProvider>(context).darkTheme,
                onChanged: (bool isActive) =>Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                title: Text(getTranslated('dark_theme', context), style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              ),

              _TitleButton(
                icon: Icons.language,
                title: getTranslated('choose_language', context),
                onTap: () => showDialogHelper(context, const CurrencyDialogWidget()),
              ),

              authProvider.isLoggedIn() ? ListTile(
                onTap: () {
                  showDialogHelper(context,
                      AccountDeleteDialogWidget(
                        icon: Icons.question_mark_sharp,
                        title: getTranslated('are_you_sure_to_delete_account', context),
                        description: getTranslated('it_will_remove_your_all_information', context),
                        onTapFalseText:getTranslated('no', context),
                        onTapTrueText: getTranslated('yes', context),
                        isFailed: true,
                        onTapFalse: () => Navigator.of(context).pop(),
                        onTapTrue: () => authProvider.deleteUser(context),
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                leading: Icon(Icons.delete, size: 25, color: Theme.of(context).colorScheme.error),
                title: Text(
                  getTranslated('delete_account', context),
                  style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

}

class _TitleButton extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Function onTap;
  const _TitleButton({Key? key, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title!, style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: onTap as void Function()?,
    );
  }
}

