import 'package:flutter/material.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/address/widgets/permission_dialog_widget.dart';
import 'package:geolocator/geolocator.dart';

class AddressHelper {
  static void checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => const PermissionDialogWidget());
    }else {
      callback();
    }
  }


}