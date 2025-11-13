import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../../logic/controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';

import '../widgets/text_utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'.tr),
              content: Text('Do you want to exit an App?'.tr),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
                    //  minimumSize: const Size(360, 50),
                  ),
                  // color: Get.isDarkMode ? darkGreyClr : mainColor,
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text("No".tr),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
                    //  minimumSize: const Size(360, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'.tr),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
        onWillPop: showExitPopup,
        // onWillPop: showExitPopup, //call function on back button press
        child: UpgradeAlert(
          showIgnore: false,
          showLater: false,
          dialogStyle: UpgradeDialogStyle.material,
          shouldPopScope: () => false,
          upgrader: Upgrader(
            //debugDisplayAlways: true, // remove this in production
          ),
          child: Scaffold(
            body: Container(
              // color: Colors.black.withOpacity(0.2),
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120.h,
                  ),
                  // Container(
                  //   height: 50.h ,
                  //   width: 175.w,
                  //   decoration: BoxDecoration(
                  //     color: Colors.black.withOpacity(0.3),
                  //     borderRadius: BorderRadius.circular(5.r),
                  //   ),
                  //   child: Center(
                  //     child: TextUtils(
                  //       fontSize: 32.sp,
                  //       fontWeight: FontWeight.bold,
                  //       text: 'Welcome'.tr,
                  //       color: Colors.white,
                  //       underLine: TextDecoration.none,
                  //     ),
                  //   ),
                  // ),
                  Hero(tag: 'logo', child: Image.asset('assets/icon/logo.png')),
                  SizedBox(
                    height: 60.h,
                  ),
                  //
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: SizedBox(
                      width: 1.sw,
                      height: 35.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.loginScreen);
                        },
                        child: TextUtils(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                          text: 'Get Start'.tr,
                          color: Colors.white,
                          underLine: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 58.w),
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
                    height: 30.h,
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : GetBuilder<AuthController>(builder: (_) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.w),
                              child: SizedBox(
                                width: 1.sw,
                                height: 35.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                        side: BorderSide(color: mainColor)),
                                  ),
                                  onPressed: () {
                                    // final email ='usergust@gmail.com';
                                    // final password = '1234512345';
                                    //
                                    // controller.logInUsingAPI(
                                    //     email: email, password: password);
                                    Get.offAllNamed(Routes.mainScreen);
                                  },
                                  child: TextUtils(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.normal,
                                    text: "LoginGuest".tr,
                                    color: mainColor,
                                    underLine: TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          }),
                  ),
                  //
                  // SizedBox(
                  //   height: 20.h,
                  // ),
                  //
                  //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     TextUtils(
                  //       fontSize: 17.sp,
                  //       fontWeight: FontWeight.normal,
                  //       text: "Don't have an Account?".tr,
                  //       color: Colors.white,
                  //       underLine: TextDecoration.none,
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Get.toNamed(Routes.signUpScreen);
                  //       },
                  //       child: TextUtils(
                  //         text: 'Sign up'.tr,
                  //         color: Colors.white,
                  //         fontSize: 17.sp,
                  //         fontWeight: FontWeight.normal,
                  //         underLine: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
