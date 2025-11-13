import 'package:get/get.dart';

class TourGuyController extends GetxController{
  Rx<bool> favorite=Rx(false);
  void changeFavorite(){
    favorite.value= !favorite.value;
    update();
  }
}