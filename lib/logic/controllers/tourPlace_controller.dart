import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:get/state_manager.dart';

import '../../models/TourPlace_model.dart';
import '../../services/tourPlace_services.dart';

class TourPlaceController extends GetxController {
  var isLoading = true.obs;
  var tourPlaceList = <TourPlace>[].obs;
  var id = <String>[].obs;
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    //id.value  =argumentData[0]['id'];stateid, String typeid
    fetchTourPlace(argumentData[0]['stateid'], argumentData[0]['typeid']);
    super.onInit();
  }

  void fetchTourPlace(String stateid, String typeid) async {
    try {
      isLoading(true);
      var tourPlace = await RemoteServices.getTourPlace(stateid, typeid);
      if (tourPlace != null) {
        tourPlaceList.value = tourPlace;
      }
    } finally {
      isLoading(false);
    }
  }

  //search
  var searchList = <TourPlace>[].obs;
  TextEditingController searchTextController = TextEditingController();

//Search Bar Logic

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();
    searchList.value = tourPlaceList.where((search) {
      var searchname = search.name.toLowerCase();
      var searchnameAr = search.nameAr.toString().toLowerCase();
      return searchname.contains(searchName) ||
          searchnameAr.toString().contains(searchName);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList("");
  }
}
