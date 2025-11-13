import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
// import 'package:travelwin/models/Points.dart';
import 'package:travelwin/utils/my_string.dart';
import '../../services/slider_services.dart';
import '../../services/profile_services.dart' as pro;
import '../helper.dart';

/// com.travelwin1.travelwin

class AdmobManager extends GetxController {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int credit = 0;
  var count = 0.obs;
  var Withdrawaldate = ''.obs;
  var type = ''.obs;
  var slideradvertisementList = <String>[].obs;
  var isLoading = true.obs;
  var isLoadingRewardAd = false.obs;
  final GetStorage authBox = GetStorage();
  @override
  void onInit() {
    //count.value = authBox.read('count');
    get_point();
    GetWithdrawaldate();
    fetchSliderAdvertisemen();
    super.onInit();
  }

  String get bannerAdUnitId {
    if (isRelease) {
      return isIos
          ? advUnitId.admobBannerAdUnitIdIos
          : advUnitId.admobBannerAdUnitIdAndroid;
    } else {
      return isIos
          ? "ca-app-pub-3940256099942544/2934735716"
          : "ca-app-pub-3940256099942544/6300978111";
    }
  }

  String get rewardedAdUnitId {
    if (isRelease) {
      return isIos
          ? advUnitId.admobRewardedAdUnitIdIos
          : advUnitId.admobRewardedAdUnitIdAndroid;
    } else {
      return isIos
          ? "ca-app-pub-3940256099942544/1712485313"
          : "ca-app-pub-3940256099942544/1712485313";
    }
  }

  String get interstitialAdUnitId {
    return isIos
        ? advUnitId.admobInterstitialAdUnitIdIos
        : advUnitId.admobInterstitialAdUnitIdAndroid;
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    _bannerAd?.load();
  }

  Future loadRewardedAd(BuildContext context) async {
    isLoadingRewardAd(true);
    await RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) async {
          _rewardedAd = ad;
          isLoadingRewardAd(false);
          await showRewardedAd(context);
          p('RewardedAd loaded.===============');
        }, onAdFailedToLoad: (LoadAdError error) async {
          p('RewardedAd failed to load=============: $error');

          _rewardedAd = null;
          await Future.delayed(Duration(seconds: 3));
          await loadRewardedAd(context);
          // isLoadingRewardAd(false);
        }));
  }

  void loadInterstitialAd() {
    String interstitialAdId = interstitialAdUnitId;

    InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                ad.dispose();
                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            p('InterstitialAd failed to load: $error');
          },
        ));
  }

  Future addAds(bool interstitial, bool bannerAd, bool rewardedAd) async {
    if (interstitial) {
      //loadInterstitialAd();
    }

    if (bannerAd) {
      //loadBannerAd();
    }

    if (rewardedAd) {
      //await loadRewardedAd();
    }
  }

  void showInterstitial() {
    _interstitialAd?.show();
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  Future showRewardedAd(BuildContext context) async {
    // if (!isRelease)  return ;

    if (_rewardedAd == null) {
      p("Ad _rewardedAd == null");
      // final AppLovinManager appLovinManager = Get.put(AppLovinManager());
      // await appLovinManager.showRewardedAd(context);

      await loadRewardedAd(context);
      return;
    }
    p("Ad _rewardedAd != null");

    // if (isLoadingRewardAd.value) return;

    try {
      //isLoadingRewardAd(true);

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedAd ad) async {},
          onAdDismissedFullScreenContent: (RewardedAd ad) async {
            await ad.dispose();

            ///await Future.delayed(Duration(seconds: 3));
            ///await loadRewardedAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedAd ad, AdError error) async {
            await ad.dispose();
            // await Future.delayed(Duration(seconds: 3));
            // await loadRewardedAd();
            p("Ad onAdFailedToShowFullScreenContent=======/////=========----------==: $error");
            p("Ad onAdFailedToShowFullScreenContent=======/////=========----------==: ");
            p("Ad onAdFailedToShowFullScreenContent=======/////=========----------==: ");
            // isLoadingRewardAd(false);
          });

      // await _rewardedAd!.setImmersiveMode(true);
      await _rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
        p("Ad onUserEarnedReward: ${reward.amount} ${reward.type}");
        // count.value +=1;
        //
        // authBox.write("count",  count.value);
        // print("${reward.amount} ${reward.type}");
        //
        // update();
        await add_point_server(context);
        // isLoadingRewardAd(false);
      });
    } catch (e) {
      p("Ad showRewardedAd error: $e");
      // isLoadingRewardAd(false);
    }
  }

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  void get_point() async {
    try {
      String token = authBox.read('token').toString();
      String user_id = authBox.read('userid').toString();
      String apiurl = "https://travelwin1.com/api/api/get_point?user_id=" +
          user_id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responsebody = jsonDecode(response.body);

      if (responsebody['status'] == true) {
        count.value = responsebody['value'];
        type.value = responsebody['type'];

        update();

        // Get.back();
      } else {}
    } finally {}
  }

  Future add_point_server(BuildContext context) async {
    try {
      if (showLoginScreenIfNotLogin) {
        return;
      }

      // if (await showMessageIfGust(context)){
      //   return ;
      // }
      String token = authBox.read('token').toString();
      // String user_id = authBox.read('userid').toString();
      String apiurl = baseUrl + '/points'; //api url
      var response = await http.post(Uri.parse(apiurl), body: {
        'type': 'ads'
      }, headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responsebody = jsonDecode(response.body);
      print(responsebody);
      if (responsebody['status'] == true) {
        points.value = (await pro.RemoteServices.fetchPoint())!;
        //count.value =responsebody['value'];

        update();

        // Get.back();
      } else {}
    } finally {}
  }

  GetWithdrawaldate() async {
    final GetStorage authBox = GetStorage();
    String token = authBox.read('token').toString();
    String apiurl =
        "https://travelwin1.com/api/api/get_withdrawal_date"; //api url
    var response = await http.get(Uri.parse(apiurl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      Withdrawaldate.value = responsebody['body'].toString();
      update();
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
}
