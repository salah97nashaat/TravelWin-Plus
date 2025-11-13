// import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:travelwin/logic/controllers/tripe_controller.dart';
import '../../services/slider_services.dart';

class TripFavoriteDetailsController extends GetxController {
  var isLoading = true.obs;
  var sliderList = <String>[].obs;
  var sliderid = <String>[].obs;
  var id = ''.obs;
  var to = ''.obs;
  var from = ''.obs;
  var type = ''.obs;
  var to_ar = ''.obs;
  var from_ar = ''.obs;
  var type_ar = ''.obs;
  var date = ''.obs;
  var duration = ''.obs;
  var favorites_id = ''.obs;
  var displayUserId = ''.obs;
  final GetStorage authBox = GetStorage();
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    displayUserId.value = authBox.read('userid').toString();
    id.value = argumentData[0]['id'];
    to.value = argumentData[0]['to'];
    from.value = argumentData[0]['from'];
    type.value = argumentData[0]['type'];
    to_ar.value = argumentData[0]['to_ar'];
    from_ar.value = argumentData[0]['from_ar'];
    type_ar.value = argumentData[0]['type_ar'];
    date.value = argumentData[0]['date'];
    duration.value = argumentData[0]['duration'];
    favorites_id.value = argumentData[0]['favorites_id'];

    fetchProducts(argumentData[0]['id']);
    super.onInit();
  }

  void fetchProducts(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      var sliders = await RemoteServices.getSlider(id);
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
