// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/logic/controllers/drop_down_controller.dart';
// import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/view/widgets/drop_images_widget.dart';
import 'package:travelwin/view/widgets/my_drop_down.dart';

import '../../../utils/my_string.dart';
import '../../../utils/theme.dart';
import '../../widgets/my_text_field2.dart';
import '../../widgets/next_button.dart';
// import '../../widgets/setting/profile_widget.dart';
// import '../../widgets/text_form_field.dart';

class AddProperty2 extends StatelessWidget {
  AddProperty2({Key? key}) : super(key: key);

  final Rx<XFile?> image = XFile('').obs;
  final ImagePicker _picker = ImagePicker();
  final AuthController authController = AuthController();
  final DropDownController dropDownControllerCash =
      DropDownController(value: Rx('كاش'.tr));
  final DropDownController dropDownControllerClassification =
      DropDownController(value: Rx('اسطنبول الأوروبية'.tr));
  final List<String> propertyType = ['كاش'.tr, 'تقسيط'.tr];
  final List<String> classification = [
    'اسطنبول الأوروبية'.tr,
    'اسنطبول الاسيوية'.tr,
    'أراضي'.tr,
    'بورصة'.tr,
    'طرابزون'.tr,
    'يلوا'.tr,
  ];
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
                      ' 2/2 ',
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
                      'Payment type'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownControllerCash,
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
                      'Classification'.tr,
                      style: TextStyle(color: mainColor),
                    )),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyDropDown(
                    dropDownController: dropDownControllerClassification,
                    publisher: false,
                    locations: classification),
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: price,
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
                hintText: 'السعر'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: monthlyCost,
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
                hintText: 'المصاريف الشهرية للعقار'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: descriptionAr,
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
                hintText: 'الوصف بالعربي'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: descriptionEn,
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
                hintText: 'الوصف بالانجليزي'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: locationEn,
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
                hintText: 'الموقع بالانجليزي'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 15.h,
              ),
              MyTextFromField2(
                controller: locationAr,
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
                hintText: 'الموقع بالعربي'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 15.h,
              ),
              DropImagesWidget(name: authController, picker: _picker),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 33.h,
                width: 140.w,
                child: Obx(
                  () => isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : NextButton(
                          color: Colors.white,
                          name: 'Next'.tr,
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              if (authController.images.value.isEmpty) {
                                Get.showSnackbar(GetSnackBar(
                                    message:
                                        'You have to choose at least one image'
                                            .tr,
                                    duration: Duration(seconds: 2)));
                              } else {
                                isLoading.value = true;
                                RemoteServices.addProperty(
                                        locationAr.text,
                                        locationEn.text,
                                        space.text,
                                        dropDownControllerForfur.value.value ==
                                                'yes'.tr
                                            ? 1
                                            : 0,
                                        dropDownControllerForCur.value.value ==
                                                'lira turkey'.tr
                                            ? 'turkey'
                                            : 'dollar',
                                        dropDownControllerForPA.value.value ==
                                                'owner'.tr
                                            ? 'owner'
                                            : 'company',
                                        descriptionAr.text,
                                        descriptionEn.text,
                                        monthlyCost.text,
                                        rooms.text,
                                        bathrooms.text,
                                        price.text,
                                        floor.text,
                                        dropDownController.value.value ==
                                                'شقق'.tr
                                            ? 'apartment'
                                            : 'villa',
                                        dropDownControllerCash.value.value ==
                                                'كاش'.tr
                                            ? 'cash'
                                            : 'installments',
                                        dropDownControllerClassification
                                                    .value.value ==
                                                'اسطنبول الأوروبية'.tr
                                            ? 'european_istanbul'
                                            : dropDownControllerClassification
                                                        .value.value ==
                                                    'اسنطبول الاسيوية'.tr
                                                ? 'istanbul_turkey'
                                                : dropDownControllerClassification
                                                            .value.value ==
                                                        'طرابزون'.tr
                                                    ? 'trabzon'
                                                    : dropDownControllerClassification
                                                                .value.value ==
                                                            'أراضي'.tr
                                                        ? 'lands'
                                                        : dropDownControllerClassification
                                                                    .value
                                                                    .value ==
                                                                'يلوا'.tr
                                                            ? 'yalwa'
                                                            : 'market',
                                        propertyAgeController.text,
                                        authController.images.value)
                                    .then((value) {
                                  if (value == 'Created Successfully') {
                                    isLoading.value = false;
                                    showSnackBar(
                                        context,
                                        'تمت الأضافة بنجاح بانتظار موافقة الادمن'
                                            .tr);
                                    Get.back();
                                    Get.back();
                                  } else {
                                    print(value);
                                  }
                                });
                                //Get.toNamed(Routes.signUpAsGuide2);
                              }
                            }
                          },
                          fontColor: mainColor,
                          type: 'back'),
                ),
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
