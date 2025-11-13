import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/theme.dart';

class ShareWidget extends StatelessWidget {
  ShareWidget({Key? key}) : super(key: key);
  final controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          Container(
            height: 35.h,
            width: 40.w,
            padding: const EdgeInsets.all(6),
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: mainColor.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.share,
              size: 25,
              color: mainColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Share.share('https://play.google.com/store/apps/details?id=com.travelwin1.travelwin');
            },
            child:
            Text( "Share".tr,style: TextStyle(fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            ),
          ),
        ],
      );
  }
}
