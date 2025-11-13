import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/theme.dart';

import '../text_utils.dart';

class LogOutWidget extends StatelessWidget {
  LogOutWidget({Key? key}) : super(key: key);

  final controller = Get.put(AuthController());
  final GetStorage authBox = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.defaultDialog(
              title: "Logout From App".tr,
              titleStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              middleText: 'Are you sure you need to logout'.tr,
              middleTextStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              radius: 10.r,
              textCancel: "No".tr,
              cancelTextColor: mainColor,
              textConfirm: "Yes".tr,
              confirmTextColor: Colors.white,
              onCancel: () {
                Get.back();
              },
              onConfirm: () {
                authBox.remove('token');
                controller.signOutFromApp();
              },
              buttonColor: Get.isDarkMode ? pinkClr : mainColor,
            );
          },
          splashColor: Get.isDarkMode ? Colors.pink : Colors.green[100],
          borderRadius: BorderRadius.circular(12.r),
          customBorder: const StadiumBorder(),
          child: Row(
            children: [
              Container(
                height: 35.h,
                width: 40.w,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.logout,
                  color: mainColor,
                  size: 25,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextUtils(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                text: "Logout".tr,
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

class DeleteAccount extends StatelessWidget {
  DeleteAccount({Key? key}) : super(key: key);

  final controller = Get.put(AuthController());
  final GetStorage authBox = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.defaultDialog(
              title: "Delete Account".tr,
              titleStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              middleText: 'Are you sure you need to delete account'.tr,
              middleTextStyle: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              radius: 10.r,
              textCancel: "No".tr,
              cancelTextColor: mainColor,
              textConfirm: "Yes".tr,
              confirmTextColor: Colors.white,
              onCancel: () {
                Get.back();
              },
              onConfirm: () {
                Get.defaultDialog(
                  title: "Delete Account".tr,
                  titleStyle: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  middleText: 'Are you sure you need to delete account'.tr,
                  middleTextStyle: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.white,
                  radius: 10.r,
                  textCancel: "No".tr,
                  cancelTextColor: mainColor,
                  textConfirm: "Yes".tr,
                  confirmTextColor: Colors.white,
                  onCancel: () {
                    Get.back();
                  },
                  onConfirm: () {
                    RemoteServices.deleteAccount();
                  },
                  buttonColor: Get.isDarkMode ? pinkClr : mainColor,
                );
              },
              buttonColor: Get.isDarkMode ? pinkClr : mainColor,
            );
          },
          splashColor: Get.isDarkMode ? Colors.pink : Colors.green[100],
          borderRadius: BorderRadius.circular(12.r),
          customBorder: const StadiumBorder(),
          child: Row(
            children: [
              Container(
                height: 35.h,
                width: 40.w,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.delete,
                  color: mainColor,
                  size: 25,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextUtils(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                text: "Delete Account".tr,
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
