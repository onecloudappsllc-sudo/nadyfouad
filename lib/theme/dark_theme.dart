import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF82CAB6),
  secondaryHeaderColor: const Color(0xFF7f968e),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardColor: const Color(0xFF121212),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFADC4C8),
  canvasColor: const Color(0xFF4d5054),
  shadowColor: Colors.black.withOpacity(0.4),
  textTheme: TextTheme(titleLarge: TextStyle(color: const Color(0xFFE0E0E0).withOpacity(0.3))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    background: const Color(0xFF212121),
    onBackground: const Color(0xFFC3CAD9),
    primary: const Color(0xFF82CAB6),
    onPrimary: const Color(0xFF82CAB6),
    secondary: const Color(0xFF7f968e),
    onSecondary: const Color(0xFFefe6fc),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white10,
    onSurface:  Colors.white70,
    shadow: Colors.black.withOpacity(0.4),
  ),
);
