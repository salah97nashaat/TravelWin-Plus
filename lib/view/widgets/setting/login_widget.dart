import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/utils/theme.dart';

import '../../../routes/routes.dart';
import '../text_utils.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({Key? key}) : super(key: key);

  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(Routes.loginScreen);
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
                decoration:  BoxDecoration(
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
                text: "logIn".tr,
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
