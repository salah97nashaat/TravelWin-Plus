import 'dart:io';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
class AdsManger {
  static bool testAd = true;
  static String get rewardedAdID {
    if (testAd == true) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9942567826980627/2201713853';
    } else {
      throw UnsupportedError("un supurt");
    }
  }
}
