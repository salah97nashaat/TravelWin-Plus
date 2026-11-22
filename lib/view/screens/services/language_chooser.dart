import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:travelwin/view/screens/services/service_chooser.dart';
import 'package:travelwin/view/screens/services/state_chooser.dart';
import '../../../helpers/adv/admob_banner.dart';

/*
unused page
*/
class LanguageChooser extends StatelessWidget {
  const LanguageChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        backgroundColor: inversePrimaryColor2,
        foregroundColor: primaryColor2,
        title: Text("choose_language".tr),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: Text("ar".tr),
              onTap: () {
                Get.updateLocale(const Locale("ar", "SY"));
                var box = GetStorage();
                box.write("lang", "ar");
                goToStateChooser();
              },
            ),
            ListTile(
              title: Text("en".tr),
              onTap: () {
                Get.updateLocale(const Locale("en", "US"));
                var box = GetStorage();
                box.write("lang", "en");
                goToStateChooser();
              },
            ),
            ListTile(
              title: Text("tr".tr),
              onTap: () {
                Get.updateLocale(const Locale("tr", "TR"));
                var box = GetStorage();
                box.write("lang", "tr");
                goToStateChooser();
              },
            )
          ],
        ),
      ),
    );
  }

  void goToStateChooser() {
    if (Get.arguments != null && Get.arguments['from'] != null) {
      Get.off(() => const ServiceChooser());
    } else {
      Get.off(() => const StateChooser());
    }
    // Get.off(() => const StateChooser());
  }
}
