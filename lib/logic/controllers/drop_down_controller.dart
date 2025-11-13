import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

class DropDownController extends GetxController {
  DropDownController({required this.value});
  Rx<String> value;
  void changValue(String newValue) {
    value.value = newValue;
    update();
  }
}
