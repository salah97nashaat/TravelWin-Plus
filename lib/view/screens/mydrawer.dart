import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/theme.dart';
import '../../logic/controllers/auth_controller.dart';
import '../../routes/routes.dart';
import 'package:share_plus/share_plus.dart';
class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        child: ListView(
          children: <Widget>[

            ListTile(
              title: Text(
                "Profile".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              leading: const Icon(
                Icons.person_pin_rounded,
                color: Colors.white,
                size: 25,
              ),
              onTap: () async {
                Get.toNamed(Routes.ProfileScreen);
              },
            ),
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
                "Notification".tr,
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
