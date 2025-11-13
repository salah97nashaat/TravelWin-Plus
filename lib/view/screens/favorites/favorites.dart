import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/routes/routes.dart';
// import 'package:travelwin/utils/theme.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        title: Text(
          "Favorite".tr,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.favoritePlace);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80.h,
                decoration: ShapeDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tourism Areas'.tr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            //height: 0.10,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'يمكنك الاطلاع على عناصر الاماكن السياحية المفضلة'
                                .tr,
                            textAlign: Get.locale == Locale('ar')
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF546E7A),
                              fontSize: 8.sp,
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w400,
                              // height: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Text(
                      'View'.tr,
                      style: TextStyle(
                        color: Color(0xFF546E7A),
                        fontSize: 14.sp,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                        height: 0.20,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.favoriteTrip);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80.h,
                decoration: ShapeDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trips'.tr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            //height: 0.10,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'يمكنك الاطلاع على عناصر الرحلات المفضلة'.tr,
                            textAlign: Get.locale == Locale('ar')
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF546E7A),
                              fontSize: 8.sp,
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w400,
                              // height: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Text(
                      'View'.tr,
                      style: TextStyle(
                        color: Color(0xFF546E7A),
                        fontSize: 14.sp,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                        height: 0.20,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.favoriteGuide);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80.h,
                decoration: ShapeDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tour Guides'.tr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            //height: 0.10,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'يمكنك الاطلاع على عناصر المرشدين السياحين المفضلة'
                                .tr,
                            textAlign: Get.locale == Locale('ar')
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF546E7A),
                              fontSize: 8.sp,
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w400,
                              // height: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Text(
                      'View'.tr,
                      style: TextStyle(
                        color: Color(0xFF546E7A),
                        fontSize: 14.sp,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.favoriteRealEstate);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 80.h,
                decoration: ShapeDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Properties'.tr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            //height: 0.10,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: Text(
                            'يمكنك الاطلاع على عناصر العقارات المفضلة'.tr,
                            textAlign: Get.locale == Locale('ar')
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF546E7A),
                              fontSize: 8.sp,
                              fontFamily: 'Readex Pro',
                              fontWeight: FontWeight.w400,
                              // height: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Text(
                      'View'.tr,
                      style: TextStyle(
                        color: Color(0xFF546E7A),
                        fontSize: 14.sp,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
