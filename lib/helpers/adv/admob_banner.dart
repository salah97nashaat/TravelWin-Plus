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

    BannerAd? banner;

    String get bannerAdUnitId  {
       if (isRelease){
        return isIos ? advUnitId.admobBannerAdUnitIdIos :advUnitId.admobBannerAdUnitIdAndroid;
     }else{
       return isIos ? "ca-app-pub-3940256099942544/2934735716" :  "ca-app-pub-3940256099942544/6300978111";
     }
    }



  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      if (isIos){//!isRelease ||
        banner = null;
        return;
      }

      banner =
      BannerAd(
        listener: BannerAdListener(
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            p('============onAdLoaded ===========error: $error');
          },
          onAdLoaded: (_) {
            p('============onAdLoaded===========ok');
          },
          onAdOpened: (Ad ad) =>
              p(
                  '-------------------------------Ad opened.-------------------------------------------'),
        ),
        size: AdSize.banner,
        adUnitId:   bannerAdUnitId,
        request: AdRequest(),
      )..load();

     if (context.mounted) setState(() {});

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: 50.h,
      child:
      banner==null ?
      const SizedBox() :
      AdWidget(
        ad: banner!,
      ),
    );
  }
}
