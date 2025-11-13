import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/takit_model.dart';
// import '../models/tripe_favorite_model.dart';
// import '../models/tripe_model.dart';
// import '../routes/routes.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<TicketModels>?> fetchTicket() async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    var response = await client.get(
        Uri.parse(
            'https://travelwin1.com/api/api/get_ticket?user_id=' + user_id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      return ticketModelsFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<TicketModels>?> AddTicket() async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    var response = await client.get(
        Uri.parse(
            'https://travelwin1.com/api/api/add_ticket?user_id=' + user_id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);

      if (responsebody['status'] == true) {
        //  Get.toNamed(Routes.PointScreen);
        //  fetchTicket();
        Get.snackbar(
          'buying a ticket'.tr,
          responsebody['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else
        Get.snackbar(
          'buying a ticket'.tr,
          responsebody['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
    } else {
      //show error message
      return null;
    }
    return null;
  }
}
