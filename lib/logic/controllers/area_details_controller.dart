// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../services/profile_services.dart';

class AreaDetailsController extends GetxController {
  AreaDetailsController({required this.selected});
  Rx<String> selected;
  Rx<int> selectedIndex = Rx(0);
  var isCategoryLoading = false.obs; // NEW: Track loading for the grid

  // Updated logic to fetch data when type changes
  void changeTheType(String type, int index, int stateId) async {
    selected.value = type;
    selectedIndex.value = index;
    
    try {
      isCategoryLoading(true);
      
      // 1. Get the ID of the selected category (e.g. Malls ID)
      var categoryId = statePlacesForState.value!.placesType![index].id;
      
      // 2. Fetch the data from API (Reset to page 1)
      var newPlaces = await RemoteServices.fetchStateAreaPlaces(
        stateId, 
        categoryId, 
        1
      );
      
      if (newPlaces != null) {
        statesPlaces.value = newPlaces;
        statesPlaces.refresh(); // Ensure grid updates
      }
    } catch (e) {
      print("Error switching category: $e");
    } finally {
      isCategoryLoading(false);
      update();
    }
  }
}
