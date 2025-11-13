import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/logic/controllers/profile_controller.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/text_utils.dart';

import '../../../const.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({Key? key}) : super(key: key);

  final controller = Get.find<SettingController>();
  final authController = Get.find<AuthController>();
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Divider(color: Colors.grey),
          ),
          SizedBox(height: 15.h),
          Center(
            child: Obx(
              () => profile.value.data!.image != ''
                  ? ClipRRect(
                      child: InkWell(
                      onTap: () {
                        Get.to(() => FullImage(
                              url: profile.value.data!.image,
                              network: true,
                            ));
                      },
                      child: Hero(
                        tag: 'profile',
                        child: Obx(
                          () => CircleAvatar(
                              radius: 50.h,
                              backgroundImage:
                                  NetworkImage(profile.value.data!.image)),
                        ),
                      ),
                    ))
                  : image.value!.path == ''
                      ? SvgPicture.asset('assets/images/person.svg')
                      : ClipRRect(
                          child: InkWell(
                          onTap: () {
                            Get.to(() => FullImage(
                                  url: image.value!.path,
                                  network: false,
                                ));
                          },
                          child: Hero(
                            tag: 'profile',
                            child: CircleAvatar(
                                radius: 50.h,
                                backgroundImage:
                                    FileImage(File(image.value!.path))),
                          ),
                        )),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          MyListTile(
            string: profile.value.data!.name,
            svg: 'assets/images/name.svg',
            authController: authController,
          ),
          SizedBox(
            height: 20.h,
          ),
          MyListTile(
              string: profile.value.data!.age.toString(),
              svg: 'assets/images/cake.svg',
              authController: authController),
          SizedBox(
            height: 20.h,
          ),
          MyListTile(
              string: profile.value.data!.mobile.toString(),
              svg: 'assets/images/phone.svg',
              authController: authController),
          SizedBox(
            height: 20.h,
          ),
          MyListTile(
              string: profile.value.data!.email,
              svg: 'assets/images/email.svg',
              authController: authController),
          SizedBox(
            height: 20.h,
          ),
          // MyListTile(string: profile.value.data!.living_country,svg: 'assets/images/location.svg',authController: authController),
          // SizedBox(height: 20.h,),
          MyListTile(
              string: profile.value.data!.gender.tr,
              svg: 'assets/icon/gender.svg',
              authController: authController),

          SizedBox(
            height: 60.h,
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 120.w),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  )),
              onPressed: () {
                //   Get.toNamed(Routes.EditProfileScreen);

                Get.toNamed(Routes.EditProfileScreen, arguments: [
                  {
                    "id": profile.value.data!.id,
                    "name": profile.value.data!.name,
                    "age": profile.value.data!.age,
                    "countrydialcode": profile.value.data!.dialcode,
                    "country_code": profile.value.data!.country_code,
                    "mobile": profile.value.data!.mobile,
                    "email": profile.value.data!.email,
                    "location": profile.value.data!.living_country,
                    "gender": profile.value.data!.gender == ''
                        ? 'male'.tr
                        : profile.value.data!.gender.tr,
                  },
                ]);
              },
              child: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                text: 'Edit'.tr,
                color: Colors.white,
                underLine: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  MyListTile(
      {super.key,
      required this.string,
      required this.svg,
      required this.authController});
  final AuthController authController;
  final String string;
  final String svg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        height: 50.h,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    svg,
                    height: 25,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    string,
                    style: TextStyle(color: mainColor),
                  )
                ],
              ),
              InkWell(
                  onTap: () {
                    Get.toNamed(Routes.EditProfileScreen, arguments: [
                      {
                        "id": profile.value.data!.id,
                        "name": profile.value.data!.name,
                        "age": profile.value.data!.age,
                        "countrydialcode": profile.value.data!.dialcode,
                        "country_code": profile.value.data!.country_code,
                        "mobile": profile.value.data!.mobile,
                        "email": profile.value.data!.email,
                      },
                    ]);
                  },
                  child: SvgPicture.asset('assets/images/arrow.svg')),
            ],
          ),
        ),
      ),
    );
  }
}

class FullImage extends StatelessWidget {
  const FullImage({Key? key, required this.url, required this.network})
      : super(key: key);
  final String url;
  final bool network;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        alignment: Alignment.center,
        child: Hero(
          tag: 'profile',
          child: network ? Image.network(url) : Image.file(File(url)),
        ),
      ),
    );
  }
}
