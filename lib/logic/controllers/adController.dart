import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  late BannerAd bannerAd;
  InterstitialAd? interstitialAd;

  var isBannerAdLoaded = false.obs;
  var isInterstitialAdLoaded = false.obs;

  final String _bannerAdUnitId = kReleaseMode
      ? 'ca-app-pub-2737281186165752/7290750316'
      : 'ca-app-pub-3940256099942544/6300978111'; // Banner Test

  final String _interstitialAdUnitId = kReleaseMode
      ? 'ca-app-pub-2737281186165752/7087344996'
      : 'ca-app-pub-3940256099942544/1033173712'; // Interstitial Test

  @override
  void onInit() {
    super.onInit();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => isBannerAdLoaded.value = true,
        onAdFailedToLoad: (ad, error) {
          print("BannerAd failed to load: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdLoaded.value = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // تحميل جديد بعد الإغلاق
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd(); // تحميل جديد بعد الفشل
            },
          );
        },
        onAdFailedToLoad: (error) {
          print("Interstitial failed to load: $error");
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (isInterstitialAdLoaded.value && interstitialAd != null) {
      interstitialAd!.show();
      isInterstitialAdLoaded.value = false;
    } else {
      print("Interstitial ad not ready");
    }
  }

  @override
  void onClose() {
    bannerAd.dispose();
    interstitialAd?.dispose();
    super.onClose();
  }
}
