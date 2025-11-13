import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../models/tripe_favorite_model.dart';
import '../../models/tripe_model.dart';
import '../../services/tripe_services.dart';

class TripeController extends GetxController {
  var isLoading = true.obs;
  var tripList = <Trip>[].obs;
  var favortestripList = <TripeFavoriteModel>[].obs;

  @override
  void onInit() {
    fetchTrips();
    fetchfavoritesTrips();
    super.onInit();
  }

  void fetchTrips() async {
    try {
      isLoading(true);
      var trips = await RemoteServices.fetchProducts();
      if (trips != null) {
        tripList.value = trips;
      }
    } finally {
      isLoading(false);
    }
  }
  void fetchfavoritesTrips() async {
    try {
      isLoading(true);
      var TripeFavoriteModel = await RemoteServices.FetchFavoritesTrip();
      if (TripeFavoriteModel != null) {
        favortestripList.value = TripeFavoriteModel;
      }
    } finally {
      isLoading(false);
    }
  }
  //search
  var searchList = <Trip>[].obs;
  TextEditingController searchTextController = TextEditingController();

//Search Bar Logic

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();
    searchList.value = tripList.where((search) {
      var searchTitle = search.from_ar.toLowerCase();
      var searchPrice = search.to_ar.toString().toLowerCase();
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
