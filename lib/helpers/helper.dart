// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final x = authBox.read('useremail');

  if (x != null && x == 'usergust@gmail.com') return true;
  return false;
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




