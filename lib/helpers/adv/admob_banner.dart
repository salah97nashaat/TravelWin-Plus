import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helper.dart';


class AdmobBannerUi extends StatefulWidget {
  const AdmobBannerUi({Key? key}) : super(key: key);

  @override
  State<AdmobBannerUi> createState() => _AdmobBannerUiState();
}

class _AdmobBannerUiState extends State<AdmobBannerUi> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  String get bannerAdUnitId {
    if (isIos) {
      return advUnitId.admobBannerAdUnitIdIos.isNotEmpty
          ? advUnitId.admobBannerAdUnitIdIos
          : "ca-app-pub-3940256099942544/2934735716";
    } else {
      return advUnitId.admobBannerAdUnitIdAndroid.isNotEmpty
          ? advUnitId.admobBannerAdUnitIdAndroid
          : "ca-app-pub-3940256099942544/6300978111";
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          p('AdMob Banner Failed to Load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
