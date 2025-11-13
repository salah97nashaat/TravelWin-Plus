import 'package:get/get.dart';

class PlaceDetailsController extends GetxController {
  Rx<int> selectedImage = Rx(0);
  Rx<double> stars = Rx(0);
  void changeImage(index) {
    selectedImage.value = index;
    update();
  }

  void changeRating(rate) {
    stars.value = rate;
    update();
  }
}
