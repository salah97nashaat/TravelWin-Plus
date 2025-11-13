import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
// import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/normalButton.dart';

import '../../../logic/controllers/notification_controller.dart';
// import '../../../logic/controllers/profile_controller.dart';
// import '../../../logic/controllers/tripe_controller.dart';
import '../../../utils/theme.dart';
import '../../widgets/notification/notification_list.dart';
// import '../../widgets/trip.dart/trip_tile.dart';
// import '../mydrawer.dart';

class ViewNotificationScreen extends StatelessWidget {
  final NotificationController notificationController =
      Get.put(NotificationController());

//  final notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifications".tr,
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
      backgroundColor: Colors.white,
      body: Obx(() {
        if (notification.value.notifications == null)
          return Center(child: CircularProgressIndicator());
        else
          return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Divider(
                      color: Colors.grey.withOpacity(0.35),
                      thickness: 1,
                    ),
                  ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: notification.value.notifications!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.dialog(
                        barrierDismissible: true,
                        Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: Get.height * 0.53,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            Color(0xFF225D84).withOpacity(0.1),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Container(
                                  width: 271.w,
                                  height: 268.h,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF225D84).withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.64,
                                          color: Color(0xFF225D84)
                                              .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      Text(
                                        Get.locale == Locale('ar')
                                            ? notification.value
                                                .notifications![index].titleAr!
                                            : notification.value
                                                .notifications![index].title!,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      Text(
                                        Get.locale == Locale('ar')
                                            ? notification.value
                                                .notifications![index].bodyAr!
                                            : notification.value
                                                .notifications![index].body!,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFF546E7A),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 150.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(notification
                                                    .value
                                                    .notifications![index]
                                                    .createdAt!)),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFF808080),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SizedBox(
                                  width: 180.w,
                                  child: NormalButton(
                                      color: Colors.white,
                                      fontColor: mainColor,
                                      name: 'Back'.tr,
                                      onTap: () {
                                        Get.back();
                                      }),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                  child: NotificationList(
                      notification.value.notifications![index]),
                );
              });
      }),
    ));
  }
}
