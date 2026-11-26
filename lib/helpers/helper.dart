import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/advUnitId.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/routes.dart';
// import '../utils/theme.dart';

// import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}

AdvUnitId advUnitId = AdvUnitId();
bool isApplovinInitialized = false;

bool get isLogin {
  final GetStorage authBox = GetStorage();
  return authBox.read('auth') ?? false;
}

bool get isGustUser {
  final GetStorage authBox = GetStorage();
  final token = authBox.read('token');
  if (token == null || token.toString() == 'null' || token.toString().trim().isEmpty) {
    return true;
  }
  final x = authBox.read('useremail');
  if (x != null && x == 'usergust@gmail.com') return true;
  return false;
}

bool get isGuestUser => isGustUser;

bool checkLogin({String? title, String? message}) {
  if (isGuestUser) {
    showGuestLoginDialog(title: title, message: message);
    return false;
  }
  return true;
}

void showGuestLoginDialog({String? title, String? message}) {
  final isAr = Get.locale?.languageCode == 'ar' || (Get.locale == null);
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF2563EB),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? (isAr ? "تسجيل الدخول مطلوب" : "Login Required"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ??
                  (isAr
                      ? "يرجى تسجيل الدخول أو إنشاء حساب للاستفادة من هذه الميزة والتواصل بحرية."
                      : "Please sign in or create an account to access this feature."),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.loginScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isAr ? "تسجيل الدخول / إنشاء حساب 🚀" : "Sign In / Register 🚀",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  isAr ? "المتابعة كزائر" : "Continue as Guest",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//  Future<bool> showMessageIfGust(BuildContext context) async {
//   if (isGustUser) {
//
//       final bool isYes = await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//
//               title: Text('attention'.tr, textAlign: TextAlign.center,style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold)),
//               content: Text('gustMessage'.tr , textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp),),
//               actions: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
//                     //  minimumSize: const Size(360, 50),
//                   ),
//                   // color: Get.isDarkMode ? darkGreyClr : mainColor,
//                   onPressed: () => Navigator.of(context).pop(false),
//                   //return false when click on "NO"
//                   child: Text("No".tr),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
//                     //  minimumSize: const Size(360, 50),
//                   ),
//                   onPressed: () => Navigator.of(context).pop(true),
//                   //return true when click on "Yes"
//                   child: Text('Yes'.tr),
//                 ),
//               ],
//             ),
//           ) ??
//           false;
//
//       if (isYes) {
//         Get.toNamed(Routes.loginScreen);
//       }
//
//       return true;
//
//
//   }
//   return false;
//
// }

bool get showLoginScreenIfNotLogin {
  if (!isLogin) {
    Get.toNamed(Routes.loginScreen);
    return true;
  }
  return false;
}

Future launchURL(String urlX) async {
  Uri? url = Uri.tryParse(urlX);
  p('------------------------');
  p(url);
  if (url == null) return;

  try {
    if (await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $urlX';
  } catch (err) {
    print('err $err');
  }
}

void openWhatsApp(String text, String phone) {
  launchURL('https://wa.me/$phone/?text=$text');
}

bool get isRelease => kReleaseMode;
bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

///--------------------------------------
void p(dynamic x) {
  if (kDebugMode) print(x);
}
///--------------------------------------




