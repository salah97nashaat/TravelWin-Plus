import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DutyPharmaciesScreen extends StatefulWidget {
  const DutyPharmaciesScreen({Key? key}) : super(key: key);

  @override
  State<DutyPharmaciesScreen> createState() => _DutyPharmaciesScreenState();
}

class _DutyPharmaciesScreenState extends State<DutyPharmaciesScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0.0;

  static const String dutyPharmaciesUrl = "https://www.eczaneler.gen.tr/";

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
            // Handle direct phone calls or map directions from within the pharmacy listings
            if (request.url.startsWith('tel:')) {
              final uri = Uri.parse(request.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
              return NavigationDecision.prevent;
            }
            if (request.url.contains('maps.google.com') ||
                request.url.contains('goo.gl/maps') ||
                request.url.startsWith('geo:')) {
              final uri = Uri.parse(request.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Silently handle transient connection errors
          },
        ),
      )
      ..loadRequest(Uri.parse(dutyPharmaciesUrl));
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_pharmacy_rounded,
                  color: const Color(0xFF10B981),
                  size: 18.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  isAr ? 'الصيدليات المناوبة' : 'Duty Pharmacies',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              isAr ? 'تركيا - تحديث يومي مباشر' : 'Turkey - Live Daily Directory',
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
              color: const Color(0xFF10B981),
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
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                minHeight: 3.h,
              ),
            ),
        ],
      ),
    );
  }
}
