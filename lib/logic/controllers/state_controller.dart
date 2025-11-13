import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../models/state_model.dart';
import '../../services/state_services.dart';

class StateController extends GetxController {
  var isLoading = true.obs;
  var stateList = <StateModels>[].obs;
//search
  var searchList = <StateModels>[].obs;
  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchStates();
    super.onInit();
  }

  void fetchStates() async {
    try {
      isLoading(true);
      var stateModels = await RemoteServices.fetchstates();
      if (stateModels != null) {
        stateList.value = stateModels;
      }
    } finally {
      isLoading(false);
    }
  }


  //Search Bar Logic

  void addSearchToList(String searchName) {
    print('------------------------');
    print(searchName);
    print('-----------3-------------');

    searchName = searchName.toLowerCase();

    searchList.value = stateList.where((search) {
      var searchTitle = search.name.toLowerCase();
      var searchPrice = search.nameAr.toString().toLowerCase();

      return searchTitle.contains(searchName) ||
          searchPrice.toString().contains(searchName);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList("");
  }
}