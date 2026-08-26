import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/utils/my_string.dart';
import '../../services/slider_services.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../utils/adsManger.dart';

class SliderController extends GetxController {
  RewardedAd? rewardedAd;
  bool isRewardedAdRedAd = false;
  int credit = 0;
  var isLoading = true.obs;
  var isLoadingFavorite = false.obs;
  var sliderList = <String>[].obs;
  var slideradvertisementList = <String>[].obs;
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
  var displayUserId = ''.obs;
  var favorite = ''.obs;
  final GetStorage authBox = GetStorage();
  dynamic argumentData = Get.arguments;
  //
  // @override
  // void onInit() {
  //
  //    //initAds();
  //    rewardedAdLoading();
  //   displayUserId.value = authBox.read('userid').toString();
  //   id.value = argumentData[0]['id'];
  //   to.value = argumentData[0]['to'];
  //   from.value = argumentData[0]['from'];
  //   type.value = argumentData[0]['type'];
  //   to_ar.value = argumentData[0]['to_ar'];
  //   from_ar.value = argumentData[0]['from_ar'];
  //   type_ar.value = argumentData[0]['type_ar'];
  //   date.value = argumentData[0]['date'];
  //   duration.value = argumentData[0]['duration'];
  //   favorite.value = argumentData[0]['favorite'];
  //
  //
  //   fetchProducts(argumentData[0]['id']);
  //   update();
  //   super.onInit();
  // }

  Future<InitializationStatus> initAds() {
    return MobileAds.instance.initialize();
  }

  rewardedAdLoading() {
    RewardedAd.load(
        adUnitId: AdsManger.rewardedAdID,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            isRewardedAdRedAd = true;
            rewardedAdLoading();
          });
          update();
          print('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          this.rewardedAd = ad;
        }, onAdFailedToLoad: (error) {
          print(error);
          rewardedAd = null;
        }));
  }

  showAd() {
    rewardedAd!.show(
        //onUserEarnedReward:(AdWithoutView ad, RewardItem reward)
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardedItem) {
      credit = rewardedItem.amount.toInt();
      update();
    });
  }

  void change_favorite(String favorit) {
    favorite.value = favorit;
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

  void fetchSliderAdvertisemen() async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      var sliders = await RemoteServices.getSliderAdvertisemen();
      slideradvertisementList.value = sliders;
    } finally {
      isLoading(false);
    }
  }

  void AddFavoriteTrip(String id) async {
    try {
      // sliderid.value=argumentData[0]['id'];
      isLoading(true);
      RemoteServices.AddFavorite(id: id);
      favorite.value = authBox.read('favoritrid').toString();
    } finally {
      isLoading(false);
    }
  }

  void AddFavorite({
    required String id,
  }) async {
    final GetStorage authBox = GetStorage();

    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    try {
      isLoadingFavorite(true);
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
          'Add to favourites'.tr,
          'The flight has been added to favourites'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        favorite.value = responsebody['id'].toString();
      } else {
        Get.snackbar(
          'failed'.tr,
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
