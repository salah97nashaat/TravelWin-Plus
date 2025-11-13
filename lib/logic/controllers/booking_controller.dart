// import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:travelwin/language/en.dart';

class BookingController extends GetxController {
  Rx<String> form = Rx('');
  Rx<String> to = Rx('');
  Rx<String> days = Rx('');
  Rx<String> price = Rx('');
  Rx<bool> selected = Rx(false);

  void setValues(DateTime start, DateTime end, double ppd) {
    print(start);
    print(end);
    form.value = '${start.year}/${start.month}/${start.day}';
    to.value = '${end.year}/${end.month}/${end.day}';
    days.value = (end.difference(start).inDays + 1).toString();
    price.value = (ppd * (end.difference(start).inDays + 1)).toString();
    selected.value = true;
    update();
  }
}
