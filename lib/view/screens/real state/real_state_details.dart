// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:travelwin/helpers/helper.dart';
import 'package:travelwin/logic/controllers/area_details_controller.dart';
// import 'package:travelwin/logic/controllers/home_controller.dart';
// import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/logic/controllers/place_details_controller.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/view/widgets/tourism_place.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
// import '../../widgets/bookmark_widget.dart';
import '../../widgets/normalButton.dart';
// import '../../widgets/place_text.dart';
// import '../../widgets/places_widget.dart';

class PropertyDetails extends StatefulWidget {
  PropertyDetails({Key? key}) : super(key: key);

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  AreaDetailsController areaDetailsController =
      AreaDetailsController(selected: Rx(''));

  PlaceDetailsController placeDetailsController = PlaceDetailsController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Property Details".tr,
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
        leadingWidth: 100,
        leading: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Row(
            children: [
              SizedBox(
                width: 25.w,
              ),
              GestureDetector(
                onTap: () {
                  RemoteServices.addPropertyToFav(property.value.id)
                      .then((value) async {
                    print(value.data);
                    if (value.statusCode == 200) {
                      property.value.isFavorite = !property.value.isFavorite!;
                      favoriteModel.value =
                          (await RemoteServices.fetchFavorite())!;
                      setState(() {});
                    }
                  });
                },
                child: Obx(
                  () => Icon(
                    property.value.isFavorite!
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
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
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Obx(
                    () => Container(
                      width: 1.sw,
                      height: 250,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(property
                              .value
                              .images![
                                  placeDetailsController.selectedImage.value]
                              .url!),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        height: 55,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Center(
                                  child: InkWell(
                                    onTap: () {
                                      placeDetailsController.changeImage(index);
                                    },
                                    child: Obx(
                                      () => Visibility(
                                        visible: index !=
                                            placeDetailsController
                                                .selectedImage.value,
                                        child: SmallImageWidget(
                                            image: property
                                                .value.images![index].url!),
                                      ),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) => Obx(
                                  () => Visibility(
                                    visible: index !=
                                        placeDetailsController
                                            .selectedImage.value,
                                    child: SizedBox(
                                      width: 10,
                                    ),
                                  ),
                                ),
                            itemCount: property.value.images!.length),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: Text(
                '${'Property Number'.tr} #${property.value.id}',
                style: TextStyle(
                    color: mainColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'العنوان'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    Get.locale == Locale('ar')
                        ? property.value.locationAr!
                        : property.value.locationEn!,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'عدد الغرف'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.rooms!.toString()} ${'rooms'.tr}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'عدد دورات المياه'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.bathrooms!.toString()}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'Furniture'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.furniture! ? 'yes'.tr : 'no'.tr}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      //height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'Property Advertiser'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.property_advertiser == 'owner' ? 'owner'.tr : 'company'.tr}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      //height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'Price'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.price} ${property.value.currency == 'turkey' ? 'lira turkey'.tr : 'US dollar'.tr}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      //height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'المصاريف الشهرية'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    Get.locale == Locale('ar')
                        ? property.value.costs!
                        : property.value.costs!,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'المساحة'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.squareSize} M',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'الدفع'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${property.value.paymentType}'.tr,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Get.locale == Locale('ar')
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      '${'الوصف'.tr}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${Get.locale == Locale('ar') ? property.value.descriptionAr! : property.value.descriptionEn!}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
                width: 150.w,
                child: NormalButton(
                    color: mainColor,
                    fontColor: Colors.white,
                    name: 'Contact WhatsApp'.tr,
                    onTap: () {
                      openWhatsApp(
                          'Hi i want to ask about the property you publish it on travel win'
                              .tr,
                          whatappnumbers.data![1].number!);
                    })),
            SizedBox(
              height: 10.h,
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Column(
            //       children: [
            //         Text(
            //           Get.locale == Locale('ar')
            //               ? statePlaces.value!.nameAr!
            //               : statePlaces.value!.nameEn!,
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 22.w,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(
            //           height: 10.h,
            //         ),
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.star_rounded,
            //               color: Color(0xffFABF35),
            //             ),
            //             Text(
            //               statePlaces.value!.rate!.toString()??'0',
            //               style: TextStyle(
            //                   color: Color(0xff636363), fontSize: 16.w),
            //             ),
            //             SizedBox(
            //               width: 5.w,
            //             ),
            //             Text(
            //               "/",
            //               style: TextStyle(
            //                   color: Color(0xff636363), fontSize: 16.w),
            //             ),
            //             SizedBox(
            //               width: 5.w,
            //             ),
            //             Text(
            //               Get.locale == Locale('ar')
            //                   ? home.value!.data!.states![stateId.value].nameAr!
            //                   : home
            //                   .value!.data!.states![stateId.value].nameEn!,
            //               style: TextStyle(
            //                   color: Color(0xff636363), fontSize: 16.w),
            //             ),
            //             Icon(
            //               Icons.location_pin,
            //               color: Color(0xff636363),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //     SizedBox(
            //       width: 60.w,
            //     ),
            //     Container(
            //       height: 65.h,
            //       width: 165.w,
            //       decoration: BoxDecoration(
            //         color: mainColor,
            //         borderRadius: Get.locale == Locale('ar')
            //             ? BorderRadius.only(
            //             topRight: Radius.circular(15),
            //             bottomRight: Radius.circular(15))
            //             : BorderRadius.only(
            //             topLeft: Radius.circular(15),
            //             bottomLeft: Radius.circular(15)),
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           SizedBox(
            //             height: 8.h,
            //           ),
            //           Text(
            //             'Rate Now'.tr,
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 13.w,
            //                 fontWeight: FontWeight.w600),
            //           ),
            //           SizedBox(
            //             height: 8.h,
            //           ),
            //           Text(
            //             'Share your experience to help others'.tr,
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: Get.locale == Locale('ar') ? 9.w : 7.w),
            //           ),
            //           Obx(
            //                 () => SmoothStarRating(
            //               allowHalfRating: true,
            //               defaultIconData: Icons.star_border_rounded,
            //               filledIconData: Icons.star_rate_rounded,
            //               halfFilledIconData: Icons.star_half_rounded,
            //               onRatingChanged: (v) {
            //                 placeDetailsController.stars.value = v;
            //               },
            //               starCount: 5,
            //               rating: placeDetailsController.stars.value,
            //               size: 25.0,
            //               color: Color(0xffFABF35),
            //               borderColor: Color(0xffFABF35),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 25.w),
            //   child: SizedBox(
            //     height: 220.h,
            //     child: AutoSizeText(
            //       Get.locale == Locale('ar')
            //           ? statePlaces.value!.bodyAr!
            //           : statePlaces.value!.bodyEn!,
            //       style: TextStyle(color: Colors.grey, height: 2),
            //       maxLines: 10,
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // NormalButton(
            //     color: Color(0xffCD2030),
            //     fontColor: Colors.white,
            //     name: 'Location'.tr,
            //     onTap: () {
            //       MapUtils.openMap(double.parse(statePlaces.value!.lat!), double.parse(statePlaces.value!.long!));
            //     })
          ],
        ),
      ),
    );
  }
}

class SmallImageWidget extends StatelessWidget {
  const SmallImageWidget({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 58.w,
        height: 50.h,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2.5, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
