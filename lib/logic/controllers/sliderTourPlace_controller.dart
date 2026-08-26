import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';
import '../../services/sliderTourPlace_services.dart';

class SliderTourPlaceController extends GetxController {
  var isLoading = true.obs;
  var isLoadingFavorite = false.obs;
  var sliderList = <String>[].obs;
  var id = ''.obs;
  var name = ''.obs;
  var name_ar = ''.obs;
  var notes = ''.obs;
  var notes_ar = ''.obs;
  var lat = ''.obs;
  var longitude = ''.obs;
  var favorite = ''.obs;
  var displayUserId = ''.obs;
  final GetStorage authBox = GetStorage();
  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    //   print('name--------------'+argumentData[0]['name']);
    // MobileAds.instance.initialize();
    displayUserId.value = authBox.read('userid').toString();
    favorite.value = argumentData[0]['favorite'];
    id.value = argumentData[0]['id'];
    name.value = argumentData[0]['name'];
    name_ar.value = argumentData[0]['name_ar'];
    notes.value = argumentData[0]['notes'];
    notes_ar.value = argumentData[0]['notes_ar'];
    lat.value = argumentData[0]['lat'];
    longitude.value = argumentData[0]['longitude'];
    fetchSliderTourPlace(argumentData[0]['id']);

    super.onInit();
  }

  void change_favorite(String favorit) {
    favorite.value = favorit;
  }

  void fetchSliderTourPlace(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      var sliders = await RemoteServices.getSliderTourPlace(id);
      sliderList.value = sliders;
    } finally {
      isLoading(false);
    }
  }

  void AddFavoriteTrip(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      RemoteServices.AddFavorite(id: id);
    } finally {
      isLoading(false);
    }
  }

  //======================AddFavorite=================================
  void AddFavorite({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      isLoadingFavorite(true);
      String apiurl =
          "$baseUrlApi/add_favourites/?type=place&type_id=" +
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
          'Add to favourites'.tr,
          'The place has been added to favourites'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        favorite.value = responsebody['id'].toString();
      } else {
        Get.snackbar(
          'Edit failed'.tr,
          responsebody['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingFavorite(false);
    }
  }

  void DeleteFavoriteTrip(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      RemoteServices.DeleteFavorite(id: id);
    } finally {
      isLoading(false);
    }
  }

  void AddReqPoint(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      RemoteServices.AddReqPoint(id: id);
    } finally {
      isLoading(false);
    }
  }
}
