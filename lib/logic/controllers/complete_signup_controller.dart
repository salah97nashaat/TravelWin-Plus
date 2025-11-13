import 'package:get/get.dart';
// import 'package:get/state_manager.dart';
// import '../../services/slider_services.dart';

class CompleteSingupController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    // print("from  ******************************          :    "+argumentData[0]['name']);
    name.value = argumentData[0]['name'];
    email.value = argumentData[0]['email'];
    super.onInit();
  }
}
