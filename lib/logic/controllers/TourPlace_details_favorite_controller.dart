import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/logic/controllers/tourPlace_favorite_controller.dart';

import '../../services/sliderTourPlace_services.dart';

class TourPlaceDetailsFavoriteController extends GetxController {
  var isLoading = true.obs;
  var sliderList = <String>[].obs;
  var id = ''.obs;
  var name = ''.obs;
  var name_ar = ''.obs;
  var notes = ''.obs;
  var notes_ar = ''.obs;
  var lat = ''.obs;
  var longitude = ''.obs;
  var favorites_id = ''.obs;
  var displayUserId = ''.obs;
  final GetStorage authBox = GetStorage();
  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    //   print('name--------------'+argumentData[0]['name']);
    displayUserId.value = authBox.read('userid').toString();

    id.value = argumentData[0]['id'];
    name.value = argumentData[0]['name'];
    name_ar.value = argumentData[0]['name_ar'];
    notes.value = argumentData[0]['notes'];
    notes_ar.value = argumentData[0]['notes_ar'];
    lat.value = argumentData[0]['lat'];
    longitude.value = argumentData[0]['longitude'];
    favorites_id.value = argumentData[0]['favorites_id'];

    fetchSliderTourPlace(argumentData[0]['id']);

    super.onInit();
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

  void DeleteFavoriteTrip(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      RemoteServices.DeleteFavorite(id: id);
    } finally {
      isLoading(false);
      final TourPlaceFavoriteController tourPlaceFavoriteController =
          Get.put(TourPlaceFavoriteController());
      sleep(Duration(seconds: 1));
      tourPlaceFavoriteController.fetchTourPlaceFavorite();
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
