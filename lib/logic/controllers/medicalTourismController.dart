import 'package:get/get.dart';

class MedicalTourismController extends GetxController {
  Rx<int> index = Rx(0);
  void changeIndex(newIndex) {
    index.value = newIndex;
    update();
  }
}
