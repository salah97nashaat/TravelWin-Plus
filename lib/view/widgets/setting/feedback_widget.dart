import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/const.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';

class FeedbackWidget extends StatelessWidget {
  FeedbackWidget({Key? key}) : super(key: key);
  final controller = Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35.h,
          width: 40.w,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: mainColor.withOpacity(0.2),
          ),
          child: Center(
            child: SizedBox(
                height: 20.sp,
                width: 20.sp, // fixed width and height
                child: SvgPicture.asset(
                  'assets/images/whatsapp.svg',
                  // color: mainColor,
                  colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                )),
          ),
          // const Icon(
          //   Icons.app,
          //   color: Colors.white,
          // ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () async {
            launchWhatsapp('', whatappnumbers.data![3].number);
          },
          child: Text(
            "Feedback and suggestions".tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
