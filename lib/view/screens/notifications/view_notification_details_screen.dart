import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:travelwin/view/screens/mydrawer.dart';

import '../../../logic/controllers/notification_details_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';

class ViewNotificationDetailsScreen extends StatelessWidget {
  // final notificationController = Get.find<NotificationController>();

  final NotificationDetailsController notificationDetailsController =
      Get.put(NotificationDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          elevation: 0,
          title: Text('Notifications'.tr),
          actions: [
            IconButton(
              onPressed: () {
                Get.offAllNamed(Routes.mainScreen);
              },
              icon: Icon(Icons.home),
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            const Padding(padding: EdgeInsets.all(15)),
            Container(
              margin: EdgeInsets.all(20),
              color: Get.isDarkMode ? darkGreyClr : litmain,
              // color: Get.isDarkMode ? darkGreyClr2 : kCOlor2,
              child: Column(
                children: [
                  Obx(() => ListTile(
                          title: Row(
                        children: [
                          Text(notificationDetailsController.notif.value
                              .toString()),
                          Text('Title'.tr),
                          const Text(' : '),
                          Text(Get.locale.toString() == "en"
                              ? notificationDetailsController.title.toString()
                              : notificationDetailsController.title_ar
                                  .toString()),
                        ],
                      ))),
                  Obx(() => ListTile(
                        title: Text(
                            "${'Date'.tr} : ${notificationDetailsController.createdAt}"),
                      )),
                  Center(
                    child: Text('Body'.tr),
                  ),
                  Obx(
                    () => Container(
                        width: (MediaQuery.of(context).size.width) - 100,
                        child: Text(Get.locale.toString() == "en"
                            ? notificationDetailsController.body.toString()
                            : notificationDetailsController.body_ar
                                .toString())),
                  ),
                  const Padding(padding: EdgeInsets.all(15)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
          ],
        ));
  }
}
