import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/theme.dart';

class UpperContainerUi extends StatelessWidget {
  final Widget searchWidget;
  const UpperContainerUi({required this.searchWidget ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 1.sw,

      decoration: BoxDecoration(
        color: Get.isDarkMode ? darkGreyClr : mainColor,
        borderRadius:   BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding:   EdgeInsets.only(left: 20.w,right: 20.w, bottom: 30.h,top: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
              searchWidget,
          ],
        ),
      ),
    );
  }
}
