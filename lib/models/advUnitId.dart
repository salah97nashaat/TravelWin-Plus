
class AdvUnitId{

  final String applovinSdkKey ;
  final String applovinRewardedAdUnitIdAndroid ;
  final String applovinRewardedAdUnitIdIos ;
  final String applovinBannerAdUnitIdAndroid ;
  final String applovinBannerAdUnitIdIos ;

  final String admobRewardedAdUnitIdAndroid ;
  final String admobRewardedAdUnitIdIos ;
  final String admobBannerAdUnitIdAndroid ;
  final String admobBannerAdUnitIdIos ;
  final String admobInterstitialAdUnitIdAndroid ;
  final String admobInterstitialAdUnitIdIos ;






  AdvUnitId({
      this.applovinSdkKey = "c_dxrgJpSAfOGTpUHsW9CMo_E0o7cg0LiFnMpEvtl42DqtkPAaOGoiBefAeRC_PU4JcHnMwqOVDqHdGIoKoUoS",
      this.applovinRewardedAdUnitIdAndroid =  "1a8e4eba30ca90cb",
      this.applovinRewardedAdUnitIdIos  = "IOS_REWARDED_AD_UNIT_ID",
      this.applovinBannerAdUnitIdAndroid  = "29d42ebee9210dc9",
      this.applovinBannerAdUnitIdIos  = "IOS_REWARDED_AD_UNIT_ID",

      this.admobBannerAdUnitIdAndroid  =  "ca-app-pub-9942567826980627/8773526213" ,
      this.admobRewardedAdUnitIdAndroid  = "ca-app-pub-9942567826980627/5939495224",

      this.admobBannerAdUnitIdIos  = "" ,
      this.admobRewardedAdUnitIdIos  = "ca-app-pub-8563961374772488/3049630084",

      this.admobInterstitialAdUnitIdAndroid  = "ca-app-pub-3940256099942544/1033173712",
      this.admobInterstitialAdUnitIdIos  = "ca-app-pub-3940256099942544/4411468910",


  });


  factory AdvUnitId.fromJson(Map<String, dynamic> json) {
    return AdvUnitId(
      applovinSdkKey: json["applovinSdkKey"],
      applovinRewardedAdUnitIdAndroid: json["applovinRewardedAdUnitIdAndroid"],
      applovinRewardedAdUnitIdIos: json["applovinRewardedAdUnitIdIos"],
      applovinBannerAdUnitIdAndroid: json["applovinBannerAdUnitIdAndroid"],
      applovinBannerAdUnitIdIos: json["applovinBannerAdUnitIdIos"],
      admobRewardedAdUnitIdAndroid: json["admobRewardedAdUnitIdAndroid"],
      admobRewardedAdUnitIdIos: json["admobRewardedAdUnitIdIos"],
      admobBannerAdUnitIdAndroid: json["admobBannerAdUnitIdAndroid"],
      admobBannerAdUnitIdIos: json["admobBannerAdUnitIdIos"],
      admobInterstitialAdUnitIdAndroid: json["admobInterstitialAdUnitIdAndroid"],
      admobInterstitialAdUnitIdIos: json["admobInterstitialAdUnitIdIos"],
    );

  }
//
}