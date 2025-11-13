import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/type_state_model.dart';
import '../../services/typestate_services.dart';

class TypeStateController extends GetxController {
  var isLoading = true.obs;
  var typeStateList = <TypeState>[].obs;
  var id = <String>[].obs;
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    //id.value  =argumentData[0]['id'];
    fetchTypeState(argumentData[0]['id']);
    super.onInit();
  }

  void fetchTypeState(String id) async {
    try {
      isLoading(true);
      var trips = await RemoteServices.getTypeState(id);
      if (trips != null) {
        typeStateList.value = trips;
      }
    } finally {
      isLoading(false);
    }
  }

  //search
  var searchList = <TypeState>[].obs;
  TextEditingController searchTextController = TextEditingController();

//Search Bar Logic

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();
    searchList.value = typeStateList.where((search) {
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
