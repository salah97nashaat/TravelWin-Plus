import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/auth/auth_button.dart';
import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';
import 'package:travelwin/view/widgets/text_utils.dart';

// import '../../../helpers/helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final fromKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Future<bool> showExitPopup() async {
    //   if (isIos) return true;
    //   return await showDialog(
    //         //show confirm dialogue
    //         //the return value will be from "Yes" or "No" options
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title: Text('Exit App'.tr),
    //           content: Text('Do you want to exit an App?'.tr),
    //           actions: [
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
    //                 //  minimumSize: const Size(360, 50),
    //               ),
    //               // color: Get.isDarkMode ? darkGreyClr : mainColor,
    //               onPressed: () => Navigator.of(context).pop(false),
    //               //return false when click on "NO"
    //               child: Text("No".tr),
    //             ),
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
    //                 //  minimumSize: const Size(360, 50),
    //               ),
    //               onPressed: () => Navigator.of(context).pop(true),
    //               //return true when click on "Yes"
    //               child: Text('Yes'.tr),
    //             ),
    //           ],
    //         ),
    //       ) ??
    //       false; //if showDialouge had returned null, then return false
    // }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Form(
          key: fromKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: ListView(
              children: [
                Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/icon/logo.png',
                      height: 200.h,
                    )),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextUtils(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.normal,
                      text: "LOG".tr,
                      color: mainColor,
                      underLine: TextDecoration.none,
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    TextUtils(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.normal,
                      text: "IN".tr,
                      color: mainColor,
                      underLine: TextDecoration.none,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                AuthTextFromField(
                  controller: emailController,
                  obscureText: false,
                  validator: (value) {
                    if (!RegExp(validationEmail).hasMatch(value)) {
                      return 'Invalid email'.tr;
                    } else {
                      return null;
                    }
                  },
                  //
                  // Get.isDarkMode
                  //     ?   Icon(
                  //         Icons.email,
                  //         color: pinkClr,
                  //         size: 30.sp,
                  //       )
                  //     : Image.asset('assets/images/email.png'),
                  suffixIcon: const Text(""),
                  hintText: 'Email'.tr,
                  keyboardtypeText: 'text',
                ),
                SizedBox(
                  height: 18.h,
                ),
                GetBuilder<AuthController>(
                  builder: (_) {
                    return AuthTextFromField(
                      controller: passwordController,
                      obscureText: controller.isVisibilty ? false : true,
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'Password should be longer or equal to 6 characters'
                              .tr;
                        } else {
                          return null;
                        }
                      },

                      // Get.isDarkMode
                      //     ?   Icon(
                      //         Icons.lock,
                      //         color: pinkClr,
                      //         size: 30.sp,
                      //       )
                      //     : Image.asset('assets/images/lock.png'),
                      hintText: 'Password'.tr,
                      keyboardtypeText: 'text',
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.visibility();
                        },
                        icon: controller.isVisibilty
                            ? const Icon(
                                Icons.visibility_off,
                                color: mainColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: mainColor,
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgotPasswordScreen);
                      },
                      child: TextUtils(
                        text: 'Forgot Password?'.tr,
                        fontSize: 14.sp,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        underLine: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(
                  () => controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : GetBuilder<AuthController>(builder: (_) {
                          return AuthButton(
                            onPressed: () {
                              CircularProgressIndicator();
                              if (fromKey.currentState!.validate()) {
                                String email = emailController.text.trim();
                                String password = passwordController.text;

                                controller.logInUsingAPI(
                                    email: email, password: password);
                              }
                            },
                            text: "LOG IN".tr,
                          );
                        }),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(color: Colors.black, thickness: 0.5)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextUtils(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.normal,
                            text: 'OR'.tr,
                            color: Colors.black,
                            underLine: TextDecoration.none),
                      ),
                      Expanded(
                          child: Divider(color: Colors.black, thickness: 0.5)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                GetBuilder<AuthController>(builder: (_) {
                  return InkWell(
                    onTap: () {
                      controller.googleSinUpApp();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(25.r)),
                      width: 600,
                      height: 35.h,
                      child: Row(
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/images/Google Logo.png",
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Center(
                              child: Text(
                            'Sign up using Google'.tr,
                            style: TextStyle(color: mainColor),
                          )),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 15.h,
                ),
                if (Platform.isIOS)
                GetBuilder<AuthController>(builder: (_) {
                  return InkWell(
                    onTap: () {
                      controller.appleSignUpApp();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(25.r)),
                      width: 600,
                      height: 35.h,
                      child: Row(
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 30.w,
                            height: 30.h,
                            child: Image.asset(
                              "assets/images/apple.png",
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Center(
                              child: Text(
                            'Sign up using Apple'.tr,
                            style: TextStyle(color: mainColor),
                          )),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 25.h,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextUtils(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.normal,
                      text: "Don't have an Account?".tr,
                      color: darkGreyClr,
                      underLine: TextDecoration.none,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(Routes.signUpScreen);
                      },
                      child: TextUtils(
                        text: "Sign up".tr,
                        color: Get.isDarkMode ? darkGreyClr : mainColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.normal,
                        underLine: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                // ContainerUnder(
                //   text: "Don't have an Account?".tr,
                //   textType: "Sign up".tr,
                //   onPressed: () {
                //     Get.offNamed(Routes.signUpScreen);
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
