// import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AreaDetailsController extends GetxController {
  AreaDetailsController({required this.selected});
  Rx<String> selected;
  Rx<int> selectedIndex = Rx(0);
  void changeTheType(String type, int index) {
    selected.value = type;
    selectedIndex.value = index;
    update();
  }
}
