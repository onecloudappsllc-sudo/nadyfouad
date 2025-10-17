import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:image_picker/image_picker.dart';

class OrderImageNoteProvider extends ChangeNotifier {

  List<XFile?>? _imageFiles;

  List<XFile?>? get imageFiles => _imageFiles;





  void onPickImage(bool isRemove, {bool fromCamera = false, bool isUpdate = true}) async {

    if(isRemove) {
      _imageFiles = [];
    }else {

      if(fromCamera) {
        _imageFiles?.add(await ImagePicker().pickImage(source: ImageSource.camera));

      }else {
        _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      }

    }

    if(isUpdate) {
      notifyListeners();
    }
  }
  void removeImage(int index){
    _imageFiles?.removeAt(index);
    notifyListeners();
  }

}