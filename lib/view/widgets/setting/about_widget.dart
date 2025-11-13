import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../routes/routes.dart';

class AboutWidget extends StatelessWidget {
  AboutWidget({Key? key}) : super(key: key);
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
              Icons.info_outline,
              size: 25,
              color: mainColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.AboutScreen);

            },
            child:
            Text( "About App".tr,style: TextStyle(fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            ),
          ),
        ],
      );
  }
}
