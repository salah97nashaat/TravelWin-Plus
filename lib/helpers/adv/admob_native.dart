import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helper.dart';

class AdmobNativeUi extends StatefulWidget {
  final TemplateType templateType;
  final EdgeInsetsGeometry? margin;

  const AdmobNativeUi({
    Key? key,
    this.templateType = TemplateType.small,
    this.margin,
  }) : super(key: key);

  @override
  State<AdmobNativeUi> createState() => _AdmobNativeUiState();
}

class _AdmobNativeUiState extends State<AdmobNativeUi> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  String get nativeAdUnitId {
    if (isIos) {
      return "";
    }
    return advUnitId.admobNativeAdUnitIdAndroid.isNotEmpty
        ? advUnitId.admobNativeAdUnitIdAndroid
        : "ca-app-pub-3940256099942544/2247696110";
  }

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    if (nativeAdUnitId.isEmpty) return;

    _nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          p('AdMob Native Ad Failed to Load: $error');
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.templateType,
        mainBackgroundColor: Colors.white,
        cornerRadius: 16.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFF1E88E5),
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black87,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade700,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_nativeAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    final double height =
        widget.templateType == TemplateType.small ? 100.h : 330.h;

    return Container(
      margin: widget.margin ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: AdWidget(ad: _nativeAd!),
      ),
    );
  }
}
