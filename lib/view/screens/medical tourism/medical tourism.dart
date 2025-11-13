import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../../const.dart';
import '../../widgets/normalButton.dart';

class MedicalTourism extends StatelessWidget {
  MedicalTourism({Key? key}) : super(key: key);

  final MedicalTourismController medicalTourismController =
      MedicalTourismController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: Container(),
        title: Text(
          "Medical tourism".tr,
          style: TextStyle(color: Colors.black),
        ),
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
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          Center(
              child: SvgPicture.asset(
            'assets/images/medical tourism.svg',
            height: Get.locale == Locale('ar') ? 160.h : 150.h,
            width: 180.w,
          )),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "We help tourism to obtain the best medical services at costs less than 70%"
                    .tr,
                style: TextStyle(
                    color: mainColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'With the same European international medical standards'
                            .tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 20.h : 10.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'Arrangement of hotel accommodation, transportation, translation services, appointments and the hospital'
                            .tr
                            .tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 26.h : 12.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'JCI Non-Profit Certificate'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 24.h : 16.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'Develop a treatment plan and free consultation'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: 350.w,
            height: 195.h,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 2)),
                ],
                borderRadius: BorderRadius.circular(15)),
            child: RawScrollbar(
              thumbColor: mainColor,
              radius: Radius.circular(15),
              interactive: false,
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Obx(
                  () => InkWell(
                      onTap: () {
                        medicalTourismController.changeIndex(index);
                      },
                      child: MedicalService(
                          name: Get.locale == Locale('ar')
                              ? medicalTrips
                                  .value!.medicalTrips![index].titleAr!
                              : medicalTrips
                                  .value!.medicalTrips![index].titleEn!,
                          chosen: medicalTourismController.index == index)),
                ),
                itemCount: medicalTrips.value!.medicalTrips!.length,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          NormalButton(
            onTap: () {
              if (Get.locale == Locale('en')) {
                launchWhatsapp(
                    'i want to ask about medical tourism in the field ${medicalTrips.value!.medicalTrips![medicalTourismController.index.value].titleEn}',
                    whatappnumbers.data![2].number);
              } else {
                launchWhatsapp(
                    'مرحبا أريد السؤال عن السياحة العلاجية بمجال  ${medicalTrips.value!.medicalTrips![medicalTourismController.index.value].titleAr}',
                    whatappnumbers.data![2].number);
              }
            },
            color: Color(0xff00E676),
            name: 'WhatsApp contact'.tr,
            fontColor: Colors.white,
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}

class MedicalService extends StatelessWidget {
  MedicalService({super.key, required this.name, required this.chosen});

  final String name;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
          color: chosen ? Color(0xffE9EFF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 35.w,
            ),
            CircleAvatar(
              backgroundColor: chosen ? mainColor : Colors.grey.shade300,
              radius: 10.w,
            ),
            SizedBox(
              width: 25.w,
            ),
            Text(
              name,
              style: TextStyle(
                  color: mainColor,
                  fontSize: 12.w,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
