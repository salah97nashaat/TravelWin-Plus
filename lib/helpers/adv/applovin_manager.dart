import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helper.dart';
import 'admob_manager.dart';

class AppLovinManager extends GetxController {
  // Create states

  bool _isProgrammaticBannerCreated = false;
  bool _isProgrammaticBannerShowing = false;

  // NOTE: Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initializePlugin() async {
    p("Initializing SDK...");

    var configuration = await AppLovinMAX.initialize(advUnitId.applovinSdkKey);
    if (configuration != null) {
      isApplovinInitialized = true;

      p("SDK Initialized: $configuration");
    }
  }

  String get bannerAdUnitId {
    return isIos
        ? advUnitId.applovinBannerAdUnitIdIos
        : advUnitId.applovinBannerAdUnitIdAndroid;
  }

  String get rewardedAdUnitId {
    return isIos
        ? advUnitId.applovinRewardedAdUnitIdIos
        : advUnitId.applovinRewardedAdUnitIdAndroid;
  }

  Future showBanner() async {
    if (!isApplovinInitialized) {
      p('SDK not initialized');
      await initializePlugin();
      await showBanner();
      return;
    }

    final String id = bannerAdUnitId;

    if (_isProgrammaticBannerShowing) {
      AppLovinMAX.hideBanner(id);
    } else {
      if (!_isProgrammaticBannerCreated) {
        //
        // Programmatic banner creation - banners are automatically sized to 320x50 on phones and 728x90 on tablets
        //
        AppLovinMAX.createBanner(id, AdViewPosition.bottomCenter);

        // Set banner background color to black - PLEASE USE HEX STRINGS ONLY
        AppLovinMAX.setBannerBackgroundColor(id, '#000000');

        _isProgrammaticBannerCreated = true;
      }

      AppLovinMAX.showBanner(id);
    }

    _isProgrammaticBannerShowing = !_isProgrammaticBannerShowing;
  }

  Future showRewardedAd(BuildContext context) async {
    final AdmobManager adManager = Get.put(AdmobManager());
    adManager.isLoadingRewardAd(true);

    try {
      if (!isApplovinInitialized) {
        p('SDK not initialized');
        await initializePlugin();
        await showRewardedAd(context);
        return;
      }

      final String id = rewardedAdUnitId;

      bool isReady = (await AppLovinMAX.isRewardedAdReady(id))!;

      if (isReady) {
        AppLovinMAX.showRewardedAd(id);
        p('isReady rewarded ad.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,..');
        await Future.delayed(const Duration(seconds: 2));
        await adManager.add_point_server(context);
      } else {
        AppLovinMAX.loadRewardedAd(id);
        p('Loading rewarded ad...');
        await Future.delayed(const Duration(seconds: 1));
        await showRewardedAd(context);
      }
      await Future.delayed(const Duration(seconds: 2));
      adManager.isLoadingRewardAd(false);
    } catch (e) {
      p("Ad showRewardedAd error: $e");
      adManager.isLoadingRewardAd(false);
    }
  }
}
