import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:travelwin/helpers/helper.dart';
import 'package:travelwin/logic/controllers/place_details_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/normalButton.dart';
import '../../../const.dart';
import '../../../logic/controllers/slider_controller.dart';
import '../../../services/profile_services.dart';
import '../../../utils/theme.dart';
import '../../widgets/date_details_widget.dart';
import '../tourism_areas/place_details.dart';

class ViewTripsDetailsScreen extends StatefulWidget {
  @override
  State<ViewTripsDetailsScreen> createState() => _ViewTripsDetailsScreenState();
}

class _ViewTripsDetailsScreenState extends State<ViewTripsDetailsScreen> {
  final SliderController sliderController = Get.put(SliderController());

  final PlaceDetailsController placeDetailsController =
      PlaceDetailsController();

  void sendToWhatsApp() async {
    // if (showLoginScreenIfNotLogin) {
    //   return ;
    // }
    final String urlTrip = 'https://travelwin1.com/trip/slider?id_post=';
    final String whatsapp = "+905526750481";
    final String fullUrlTrip = urlTrip +
        sliderController.id.value.toString() +
        '&id_user=' +
        sliderController.displayUserId.value.toString();

    final String fullText =
        "${whatsapp}?text=مرحبا TRAVEL WIN أريد حجز هذه الرحلة .. هل يمكنك تقديم كافة معلومات الرحلة مع التكلفة " +
            "\n" +
            fullUrlTrip;

    openWhatsApp(fullText, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Trip Info".tr,
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
                    RemoteServices.addTripToFav(trip.value!.id)
                        .then((value) async {
                      print(value.data);
                      if (value.statusCode == 200) {
                        trip.value!.is_favorite = !trip.value!.is_favorite!;
                        favoriteModel.value =
                            (await RemoteServices.fetchFavorite())!;
                        setState(() {});
                      }
                    });
                  },
                  child: Obx(
                    () => trip.value!.is_favorite!
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                  ),
                )
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        //  drawer: MyDrawer(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Stack(
              children: [
                Obx(
                  () => Container(
                    width: 1.sw,
                    height: 310.h,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(trip
                            .value!
                            .images![placeDetailsController.selectedImage.value]
                            .image!),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(),
                    ),
                  ),
                ),
                Positioned(
                  //right: 60.w,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Center(
                      child: SizedBox(
                        height: 55,
                        width: Get.width - 50,
                        child: Center(
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Center(
                                    child: InkWell(
                                      onTap: () {
                                        placeDetailsController
                                            .changeImage(index);
                                      },
                                      child: Obx(
                                        () => index !=
                                                placeDetailsController
                                                    .selectedImage.value
                                            ? SmallImageWidget(
                                                image: trip.value!
                                                    .images![index].image!)
                                            : Container(),
                                      ),
                                    ),
                                  ),
                              separatorBuilder: (context, index) => Obx(
                                    () => index !=
                                            placeDetailsController
                                                .selectedImage.value
                                        ? SizedBox(
                                            width: 0,
                                          )
                                        : Container(),
                                  ),
                              itemCount: trip.value!.images!.length),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: Text(
                Get.locale == Locale('ar')
                    ? trip.value!.nameAr!
                    : trip.value!.nameEn!,
                style: TextStyle(color: mainColor, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Text(
              'Trip Details :'.tr,
              style: TextStyle(
                color: mainColor,
                fontSize: 15.w,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateDetailsWidget(
                    from: Get.locale == Locale('ar')
                        ? trip.value!.fromAr!
                        : trip.value!.fromEn!,
                    name: 'from :'.tr,
                    width: 150.w,
                  ),
                  DateDetailsWidget(
                    from: Get.locale == Locale('ar')
                        ? trip.value!.toAr!
                        : trip.value!.toEn!,
                    name: 'to :'.tr,
                    width: Get.locale == Locale('en') ? 170.w : 150.w,
                  ),
                  // DateDetailsWidget(
                  //   from: trip.value!.date!,
                  //   name: 'Date'.tr + ' :',
                  //   width: Get.locale == Locale('en') ? 110.w : 120.w,
                  // ),
                  // DateDetailsWidget(
                  //   from: Get.locale == Locale('ar')
                  //       ? '${trip.value!.duration!.toString()} يوم'
                  //       : ' day${trip.value!.duration!.toString()}',
                  //   name: 'days count :'.tr,
                  //   width: Get.locale == Locale('en') ? 110.w : 120.w,
                  // ),
                  DateDetailsWidget(
                    from: trip.value!.type! == 'multiple'
                        ? 'Multiple'.tr
                        : 'Single'.tr,
                    name: 'Trip type'.tr + ' :',
                    width: Get.locale == Locale('en') ? 40.w : 50.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            NormalButton(
                color: mainColor,
                fontColor: Colors.white,
                name: 'Book Trip'.tr,
                onTap: () {
                  launchWhatsapp(
                      Get.locale == Locale('ar')
                          ? 'أريد الحجز في الرحلة ${trip.value!.nameAr}'
                          : 'I want to book in the trip ${trip.value!.nameEn!}',
                      whatappnumbers.data![0].number);
                }),
            SizedBox(
              height: 10.h,
            ),
          ],
        ));
  }
}
