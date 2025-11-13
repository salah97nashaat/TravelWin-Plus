import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:get/state_manager.dart';

// import '../../models/tripe_model.dart';
// import '../../services/tripe_services.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    nameController.text = argumentData[0]['name'].toString();
    genderController.text = argumentData[0]['gender'] ?? 'male'.tr;
    ageController.text = argumentData[0]['age'].toString();
    mobileController.text = argumentData[0]['mobile'].toString();
    emailController.text = argumentData[0]['email'].toString();
    locationController.text = argumentData[0]['location'].toString();
    //  nameController.text=argumentData[0]['name'];

    super.onInit();
  }
}
