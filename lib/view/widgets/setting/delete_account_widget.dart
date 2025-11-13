import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/utils/theme.dart';

import '../text_utils.dart';

class DeleteAccountWidget extends StatelessWidget {
  DeleteAccountWidget({Key? key}) : super(key: key);

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Get.defaultDialog(
            //   title: "DeleteAccount".tr,
            //   titleStyle:   TextStyle(
            //     fontSize: 18.sp,
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   middleText: 'DeleteAccountMessage'.tr,
            //   middleTextStyle:   TextStyle(
            //     fontSize: 18.sp,
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   backgroundColor: Colors.grey,
            //   radius: 10.r,
            //   textCancel: "No".tr,
            //   cancelTextColor: Colors.white,
            //   textConfirm: "Yes".tr,
            //   confirmTextColor: Colors.white,
            //   onCancel: () {
            //     Get.back();
            //   },
            //   onConfirm: () async{

            //     Get.back();

            Get.defaultDialog(
              title: "attention".tr,
              titleStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              middleText: 'accountWillBeDeletedIfNotLoginFor30Days'.tr,
              middleTextStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.grey,
              radius: 10.r,

              textConfirm: "Ok".tr,
              confirmTextColor: Colors.white,

              onConfirm: () {
                controller.signOutFromApp();
              },
              // onWillPop: () async {
              //   controller.signOutFromApp();
              //   return true;
              // },

              buttonColor: Get.isDarkMode ? pinkClr : mainColor,
            );

            //   },
            //   buttonColor: Get.isDarkMode ? pinkClr : mainColor,
            // );
          },
          splashColor: Get.isDarkMode ? Colors.pink : Colors.green[100],
          borderRadius: BorderRadius.circular(12.r),
          customBorder: const StadiumBorder(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: deleteAccountSettings,
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextUtils(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                text: "DeleteAccount".tr,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                underLine: TextDecoration.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
