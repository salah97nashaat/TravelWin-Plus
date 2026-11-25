import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FlightsScreen extends StatefulWidget {
  final String? customUrl;

  const FlightsScreen({Key? key, this.customUrl}) : super(key: key);

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0.0;

  // TravelWin White Label Flights (Domain: flights.travelwin1.com, Marker: 811370)
  static const String whiteLabelUrl = "https://flights.travelwin1.com";

  String get _flightSearchUrl {
    if (widget.customUrl != null && widget.customUrl!.isNotEmpty) {
      return widget.customUrl!;
    }
    final lang = Get.locale?.languageCode ?? 'ar';
    return '$whiteLabelUrl/?locale=$lang';
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _progress = progress / 100.0;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('tel:') || request.url.startsWith('mailto:')) {
              final uri = Uri.parse(request.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Silently handle transient network glitches
          },
        ),
      )
      ..loadRequest(Uri.parse(_flightSearchUrl));
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF1E293B),
            size: 20.sp,
          ),
          onPressed: () async {
            if (await _controller.canGoBack()) {
              await _controller.goBack();
            } else {
              Get.back();
            }
          },
        ),
        title: Column(
          children: [
            Text(
              isAr ? 'حجز رحلات الطيران' : 'Flight Booking',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isAr ? 'مقارنة أفضل الأسعار عالمياً' : 'Best Global Flight Rates',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: const Color(0xFF2563EB),
              size: 22.sp,
            ),
            tooltip: isAr ? 'إعادة تحميل' : 'Reload',
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: const Color(0xFF64748B),
              size: 22.sp,
            ),
            tooltip: isAr ? 'إغلاق' : 'Close',
            onPressed: () => Get.back(),
          ),
        ],
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                minHeight: 3.h,
              ),
            ),
        ],
      ),
    );
  }
}
