import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../logic/controllers/about_controller.dart';

class PrivacyScreen extends StatelessWidget {
  PrivacyScreen({Key? key}) : super(key: key);
  final AboutController aboutController = Get.put(AboutController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: Center(child: Text('Privacy'.tr)),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.mainScreen);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(children: [
        const Padding(padding: EdgeInsets.all(20)),
        Center(
            child: Text(
          'Privacy'.tr,
          style: TextStyle(fontSize: 20),
        )),
        //    Obx(() => Text(aboutController.displayBody.value)),
        Obx(
          () => Container(
              margin: EdgeInsets.all(20),
              color: Get.isDarkMode ? darkGreyClr : litmain,
              width: (MediaQuery.of(context).size.width) - 100,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Text(Get.locale.toString() == "en"
                    ? aboutController.PrivacyBody.value.toString()
                    : aboutController.PrivacyBodyAr.value.toString()),
              )),
        ),
      ]),
    ));
  }
}
