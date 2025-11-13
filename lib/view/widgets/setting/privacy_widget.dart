import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../routes/routes.dart';

class PrivacyWidget extends StatelessWidget {
  PrivacyWidget({Key? key}) : super(key: key);
  final controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            height: 40.h,
            width: 45.w,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: mainColor.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.privacy_tip_outlined,
              color: mainColor,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PrivacyScreen);

            },
            child:
            Text( "Privacy".tr,style: TextStyle(fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            ),
          ),
        ],
      );
  }
}
