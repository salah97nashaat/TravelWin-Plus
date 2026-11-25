import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/theme.dart';
import '../../logic/controllers/auth_controller.dart';
import '../../routes/routes.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/my_string.dart';
class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        child: ListView(
          children: <Widget>[

            Obx(() {
              final incomplete = isUserProfileIncomplete();
              return ListTile(
                title: Row(
                  children: [
                    Text(
                      "Profile".tr,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    if (incomplete) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          Get.locale?.languageCode == 'ar' ? 'غير مكتمل' : 'Incomplete',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.person_pin_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                    if (incomplete)
                      Positioned(
                        right: -1,
                        top: -1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () async {
                  Get.toNamed(Routes.ProfileScreen);
                },
              );
            }),
            ListTile(
              title: Row(
                children: [
                  Text(
                    Get.locale?.languageCode == 'ar' ? "مساعد السفر الذكي " : "Smart Travel Assistant ",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => googleGradient.createShader(bounds),
                    child: const Text(
                      "(AI Guide)",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              leading: ShaderMask(
                shaderCallback: (bounds) => googleGradient.createShader(bounds),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              onTap: () async {
                Get.toNamed(Routes.travelAIAssistantScreen);
              },
            ),
            ListTile(
              title: Text(
                Get.locale?.languageCode == 'ar' ? "محول العملات ومصاريف السفر" : "Currency & Travel Expenses",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.currency_exchange_rounded,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Get.toNamed(Routes.currencyConverterScreen);
              },
            ),
            ListTile(
              title: Text(
                Get.locale?.languageCode == 'ar' ? "دليل الطوارئ والعبارات السياحية" : "Emergency & Travel Guide",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.emergency_outlined,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Get.toNamed(Routes.emergencyGuideScreen);
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              title: Text(
                "Setting".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Get.toNamed(Routes.SettingsScreen);
              },
            ),
            ListTile(
              title: Text(
                "Notifications".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Get.toNamed(Routes.ViewNotificationScreen);
              },
            ),
            ListTile(
              title: Text(
                "Share".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.share,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Share.share('https://travelwin1.com/');
              },
            ),
            ListTile(
                title: GetBuilder<AuthController>(
              builder: (_) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.defaultDialog(
                      title: "Logout From App",
                      titleStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      middleText: 'Are you sure you need to logout',
                      middleTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.grey,
                      radius: 10,
                      textCancel: " No ",
                      cancelTextColor: Colors.white,
                      textConfirm: " YES ",
                      confirmTextColor: Colors.white,
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () {
                        authController.signOutFromApp();
                      },
                    );
                  },
                  splashColor: Get.isDarkMode ? Colors.pink : Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                  customBorder: const StadiumBorder(),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Logout'.tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            )),
          ],
        ));
  }
}
