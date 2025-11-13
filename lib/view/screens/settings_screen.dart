import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/view/widgets/setting/delete_account_widget.dart';
// import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/view/widgets/setting/dark_mode_widget.dart';
import 'package:travelwin/view/widgets/setting/language_widget.dart';
import 'package:travelwin/view/widgets/setting/logout_widget.dart';
// import '../../helpers/helper.dart';
import '../../logic/controllers/settings_controller.dart';
// import '../../routes/routes.dart';
import '../widgets/setting/about_widget.dart';
// import '../widgets/setting/delete_account_widget.dart';
import '../widgets/setting/feedback_widget.dart';
import '../widgets/setting/login_widget.dart';
// import '../widgets/setting/privacy_widget.dart';
import '../widgets/setting/share_widget.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  final controller = Get.put(SettingController());
  final GetStorage authBox = GetStorage();

  @override
  Widget build(BuildContext context) {
    String token = authBox.read('token').toString();
    print(token);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings".tr,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset('assets/images/back.svg'))),
          SizedBox(
            width: 25.w,
          ),
        ],
        // leading: IconButton(
        //   onPressed: () { Get.offAllNamed(Routes.mainScreen);           },
        //   icon: Icon(Icons.home),
        // ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          //   ProfileWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Divider(color: Colors.grey),
          ),
          const SizedBox(
            height: 10,
          ),

          // if (isLogin && !isGustUser)   Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(6),
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: accountSettings,
          //       ),
          //       child: const Icon(
          //         Icons.person_pin_rounded,
          //         color: Colors.white,
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 20,
          //     ),
          //     new GestureDetector(
          //       onTap: () {
          //         Get.toNamed(Routes.ProfileScreen);
          //       },
          //       child: Text(
          //         "Profile".tr,
          //         style: TextStyle(
          //           fontSize: 18.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Get.isDarkMode ? Colors.white : Colors.black,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // DarkModeWidget(),
          // const SizedBox(
          //   height: 20,
          // ),
          LanguageWidget(),
          SizedBox(
            height: 15.h,
          ),
          FeedbackWidget(),
          SizedBox(
            height: 15.h,
          ),
          AboutWidget(),
          SizedBox(
            height: 15.h,
          ),
          ShareWidget(),
          //  SizedBox(
          //   height: 25.h,
          // ),
          // PrivacyWidget(),
          SizedBox(
            height: 15.h,
          ),

          // if (isLogin && !isGustUser) DeleteAccountWidget(),
          //  SizedBox(
          //   height: 25.h,
          // ),
          token.toString() != 'null' ? LogOutWidget() : LoginWidget(),
          SizedBox(
            height: 15.h,
          ),
          token.toString() != 'null' ? DeleteAccountWidget() : Container()
        ],
      ),
    );
  }
}
