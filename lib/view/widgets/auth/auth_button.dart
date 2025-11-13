import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/text_utils.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool loading;
  final double? width;

  const AuthButton({
    required this.onPressed,
    required this.text,
      this.loading = false,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox(
        height: 35.h,
        child: ElevatedButton(
          onPressed:  onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r)
            )
          ),
          child:
          loading?
          SizedBox(
            height: 20,
            width: 20,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          )
              :
          TextUtils(
            color: Colors.white,
            text: text,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            underLine: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
