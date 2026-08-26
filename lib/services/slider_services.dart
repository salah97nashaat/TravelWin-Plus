import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';
import '../logic/controllers/slider_controller.dart';
import '../logic/controllers/tripe_controller.dart';
import '../models/slider_model.dart';

class RemoteServices {
  final SliderController sliderController = Get.put(SliderController());

  static var client = http.Client();
  static Future<List<String>> getSlider(String id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    // var response = await http
    //     .get(Uri.parse('http://host233.aya.sy/mobtech/get_sliders.php'));
    var response = await http.get(
        Uri.parse('$baseUrlApi/get_file_tripe2/?id=' + id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return sliderModaleFromJson(jsonData);
    } else {
      return throw Exception("Failed to load product");
    }
  }

  static Future<List<String>> getSliderAdvertisemen() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    // var response = await http
    //     .get(Uri.parse('http://host233.aya.sy/mobtech/get_sliders.php'));
    var response = await http.get(
        Uri.parse(
            '$baseUrlApi/get_file_advertisement/?id=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      var jsonData = response.body;
      return sliderModaleFromJson(jsonData);
    } else {
      return [];
      // return throw Exception("Failed to load product");
    }
  }

  //======================AddFavorite=================================
  static void AddFavorite({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "$baseUrlApi/add_favourites/?type=trip&type_id=" +
              id +
              "&user_id=" +
              user_id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      if (responsebody['status'] == true) {
        Get.snackbar(
          'successfully'.tr,
          'Edited successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Edit failed'.tr,
          responsebody['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {}
  }

  //======================DeleteFavorite=================================
  static void DeleteFavorite({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    try {
      String apiurl = "$baseUrlApi/delete_favourites/?id=" +
          id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      if (responsebody['status'] == true) {
        Get.snackbar(
          'Delete from favourites'.tr,
          'The flight has been removed from your favourites'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        final TripeController tripeController = Get.put(TripeController());
        //  sleep(Duration(seconds:5));
        tripeController.fetchfavoritesTrips();
        //   Get.back();
      } else {
        Get.snackbar(
          'Delete failed'.tr,
          responsebody['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {}
  }

  //======================AddFavorite=================================
  static void AddReqPoint({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "$baseUrlApi/add_reqpoint/?type=trip&type_id=" +
              id +
              "&user_id=" +
              user_id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      jsonDecode(response.body);

      // if (responsebody['status'] == true) {
      //   Get.snackbar(
      //     'successfully'.tr,
      //     'Edited successfully'.tr,
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //   );
      // } else {
      //   Get.snackbar(
      //     'Edit failed'.tr,
      //     responsebody['message'].toString().tr,
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //   );
      // }
    } finally {}
  }
}
