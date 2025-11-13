import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travelwin/helpers/adv/applovin_manager.dart';
import '../helper.dart';


class ApplovinBannerUi extends StatefulWidget {
  const ApplovinBannerUi({Key? key}) : super(key: key);

  @override
  State<ApplovinBannerUi> createState() => _ApplovinBannerUiState();
}

class _ApplovinBannerUiState extends State<ApplovinBannerUi> {
  AppLovinManager appLovinManager = AppLovinManager();
  bool isInitialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      // if (!isRelease) {
      //   return;
      // }

    if (!isApplovinInitialized){
       await appLovinManager.initializePlugin();
    }

    isInitialized = isApplovinInitialized;

    if (context.mounted) setState(() {});});

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 50.h,


      child:

    // !isRelease || !isInitialized ?
    //   const SizedBox()
    //       :
      MaxAdView(
          adUnitId: appLovinManager.bannerAdUnitId,
          adFormat: AdFormat.banner,
          listener: AdViewAdListener(onAdLoadedCallback: (ad) {
            p('Banner widget ad loaded from ${ad.networkName}');
          }, onAdLoadFailedCallback: (adUnitId, error) {
            p('Banner widget ad failed to load with error code ${error.code} and message: ${error.message}');
          }, onAdClickedCallback: (ad) {
            p('Banner widget ad clicked');
          }, onAdExpandedCallback: (ad) {
            p('Banner widget ad expanded');
          }, onAdCollapsedCallback: (ad) {
            p('Banner widget ad collapsed');
          }, onAdRevenuePaidCallback: (ad) {
            p('Banner widget ad revenue paid: ${ad.revenue}');
          })),
    );
  }
}
