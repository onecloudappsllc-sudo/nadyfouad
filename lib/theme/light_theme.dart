import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF1C1556),
  secondaryHeaderColor: const Color(0xFFEEFCF8),
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFFADC4C8),
  hintColor: const Color(0xFF52575C),
  canvasColor: const Color(0xFFFAFAFA),
  shadowColor: Colors.grey[300],

  textTheme: const TextTheme(titleLarge: TextStyle(color: Color(0xFFE0E0E0))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  colorScheme: ColorScheme(
    background: const Color(0xFFFCFCFC),
    brightness: Brightness.light,
    primary: const Color(0xFF1C1556),
    onPrimary: const Color(0xFF1C1556),
    secondary: const Color(0xFFEEFCF8),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    onBackground: const Color(0xFFC3CAD9),
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),
);