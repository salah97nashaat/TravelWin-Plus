import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YesNoButton extends StatelessWidget {
  YesNoButton(
      {super.key,
      required this.name,
      required this.color,
      required this.clicked,
      required this.fontColor,
      required this.type});

  final Rx<bool> clicked;
  final Color color;
  final Color fontColor;
  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          clicked.value = !clicked.value;
        },
        borderRadius: BorderRadius.circular(8),
        child: type == 'yes'
            ? clicked.value
                ? Container(
                    height: 23.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text(
                      name,
                      style: TextStyle(color: fontColor, fontSize: 10.sp),
                    )),
                  )
                : Container(
                    height: 23.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                      ),
                      color: fontColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text(
                      name,
                      style: TextStyle(color: color, fontSize: 12.w),
                    )),
                  )
            : !clicked.value
                ? Container(
                    height: 23.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text(
                      name,
                      style: TextStyle(color: fontColor, fontSize: 12.w),
                    )),
                  )
                : Container(
                    height: 23.h,
                    width: 55.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color,
                      ),
                      color: fontColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text(
                      name,
                      style: TextStyle(color: color, fontSize: 12.w),
                    )),
                  ),
      ),
    );
  }
}
