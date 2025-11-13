import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/home_controller.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/slider/carsoul_slider.dart';

class RealState extends StatelessWidget {
  RealState({Key? key}) : super(key: key);
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'EStates'.tr,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leadingWidth: 65.w,
          // actions: [
          //   Padding(
          //     padding: Get.locale == Locale('ar')
          //         ? EdgeInsets.only(left: 25.w, top: 5.h)
          //         : EdgeInsets.only(right: 25.w, top: 5.h),
          //     child: InkWell(
          //         onTap: () {
          //           Get.back();
          //         },
          //         child: Transform.flip(
          //           flipX: Get.locale == Locale('ar') ? false : true,
          //           child: SvgPicture.asset(
          //             'assets/images/back.svg',
          //             height: 30,
          //           ),
          //         )),
          //   ),
          // ],
          leading: Visibility(
            visible: token.value != 'null',
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.addProperty);
              },
              child: Padding(
                padding: Get.locale == Locale('ar')
                    ? EdgeInsets.only(right: 15.w, top: 5.h)
                    : EdgeInsets.only(left: 15.w, top: 5.h),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: mainColor2.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            'Advertise your property'.tr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 7.sp),
                            textAlign: TextAlign.center,
                          ))),
                ),
              ),
            ),
          )),
      body: Obx(
        () => home.value!.data == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.35),
                        thickness: 1,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/for sale.svg',
                      height: 130.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'تعرف على جميع العقارات والمشاريع    جميع المعلومات محدثة وموثوقة من المطور'
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (token.value != 'null') {
                              realStateType.value = 'اسطنبول الأوروبية';
                              Get.toNamed(Routes.exploreRealState);
                            } else {
                              showSnackBar(context, 'Login is required'.tr);
                            }
                          },
                          child: SizedBox(
                            height: 86.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset('assets/images/loha.svg'),
                                Positioned(
                                  top: 8.h,
                                  right: 5.w,
                                  child: SizedBox(
                                    width: 60.w,
                                    child: Text(
                                      'اسطنبولالاوروبية'.tr,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFFE9EFF3),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (token.value != 'null') {
                                  realStateType.value = 'بورصة';
                                  Get.toNamed(Routes.exploreRealState);
                                } else {
                                  showSnackBar(context, 'Login is required'.tr);
                                }
                              },
                              child: SizedBox(
                                height: 86.h,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset('assets/images/loha.svg'),
                                    Positioned(
                                      top: 13.h,
                                      right: 25.w,
                                      
                                      child: Text(
                                        'بورصة'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFE9EFF3),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (token.value != 'null') {
                              realStateType.value = 'اسنطبول الاسيوية';
                              Get.toNamed(Routes.exploreRealState);
                            } else {
                              showSnackBar(context, 'Login is required'.tr);
                            }
                          },
                          child: SizedBox(
                            //width: 100.w,
                            height: 85.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset('assets/images/loha.svg'),
                                Positioned(
                                  top: 8.h,
                                  right: 5.w,
                                  //left: 2.w,
                                  child: SizedBox(
                                    width: 60.w,
                                    child: Text(
                                      'اسنطبول الاسيوية'.tr,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(0xFFE9EFF3),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (token.value != 'null') {
                              realStateType.value = 'طرابزون';
                              Get.toNamed(Routes.exploreRealState);
                            } else {
                              showSnackBar(context, 'Login is required'.tr);
                            }
                          },
                          child: SizedBox(
                            height: 86.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset('assets/images/loha.svg'),
                                Positioned(
                                  top: 15.h,
                                  right: 20.w,
                                  child: Text(
                                    'طرابزون'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFE9EFF3),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (token.value != 'null') {
                                  realStateType.value = 'أراضي';
                                  Get.toNamed(Routes.exploreRealState);
                                } else {
                                  showSnackBar(context, 'Login is required'.tr);
                                }
                              },
                              child: SizedBox(
                                height: 86.h,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset('assets/images/loha.svg'),
                                    Positioned(
                                      top: Get.locale == Locale('ar')
                                          ? 13.h
                                          : 16.h,
                                      right: 25.w,
                                      child: Text(
                                        'أراضي'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFFE9EFF3),
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (token.value != 'null') {
                              realStateType.value = 'يلوا';
                              Get.toNamed(Routes.exploreRealState);
                            } else {
                              showSnackBar(context, 'Login is required'.tr);
                            }
                          },
                          child: SizedBox(
                            height: 86.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset('assets/images/loha.svg'),
                                Positioned(
                                  top: 15.h,
                                  right:
                                      Get.locale == Locale('ar') ? 35.w : 25.w,
                                  child: Text(
                                    'يلوا'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFE9EFF3),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.w),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.35),
                        thickness: 1,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     Get.toNamed(Routes.MedicalTourism);
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 25.w),
                    //     height: 150.h,
                    //     decoration: ShapeDecoration(
                    //       color: Color(0xFFE9EFF3),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    //       shadows: [
                    //         BoxShadow(
                    //           color: Color(0x33000000),
                    //           blurRadius: 10,
                    //           offset: Offset(0, 4),
                    //           spreadRadius: 0,
                    //         )
                    //       ],
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           height: 100.h,
                    //           decoration: ShapeDecoration(
                    //             image: DecorationImage(
                    //               image: AssetImage("assets/images/wallpaperflare.com_wallpaper.jpg"),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 247.w,
                    //           child: Text('نساعد السياحة للحصول على أفضل الخدمات الطبية بتكاليف أقل من %70'.tr,
                    //           textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //             color:mainColor,
                    //             fontSize: 14.sp,
                    //             fontFamily: 'Readex Pro',
                    //             fontWeight: FontWeight.w600,
                    //             //height: 0.12,
                    //           ),),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Obx(
                      () => homeController.otherBanner.value.isEmpty
                          ? Container()
                          : MyCarsoulSlider(
                              items: homeController.otherBanner.value,
                              height: 0.14,
                            ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
