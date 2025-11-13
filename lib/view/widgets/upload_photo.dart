import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/utils/theme.dart';

class UploadPhoto extends StatelessWidget {
  UploadPhoto({super.key, required this.file});
  final Rx<XFile?> file;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          file.value!.path == ''
              ? Container(
                  width: 343.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                      color: Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xffAEAEAE), width: 2)),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Color(0xffAEAEAE),
                      size: 45.w,
                    ),
                  ),
                )
              : Container(
                  width: 343.w,
                  height: 131.h,
                  decoration: BoxDecoration(
                      color: Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xffAEAEAE), width: 2),
                      image: DecorationImage(
                          image: FileImage(File(file.value!.path)),
                          fit: BoxFit.fill)),
                ),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              children: [
                Text(
                  'لن تظهر هذه الصورة للعموم'.tr,
                  style: TextStyle(color: Color(0xffC5BDBD), fontSize: 12.w),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25.w,
            ),
            child: SizedBox(
              width: 1.sw,
              height: 32.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () async {
                  file.value =
                      await _picker.pickImage(source: ImageSource.gallery);
                },
                child: Text(
                  'حمل صورة'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
