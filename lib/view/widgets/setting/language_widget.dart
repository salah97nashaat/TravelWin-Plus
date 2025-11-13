import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';

import '../text_utils.dart';

class LanguageWidget extends StatelessWidget {
  LanguageWidget({Key? key}) : super(key: key);

  final controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: Row(
              children: [
                Center(
                  child: Container(
                    height: 35.h,
                    width: 40.w,
                    padding: const EdgeInsets.all(6),
                    decoration:  BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.language,
                      size: 25,
                      color: mainColor,
                    ),
                  ),
                ),
                  const SizedBox(width: 20,),
                TextUtils(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  text: "Language".tr,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  underLine: TextDecoration.none,
                ),
              ],
            ),
          ),
          Container(
            // width: 120,
            height: 40.h,
            padding:   EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Get.isDarkMode ? Colors.white : mainColor,
                width: 2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconSize: 25.sp,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Get.isDarkMode ? Colors.white : mainColor,
                ),
                items: [
                  DropdownMenuItem(
                    child: Text(
                      english,
                      style:   TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    value: ene,
                  ),
                  DropdownMenuItem(
                    child: Text(
                      arabic,
                      style:   TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    value: ara,
                  ),

                ],
                value: controller.langLocal,
                onChanged: (value) {
                  controller.changeLanguage(value!);
                  Get.updateLocale(Locale(value));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
