import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/Notification.dart';

import '../../../utils/theme.dart';

class NotificationList extends StatelessWidget {
  final Notifications notificationModels;

  const NotificationList(this.notificationModels);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: 80.h,
        decoration: BoxDecoration(
            color: Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: mainColor,
                size: 30,
              ),
              SizedBox(
                width: 25.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.locale == Locale('ar')
                        ? notificationModels.titleAr!
                        : notificationModels.title!,
                    style: TextStyle(
                      color: Color(0xFF263238),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      //height: 0.10,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    Get.locale == Locale('ar')
                        ? notificationModels.bodyAr!
                        : notificationModels.body!,
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
