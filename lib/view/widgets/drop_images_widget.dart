import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/utils/theme.dart';
import '../../logic/controllers/auth_controller.dart';

class DropImagesWidget extends StatelessWidget {
  const DropImagesWidget({
    super.key,
    required this.name,
    required this.picker,
  });

  final AuthController name;
  final ImagePicker picker;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        name.images.value = (await picker.pickMultiImage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: DottedBorder(
          options: RectDottedBorderOptions(
          color: mainColor,
          strokeWidth: 2,
          dashPattern: [6, 3], // optional customization
          padding: EdgeInsets.all(4), // optional
        ),
          child: Obx(
            () => Container(
                color: Colors.white,
                width: Get.width,
                height: name.images.value.isEmpty ? 145 : 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Upload your photos'.tr,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: name.images.value.isNotEmpty,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 59,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Container(
                                      height: 59,
                                      width: 57,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: FileImage(
                                                File(name
                                                    .images.value[index].path),
                                              ),
                                              fit: BoxFit.fill)),
                                    ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      width: 5,
                                    ),
                                itemCount: name.images.value.length),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
