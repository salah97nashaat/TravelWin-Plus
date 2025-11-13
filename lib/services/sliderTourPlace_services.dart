import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/slider_model.dart';

class RemoteServices {
  static var client = http.Client();
  static Future<List<String>> getSliderTourPlace(String id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    // var response = await http
    //     .get(Uri.parse('http://host233.aya.sy/mobtech/get_sliders.php'));
    var response = await http.get(
        Uri.parse(
            'https://travelwin1.com/api/api/get_file_tourplace/?id=' + id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = response.body;
      return sliderModaleFromJson(jsonData);
    } else {
      return throw Exception("Failed to load product");
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
          "https://travelwin1.com/api/api/add_favourites/?type=place&type_id=" +
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
      String apiurl = "https://travelwin1.com/api/api/delete_favourites/?id=" +
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
          'The place has been removed from my favourites'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  static void AddReqPoint({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "https://travelwin1.com/api/api/add_reqpoint/?type=place&type_id=" +
              id +
              "&user_id=" +
              user_id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var responsebody = jsonDecode(response.body);

      if (responsebody['status'] == true) {
        // Get.snackbar(
        //   'successfully'.tr,
        //   'Edited successfully'.tr,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        // Get.snackbar(
        //   'Edit failed'.tr,
        //   responsebody['message'].toString().tr,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      }
    } finally {}
  }
}
