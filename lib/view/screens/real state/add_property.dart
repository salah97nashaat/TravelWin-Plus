// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:travelwin/logic/controllers/drop_down_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/view/widgets/my_drop_down.dart';

import '../../../utils/my_string.dart';
import '../../../utils/theme.dart';
import '../../widgets/my_text_field2.dart';
import '../../widgets/next_button.dart';
// import '../../widgets/setting/profile_widget.dart';
// import '../../widgets/text_form_field.dart';

class AddProperty extends StatelessWidget {
  AddProperty({Key? key}) : super(key: key);

  final Rx<XFile?> image = XFile('').obs;
  // final ImagePicker _picker = ImagePicker();
  final List<String> propertyType = ['شقق'.tr, 'فلل'.tr];
  final List<String> propertyFurniture = ['yes'.tr, 'no'.tr];
  final List<String> propertyCur = ['lira turkey'.tr, 'US dollar'.tr];
  final List<String> propertyPA = ['owner'.tr, 'company'.tr];
  final GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Advertise your property'.tr,
          style: TextStyle(color: Colors.black, fontSize: 14.w),
        ),
        centerTitle: true,
        leadingWidth: 65.w,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'Property type'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownController,
                    publisher: false,
                    locations: propertyType),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'Furniture'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownControllerForfur,
                    publisher: false,
                    locations: propertyFurniture),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'Currency'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownControllerForCur,
                    publisher: false,
                    locations: propertyCur),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'Property Advertiser'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownControllerForPA,
                    publisher: false,
                    locations: propertyPA),
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: space,
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
                hintText: 'المساحة'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: propertyAgeController,
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
                hintText: 'Property age'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: rooms,
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
                hintText: 'عدد الغرف'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: bathrooms,
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
                hintText: 'عدد دورات المياه'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: floor,
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
                hintText: 'Floor'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 33.h,
                width: 140.w,
                child: NextButton(
                    color: Colors.white,
                    name: 'Next'.tr,
                    onTap: () {
                      if (formkey.currentState!.validate()) {
                        Get.toNamed(Routes.addProperty2);
                      }
                    },
                    fontColor: mainColor,
                    type: 'back'),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
