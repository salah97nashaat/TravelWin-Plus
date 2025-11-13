// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
import 'package:travelwin/models/Abou.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../../utils/theme.dart';
import '../../widgets/next_button.dart';
// import '../../widgets/setting/profile_widget.dart';
// import '../../widgets/text_form_field.dart';
import '../../widgets/upload_photo.dart';
import '../../widgets/yes_no_button.dart';
import '../../widgets/yes_no_widget.dart';

class SignAsGuide2 extends StatelessWidget {
  SignAsGuide2({Key? key}) : super(key: key);

  final Rx<XFile?> imageForIdentity = XFile('').obs;
  final Rx<XFile?> imageForCertificate = XFile('').obs;
  final Rx<bool> certificate = Rx(false);
  final Rx<bool> car = Rx(false);
  final Rx<bool> agree = Rx(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Sign as Special Tour Guide'.tr,
          style: TextStyle(color: Colors.black, fontSize: 14.w),
        ),
        leading: Container(),
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
            Center(
              child: Text(
                'حمل الهوية للتوثيق'.tr,
                style: TextStyle(
                    color: mainColor,
                    fontSize: 12.w,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            UploadPhoto(file: imageForIdentity),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            YesNoWidget(
              car: certificate,
              question: 'هل تمتلك رخصة مرشد سياحي؟'.tr,
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => Visibility(
                  visible: certificate.value,
                  child: UploadPhoto(file: imageForCertificate)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            YesNoWidget(
              car: car,
              question: 'هل تمتلك سيارة خاصة للتنقل؟'.tr,
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      About guide = About();
                      about.value.about!.forEach((element) {
                        if (element.type == 'guidance_privacy') {
                          guide = element;
                        }
                      });
                      Get.defaultDialog(
                          title: 'Terms'.tr,
                          content: Container(
                              height: 400.h,
                              child: SingleChildScrollView(
                                  child: Text(Get.locale == Locale('ar')
                                      ? guide.bodyAr!
                                      : guide.bodyEn!))));
                    },
                    child: SizedBox(
                      width: 200.w,
                      child: Text(
                        'الموافقة على شروط التسجيل كمرشد'.tr,
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 10.sp,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      YesNoButton(
                        color: Color(0xff92A63D),
                        fontColor: Colors.white,
                        name: 'Agree'.tr,
                        clicked: agree,
                        type: 'yes',
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      YesNoButton(
                        color: Color(0xffDA2E2E),
                        fontColor: Colors.white,
                        name: 'DisAgree'.tr,
                        clicked: agree,
                        type: 'no',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Obx(
              () => isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NextButton(
                            color: mainColor,
                            name: 'Done'.tr,
                            onTap: () {
                              if (imageForIdentity.value!.path == '' ||
                                  !agree.value) {
                                Get.showSnackbar(GetSnackBar(
                                    message:
                                        'You have to enter all fields and agree the terms'
                                            .tr,
                                    duration: Duration(seconds: 5)));
                              } else if (imageForCertificate.value!.path ==
                                      '' &&
                                  certificate.value) {
                                Get.showSnackbar(GetSnackBar(
                                    message:
                                        'You have to upload certificate image'
                                            .tr,
                                    duration: Duration(seconds: 5)));
                              } else {
                                isLoading.value = true;
                                GuidenceController guidenceController =
                                    GuidenceController();
                                guidenceController
                                    .becameGuidence(
                                        businessPlaceAR.text,
                                        businessPlaceEN.text,
                                        languagesAR.text,
                                        languagesEN.text,
                                        bioAR.text,
                                        bioEN.text,
                                        dailyPay.text,
                                        imageForIdentity.value!.path,
                                        certificate.value ? 1 : 0,
                                        car.value ? 1 : 0,
                                        imageForCertificate.value!.path,
                                        nationality.text)
                                    .then((value) {
                                  print(value.data);
                                  if (value.statusCode == 200) {
                                    isLoading.value = false;
                                    showDialog(
                                      context: context,
                                      builder: (context) => Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Container(
                                          height: 1.sh,
                                          width: 1.sw,
                                          color: Colors.grey.withOpacity(0.4),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.w),
                                              child: Container(
                                                height: 125.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x4C005FB6),
                                                      blurRadius: 20,
                                                      offset: Offset(0, 10),
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            child: Icon(
                                                                Icons.close),
                                                            onTap: () {
                                                              Get.back();
                                                              Get.back();
                                                              Get.back();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'سيتم مراجعة ملفك خلال 48 ساعة'
                                                                .tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SvgPicture.asset(
                                                              'assets/images/deal 1 (1).svg')
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (value ==
                                      'You sended request before') {
                                    isLoading.value = false;
                                    Get.showSnackbar(GetSnackBar(
                                        message: 'You sended request before'.tr,
                                        duration: Duration(seconds: 5)));
                                  } else {
                                    isLoading.value = false;
                                    Get.showSnackbar(GetSnackBar(
                                        message: value.data['message'],
                                        duration: Duration(seconds: 5)));
                                  }
                                });
                              }
                            },
                            fontColor: Colors.white,
                            type: 'done',
                          ),
                          Obx(
                            () => isLoading.value
                                ? Container()
                                : NextButton(
                                    color: Colors.white,
                                    name: 'Back'.tr,
                                    onTap: () {
                                      Get.back();
                                    },
                                    fontColor: mainColor,
                                    type: 'back',
                                  ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
