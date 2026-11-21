import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../helpers/adv/admob_banner.dart';
import 'package:travelwin/view/widgets/setting/delete_account_widget.dart';
import 'package:travelwin/view/widgets/setting/language_widget.dart';
// import 'package:travelwin/view/widgets/setting/about_widget.dart';
import 'package:travelwin/view/widgets/setting/logout_widget.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/theme.dart';
import '../../routes/routes.dart';
// import '../widgets/setting/delete_account_widget.dart';
// import '../widgets/setting/feedback_widget.dart';
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
      bottomNavigationBar: const AdmobBannerUi(),
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
          InkWell(
            onTap: () {
              Get.toNamed(Routes.travelAIAssistantScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFF4285F4).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4285F4).withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => googleGradient.createShader(bounds),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          Get.locale?.languageCode == 'ar' ? 'مساعد السفر الذكي ' : 'Travel AI ',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : mainColor,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => googleGradient.createShader(bounds),
                          child: Text(
                            '(AI Guide)',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16.sp, color: const Color(0xFF4285F4)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.currencyConverterScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.currency_exchange_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      Get.locale?.languageCode == 'ar' ? 'محول العملات ومصاريف السفر' : 'Currency & Travel Expenses',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : mainColor,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.emergencyGuideScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_outlined, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      Get.locale?.languageCode == 'ar' ? 'دليل الطوارئ والعبارات السياحية' : 'Emergency & Travel Guide',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode ? Colors.white : mainColor,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          // First Blog: TravelWin Trends
          InkWell(
            onTap: () async {
              const url = 'https://trends.travelwin1.com';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.locale?.languageCode == 'ar' ? 'مدونة تريندات وسياحة TravelWin' : 'TravelWin Trends Blog',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : mainColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'trends.travelwin1.com',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new_rounded, size: 16.sp, color: Colors.grey),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          // Second Blog: Official English Platform Blog
          InkWell(
            onTap: () async {
              const url = 'https://entravelwin.travelwin1.com/';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.language_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.locale?.languageCode == 'ar' ? 'مدونة TravelWin الإنجليزية' : 'TravelWin English Blog',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : mainColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'entravelwin.travelwin1.com',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new_rounded, size: 16.sp, color: Colors.grey),
                ],
              ),
            ),
          ),
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
