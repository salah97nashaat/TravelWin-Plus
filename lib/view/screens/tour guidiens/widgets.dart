import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../../logic/controllers/tourguy_controller.dart';
import '../../../logic/controllers/chat_controller.dart';
import '../../../routes/routes.dart';
import '../../../helpers/helper.dart';

class TourGuyWidget extends StatelessWidget {
  TourGuyWidget({super.key, required this.index});
  final int index;
  final TourGuyController tourGuyController = TourGuyController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353.w,
      height: 324.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 353.w,
              height: 290.h,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x4C005FB6),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'From'.tr + ' ',
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  guidence.value.guidances![index].nationality!,
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  (DateTime.now()
                                              .difference(DateTime.parse(
                                                  guidence
                                                      .value
                                                      .guidances![index]
                                                      .user!
                                                      .age!))
                                              .inDays /
                                          365)
                                      .floor()
                                      .toString(),
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Years old'.tr,
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${guidence.value.guidances![index].trips_count} ',
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Trip'.tr,
                                  style: TextStyle(
                                    color: Color(0xFFC4BDBD),
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SmoothStarRating(
                              allowHalfRating: true,
                              defaultIconData: Icons.star_border_rounded,
                              filledIconData: Icons.star_rate_rounded,
                              halfFilledIconData: Icons.star_half_rounded,
                              onRatingChanged: (v) {},
                              starCount: 5,
                              rating: double.parse(guidence
                                  .value.guidances![index].rate!
                                  .toString()),
                              size: 18.0,
                              color: Color(0xffFABF35),
                              borderColor: Color(0xffFABF35),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    guidence.value.guidances![index].user!.name!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 281.w,
                    height: 58.h,
                    child: Text(
                      Get.locale == Locale('ar')
                          ? guidence.value.guidances![index].bioAR!
                          : guidence.value.guidances![index].bioEN!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Languages'.tr,
                        style: TextStyle(
                          color: Color(0xFFC4BDBD),
                          fontSize: 13.w,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        Get.locale == Locale('ar')
                            ? ' : ${guidence.value.guidances![index].languagesAR![0]}'
                            : ' : ${guidence.value.guidances![index].languagesEn![0]}',
                        style: TextStyle(
                          color: Color(0xFFC4BDBD),
                          fontSize: 13.w,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: 300.w,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0x59808080),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SizedBox(
                      height: 35.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 132,
                                height: 15,
                                child: Text(
                                  Get.locale == Locale('ar')
                                      ? guidence
                                          .value.guidances![index].placesAR!
                                      : guidence
                                          .value.guidances![index].placesEn!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${guidence.value.guidances![index].salary}\$ ',
                                    style: TextStyle(
                                      color: Color(0xFFC4BDBD),
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Per Day'.tr,
                                    style: TextStyle(
                                      color: Color(0xFFC4BDBD),
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Center(
                            child: VerticalDivider(
                              color: Color(0x59808080),
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 132,
                            height: 15,
                            child: Center(
                              child: Text(
                                guidence.value.guidances![index].car == true
                                    ? 'with special car'.tr
                                    : 'without special car'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          if (!checkLogin(
                            message: Get.locale?.languageCode == 'ar'
                                ? 'يرجى تسجيل الدخول لمراسلة المرشد السياحي عبر الشات'
                                : 'Please sign in to chat with the tour guide',
                          )) return;
                          if (token.value != 'null') {
                            showLoaderDialog();
                            await RemoteServices.fetchChatMessages(
                                    guidence.value.guidances![index].user!.id)
                                .then((value) {
                              Get.back();
                              guideName.value =
                                  guidence.value.guidances![index].user!.name!;
                              guideImage.value =
                                  guidence.value.guidances![index].user!.image!;
                              guidenceId.value = guidence
                                  .value.guidances![index].user!.id!
                                  .toInt();
                              chatSubtitle.value =
                                  Get.locale?.languageCode == 'ar'
                                      ? 'مرشد سياحي'
                                      : 'Tourist Guide';
                              final chatCtrl = Get.isRegistered<ChatController>()
                                  ? Get.find<ChatController>()
                                  : Get.put(ChatController());
                              chatCtrl.loadMessages();
                              Get.toNamed(Routes.ChatScreen);
                            });
                          } else {
                            showSnackBar(context, 'Login is required'.tr);
                          }
                        },
                        child: Container(
                          width: 51.12,
                          height: 48.43,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE3F2FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/images/send 3.svg',
                            height: 20.h,
                            // color: Colors.green,
                            colorFilter:
                                ColorFilter.mode(Colors.green, BlendMode.srcIn),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      InkWell(
                        onTap: () {
                          if (token.value != 'null') {
                            guidenceId.value =
                                guidence.value.guidances![index].id!;
                            guidenceIndex.value = index;
                            Get.toNamed(Routes.booking);
                          } else {
                            showSnackBar(context, 'Login is required'.tr);
                          }
                        },
                        child: Container(
                          width: 189,
                          height: 48,
                          decoration: ShapeDecoration(
                            color: Color(0xFF225D84),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Book Trip'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (token.value != 'null') {
                            GuidenceController controller =
                                GuidenceController();
                            RemoteServices.addGuideToFav(
                                    guidence.value.guidances![index].id)
                                .then((value) async {
                              print(value.data);
                              if (value.statusCode == 200) {
                                controller.fetchGuidence();
                                favoriteModel.value =
                                    (await RemoteServices.fetchFavorite())!;
                              }
                            });
                          } else {
                            showSnackBar(context, 'Login is required'.tr);
                          }
                        },
                        child: Container(
                          width: 51.12,
                          height: 48.43,
                          decoration: ShapeDecoration(
                            color: Color(0xFFE3F2FD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                              child: Obx(
                            () => Icon(
                              !guidence.value.guidances![index].is_favorite!
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              color: Color(0xffCD2030),
                              size: 30.w,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 100,
              height: 100,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      guidence.value.guidances![index].user!.image!),
                  fit: BoxFit.cover,
                ),
                shape: OvalBorder(
                  side: BorderSide(width: 1, color: Colors.white),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x56000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
