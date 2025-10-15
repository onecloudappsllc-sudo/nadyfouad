import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_grocery/main.dart';

class ResponsiveHelper {

  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    }else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    final size = MediaQuery.of(Get.context!).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size < 1300 && size >= 660) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }

  static void showDialogOrBottomSheet(BuildContext context, Widget view, {bool isScrollControlled = false}){
    if(ResponsiveHelper.isDesktop(context)) {
      showDialog(context: context, builder: (ctx)=> view);
    }else{
      showModalBottomSheet(backgroundColor: Colors.transparent, isScrollControlled: isScrollControlled, context: context, builder: (ctx)=> view);
    }
  }
}