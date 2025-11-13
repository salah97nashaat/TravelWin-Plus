// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/routes/routes.dart';

import '../../../utils/my_string.dart';
import '../../../utils/theme.dart';
import '../../widgets/next_button.dart';
// import '../../widgets/setting/profile_widget.dart';
import '../../widgets/text_form_field.dart';

class SignAsGuide extends StatelessWidget {
  SignAsGuide({Key? key}) : super(key: key);

  final Rx<XFile?> image = XFile('').obs;
  // final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Sign as Special Tour Guide'.tr,
          style: TextStyle(color: Colors.black, fontSize: 14.w),
        ),
        centerTitle: true,
        leadingWidth: 65.w,
        leading: Container(),
        actions: [
          Padding(
            padding: Get.locale == Locale('ar')
                ? EdgeInsets.only(left: 25.w, top: 5.h)
                : EdgeInsets.only(right: 25.w, top: 5.h),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset(
                    'assets/images/back.svg',
                    height: 30,
                  ),
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Divider(
                  color: Colors.grey.withOpacity(0.35),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      'STEP'.tr,
                      style: TextStyle(
                        color: Color(0xFFC4BDBD),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' 1/2 ',
                      style: TextStyle(
                        color: Color(0xFFC4BDBD),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: nationality,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Nationality'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: businessPlaceAR,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Business Places AR'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: businessPlaceEN,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Business Places En'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: languagesAR,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Languages AR'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: languagesEN,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Languages EN'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                maxLength: 100,
                controller: bioAR,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Biography AR'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                maxLength: 100,
                controller: bioEN,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Biography EN'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 8.h,
              ),
              MyTextFromField(
                controller: dailyPay,
                obscureText: false,
                validator: (value) {
                  if (value == '') {
                    return 'Cannot be empty'.tr;
                  } else {
                    return null;
                  }
                },
                //
                // Get.isDarkMode
                //     ?   Icon(
                //         Icons.email,
                //         color: pinkClr,
                //         size: 30.sp,
                //       )
                //     : Image.asset('assets/images/email.png'),
                suffixIcon: const Text(""),
                hintText: 'Daily Wage in USD'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 30.h,
              ),
              NextButton(
                color: mainColor,
                name: 'Next'.tr,
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    Get.toNamed(Routes.signUpAsGuide2);
                  }
                },
                fontColor: Colors.white,
                type: 'done',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
