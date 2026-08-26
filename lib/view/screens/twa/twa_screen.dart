import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TWAScreen extends StatelessWidget {
  const TWAScreen({super.key});

  final String twaWebUrl = "https://travelwin1.com/twa.html";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Immersive Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/twa-bg.jpg', // Use your adventure background
              fit: BoxFit.cover,
            ),
          ),
          // 2. Dark Gradient Overlay for Readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // 3. Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo or Icon
                  Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Icon(Icons.explore_rounded,
                        color: Colors.white, size: 50.sp),
                  ),
                  SizedBox(height: 20.h),
                  // Title
                  Text(
                    "Travel Win".tr,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        letterSpacing: 2),
                  ),
                  Text(
                    "WILD ADVENTURES".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Slogan
                  Text(
                    "We Create Adventures .. We Preserve Memories".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // THE ACTION BUTTON
                  _buildMainButton(context),
                  SizedBox(height: 20.h),
                  Text(
                    "Join our community and explore the wild".tr,
                    style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRedirectDialog(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF16a34a), Color(0xFF064e3b)], // Adventure Green
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Go to Official Website".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10.w),
            const Icon(Icons.open_in_new_rounded,
                color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // --- THE REDIRECT LOGIC ---
  void _showRedirectDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            Icon(Icons.info_outline_rounded, size: 40.sp, color: Colors.orange),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "External Link".tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              "You are now leaving the app to visit our official TWA page. Do you want to continue?"
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Stay Here".tr,
                style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16a34a),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Get.back(); // Close dialog
              final Uri url = Uri.parse(twaWebUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Text("Continue".tr,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
