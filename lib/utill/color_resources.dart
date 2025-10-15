import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFb2b8bd) : const Color(0xFFE4EAEF);
  }


  static Color getDarkColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF4d5054) : const Color(0xFF25282B);
  }


  static Color getFooterTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFF515755);
  }


  static Color getGreyLightColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFb2b8bd) : const Color(0xFF98a1ab);
  }


  static Color getCategoryBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFFb2b8bd);
  }



  static Color getAppBarHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF5c746c) : const Color(0xFFEDF4F2);
  }

  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFFa1916c) :const Color(0xFFFFDDD9);
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF585a5c) : const Color(0xFFF4F7FC);
  }
  static const Color cartShadowColor = Color(0xFFA7A7A7);
  static const Color ratingColor = Color(0xFFFFBA08);
  static const Color colorGreen = Color(0xFF057237);
  static const Color colorBlue = Color(0xFF1692C9);
  static const Color redColor = Color(0xFFFF5C00);

}
