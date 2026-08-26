import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:travelwin/utils/my_string.dart';

class WheelController extends GetxController {
  final selected = BehaviorSubject<int>();
  List<int> items = [2, 4, 8, 10, 15,20,25];


  @override
  void onInit() async {
    selected.add(Fortune.randomInt(0, items.length));

    super.onInit();
  }
  void check_wheel(String point) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      String apiurl = "$baseUrlApi/check_wheel?user_id="+ user_id+"&point="+point; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {

        Get.snackbar(
          'youve earned point'.tr,
          'Congratulations, youve earned '.tr+responsebody['message'].toString()+' points... Try again in 24 hours'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {

        Get.snackbar(
          'failed'.tr,
          //responsebody['message'],
          'You should try the next day'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
    }
  }


}
