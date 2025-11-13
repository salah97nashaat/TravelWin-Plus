// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/theme.dart';

import '../../../models/PropertiesModel.dart';
import '../../../utils/my_string.dart';

class ExploreRealState extends StatelessWidget {
  ExploreRealState({Key? key}) : super(key: key);
  final Rx<bool> villa = Rx(false);
  final List<IstanbulTurkey> villas = [];
  final List<IstanbulTurkey> apartments = [];
  @override
  Widget build(BuildContext context) {
    villas.clear();
    apartments.clear();
    if (realStateType.value == 'اسطنبول الأوروبية') {
      for (var i in properties.value.europeanIstanbul!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    } else if (realStateType.value == 'اسنطبول الاسيوية') {
      for (var i in properties.value.istanbulTurkey!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    } else if (realStateType.value == 'بورصة') {
      for (var i in properties.value.market!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    } else if (realStateType.value == 'طرابزون') {
      for (var i in properties.value.trabzon!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    } else if (realStateType.value == 'أراضي') {
      for (var i in properties.value.lands!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    } else if (realStateType.value == 'يلوا') {
      for (var i in properties.value.yalwa!) {
        if (i.propertyType == 'villa') {
          villas.add(i);
        } else {
          apartments.add(i);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          realStateType.value.tr,
          style: TextStyle(color: Colors.black),
        ),
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
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return RemoteServices.fetchProperties();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Divider(
                  color: Colors.grey.withOpacity(0.35),
                  thickness: 1,
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => villa.value
                        ? Column(
                            children: [
                              Text(
                                'فلل'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  // height: 0.09,
                                  letterSpacing: 0.16,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                width: 150.w,
                                height: 3,
                                color: mainColor,
                              )
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              villa.value = true;
                            },
                            child: SizedBox(
                              width: 150,
                              child: Center(
                                child: Text(
                                  'فلل'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    // height: 0.09,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Obx(
                    () => villa.value
                        ? GestureDetector(
                            onTap: () {
                              villa.value = false;
                            },
                            child: SizedBox(
                              width: 150,
                              child: Center(
                                child: Text(
                                  'شقق'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    // height: 0.09,
                                    letterSpacing: 0.16,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Text(
                                'شقق'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  // height: 0.09,
                                  letterSpacing: 0.16,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                width: 150.w,
                                height: 3,
                                color: mainColor,
                              )
                            ],
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => villa.value
                    ? SizedBox(
                        child: villas.isEmpty
                            ? Center(
                                child: Text(
                                  'Nothing to show'.tr,
                                  style: TextStyle(
                                      color: mainColor, fontSize: 24.sp),
                                ),
                              )
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        property.value = villas[index];
                                        Get.toNamed(Routes.propertyDetails);
                                      },
                                      child: PropertyWidget(
                                          image: villas[index].images![0].url!,
                                          address: Get.locale == Locale('ar')
                                              ? villas[index].locationAr!
                                              : villas[index].locationEn!,
                                          price: villas[index].price.toString(),
                                          rate: villas[index].rate!.toDouble(),
                                          rooms: villas[index].rooms.toString(),
                                          space: villas[index]
                                              .squareSize
                                              .toString()),
                                    ),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 20.h,
                                    ),
                                itemCount: villas.length),
                      )
                    : SizedBox(
                        child: apartments.isEmpty
                            ? Center(
                                child: Text(
                                  'Nothing to show'.tr,
                                  style: TextStyle(
                                      color: mainColor, fontSize: 24.sp),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                //   physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        property.value = apartments[index];
                                        Get.toNamed(Routes.propertyDetails);
                                      },
                                      child: PropertyWidget(
                                          image:
                                              apartments[index].images![0].url!,
                                          address: Get.locale == Locale('ar')
                                              ? apartments[index].locationAr!
                                              : apartments[index].locationEn!,
                                          price: apartments[index]
                                              .price
                                              .toString(),
                                          rate: apartments[index]
                                              .rate!
                                              .toDouble(),
                                          rooms: apartments[index]
                                              .rooms
                                              .toString(),
                                          space: apartments[index]
                                              .squareSize
                                              .toString()),
                                    ),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 20.h,
                                    ),
                                itemCount: apartments.length),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyWidget extends StatelessWidget {
  const PropertyWidget({
    super.key,
    required this.image,
    required this.rate,
    required this.price,
    required this.address,
    required this.space,
    required this.rooms,
  });
  final String image;
  final String address;
  final String space;
  final String rooms;
  final String price;
  final double rate;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 25,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ], borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/location2.svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${'العنوان'.tr}: ${address}',
                          textAlign: Get.locale == Locale('ar')
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            // height: 0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/space2.svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${'المساحة'.tr}: ${space} M',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            // height: 0,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/door2.svg'),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${'عدد الغرف'.tr}: ${rooms}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            // height: 0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${price}',
                                style: TextStyle(
                                  color: Color(0xFF215B82),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              Icon(Icons.money),
                            ],
                          ),
                          SmoothStarRating(
                            allowHalfRating: true,
                            defaultIconData: Icons.star_border_rounded,
                            filledIconData: Icons.star_rate_rounded,
                            halfFilledIconData: Icons.star_half_rounded,
                            starCount: 5,
                            rating: rate,
                            size: 18.0,
                            color: Color(0xffFABF35),
                            borderColor: Color(0xffFABF35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 130.h,
            width: 150.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fill)),
          ),
        ],
      ),
    );
  }
}
