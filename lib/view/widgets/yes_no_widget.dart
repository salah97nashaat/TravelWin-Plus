import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/view/widgets/yes_no_button.dart';

import '../../utils/theme.dart';

class YesNoWidget extends StatelessWidget {
  const YesNoWidget({super.key, required this.car, required this.question});

  final Rx<bool> car;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            question,
            style: TextStyle(
                color: mainColor, fontSize: 12.w, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YesNoButton(
              color: Color(0xff92A63D),
              fontColor: Colors.white,
              name: 'Yes'.tr,
              clicked: car,
              type: 'yes',
            ),
            SizedBox(
              width: 40.w,
            ),
            YesNoButton(
              color: Color(0xffDA2E2E),
              fontColor: Colors.white,
              name: 'No'.tr,
              clicked: car,
              type: 'no',
            ),
          ],
        ),
      ],
    );
  }
}