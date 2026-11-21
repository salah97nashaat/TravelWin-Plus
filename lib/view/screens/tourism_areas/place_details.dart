import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:travelwin/helpers/helper.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/logic/controllers/area_details_controller.dart';
// import 'package:travelwin/logic/controllers/home_controller.dart';
// import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/logic/controllers/place_details_controller.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../routes/routes.dart';
// import 'package:travelwin/view/widgets/tourism_place.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
// import '../../widgets/bookmark_widget.dart';
import '../../widgets/normalButton.dart';
// import '../../widgets/place_text.dart';
// import '../../widgets/places_widget.dart';

class PlaceDetails extends StatefulWidget {
  PlaceDetails({Key? key}) : super(key: key);

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  AreaDetailsController areaDetailsController =
      AreaDetailsController(selected: Rx(''));
  final AdController adController = Get.find();
  PlaceDetailsController placeDetailsController = PlaceDetailsController();
  int rated = 0;

  @override
  Widget build(BuildContext context) {
    bool isAr = Get.locale?.languageCode == 'ar';
    var place = statePlaces.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Modern Image Header with Gallery
          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            leading:
                _buildCircleBtn(Icons.arrow_back_ios_new, () => Get.back()),
            actions: [
              _buildCircleBtn(Icons.share_outlined, () {
                Share.share(
                    'https://travelwin1.com/place/share?id_post=${place.id}');
              }),
              SizedBox(width: 10.w),
              Obx(() => _buildCircleBtn(
                    statePlaces.value.isFavorite!
                        ? Icons.favorite
                        : Icons.favorite_border,
                    () => _handleFav(),
                    color: statePlaces.value.isFavorite!
                        ? Colors.red
                        : Colors.black,
                  )),
              SizedBox(width: 15.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(() => _buildGalleryHeader(
                  statePlaces.value)), // CORRECT: Access .value inside
            ),
          ),

          // 2. Info Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(isAr ? place.nameAr! : place.nameEn!,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      ),
                      Obx(() => _buildRatingBadge(statePlaces.value)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _buildLocationRow(isAr),

                  const Divider(height: 40),

                  // Rating/Experience Section
                  _buildExperienceCard(context),

                  SizedBox(height: 20.h),
                  Text("About this place".tr,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  ReadMoreText(
                    isAr ? place.bodyAr! : place.bodyEn!,
                    trimLines: 5,
                    colorClickableText: mainColor,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                        height: 1.6),
                  ),

                  SizedBox(height: 25.h),
                  _buildAskAiButton(
                    placeName: isAr ? (place.nameAr ?? '') : (place.nameEn ?? ''),
                  ),
                  SizedBox(height: 12.h),
                  NormalButton(
                    color: const Color(0xffCD2030),
                    fontColor: Colors.white,
                    name: 'Location'.tr,
                    onTap: () => _openMapLogic(),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAskAiButton({required String placeName}) {
    final bool isAr = Get.locale?.languageCode == 'ar';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              Routes.travelAIAssistantScreen,
              arguments: {
                'placeName': placeName,
              },
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    isAr
                        ? 'اسأل المساعد الذكي عن هذا المكان ✨'
                        : 'Ask AI Guide About This Place ✨',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback onTap,
      {Color color = Colors.black}) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: IconButton(
            icon: Icon(icon, color: color, size: 20.sp), onPressed: onTap),
      ),
    );
  }

  Widget _buildExperienceCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: mainColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: mainColor.withOpacity(0.1))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rate your experience".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: mainColor)),
                Text("Help the community discover great places".tr,
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
              ],
            ),
          ),
          Obx(() => SmoothStarRating(
                rating: placeDetailsController.stars.value,
                onRatingChanged: (v) => _submitRating(v),
                color: const Color(0xffFABF35),
                borderColor: const Color(0xffFABF35),
                size: 20,
              )),
        ],
      ),
    );
  }

  // 1. Modern Rating Badge (Top Right)
  Widget _buildRatingBadge(dynamic place) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xffFABF35).withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xffFABF35), size: 18),
          SizedBox(width: 4.w),
          Text(
            place.rate == null || place.rate == 'null'
                ? '0.0'
                : double.parse(place.rate!).toStringAsFixed(1),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xffD49C00)),
          ),
        ],
      ),
    );
  }

// 2. Immersive Gallery Header (Sliver Background)
  Widget _buildGalleryHeader(dynamic place) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CarouselSlider(
          items: place.images!.map<Widget>((img) {
            return CachedNetworkImage(
              imageUrl: img.url!,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) =>
                  Container(color: Colors.grey.shade100),
            );
          }).toList(),
          options: CarouselOptions(
            height: 350.h,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (index, reason) =>
                placeDetailsController.selectedImage.value = index,
          ),
        ),
        // Overlay gradient to make text/icons pop
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
                Colors.white.withOpacity(0.9),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

// 3. Location Label
  Widget _buildLocationRow(bool isAr) {
    return Row(
      children: [
        Icon(Icons.location_on, color: mainColor, size: 16.sp),
        SizedBox(width: 5.w),
        Text(
          isAr
              ? home.value!.data!.states![stateId.value].nameAr!
              : home.value!.data!.states![stateId.value].nameEn!,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

// 4. Rating Logic
  void _submitRating(double v) {
    if (rated > 0) return; // Prevent double rating
    rated = 1;
    placeDetailsController.stars.value = v;
    RemoteServices.ratePlace(statePlaces.value.id, v).then((value) {
      if (value == 'Completed successfully') {
        showSnackBar(context, 'Rate Added'.tr);
      }
    });
  }

// 5. Favorite Toggle Logic
  void _handleFav() {
    RemoteServices.addPlaceToFav(statePlaces.value.id).then((value) async {
      if (value.statusCode == 200) {
        statePlaces.value.isFavorite = !statePlaces.value.isFavorite!;
        favoriteModel.value = (await RemoteServices.fetchFavorite())!;
        statePlaces.refresh(); // Trigger GetX UI update
      }
    });
  }

// 6. Map Launch Logic
  void _openMapLogic() {
    if (token.value.toString() == 'null') {
      Get.showSnackbar(GetSnackBar(
        message: 'Login is required'.tr,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      ));
    } else {
      MapUtils.openMap(
        double.parse(statePlaces.value.lat!),
        double.parse(statePlaces.value.long!),
      );
    }
  }
}
// @override
// Widget build(BuildContext context) {
//   //print('this page rating is :${statePlaces.value.}');
//   return Scaffold(
//     bottomNavigationBar: Obx(() {
//       if (adController.isBannerAdLoaded.value) {
//         return Container(
//           height: adController.bannerAd.size.height.toDouble(),
//           width: adController.bannerAd.size.width.toDouble(),
//           child: AdWidget(ad: adController.bannerAd),
//         );
//       } else {
//         return SizedBox.shrink();
//       }
//     }),
//     appBar: AppBar(
//       backgroundColor: Colors.white,
//       scrolledUnderElevation: 0.0,
//       title: Text(
//         "Place Details".tr,
//         style: TextStyle(color: Colors.black),
//       ),
//       actions: [
//         Padding(
//           padding: Get.locale == Locale('ar')
//               ? EdgeInsets.only(left: 25.w, top: 5.h)
//               : EdgeInsets.only(right: 25.w, top: 5.h),
//           child: InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               child: Transform.flip(
//                 flipX: Get.locale == Locale('ar') ? false : true,
//                 child: SvgPicture.asset(
//                   'assets/images/back.svg',
//                   height: 30,
//                 ),
//               )),
//         ),
//       ],
//       leadingWidth: 100,
//       leading: Padding(
//         padding: EdgeInsets.only(top: 5.h),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 25.w,
//             ),
//             GestureDetector(
//               onTap: () {
//                 RemoteServices.addPlaceToFav(statePlaces.value.id)
//                     .then((value) async {
//                   print(value.data);
//                   if (value.statusCode == 200) {
//                     statePlaces.value.isFavorite =
//                         !statePlaces.value.isFavorite!;
//                     favoriteModel.value =
//                         (await RemoteServices.fetchFavorite())!;
//                     setState(() {});
//                   }
//                 });
//               },
//               child: Obx(
//                 () => Icon(
//                   statePlaces.value.isFavorite!
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 20.w,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Share.share('https://travelwin1.com/place/share?id_post=' +
//                     statePlaces.value.id.toString() +
//                     '&id_user=' +
//                     profile.value.data!.id.toString());
//               },
//               child: Icon(
//                 Icons.share,
//                 color: Colors.black,
//               ),
//             )
//           ],
//         ),
//       ),
//       centerTitle: true,
//       elevation: 0,
//     ),
//     backgroundColor: Colors.white,
//     body: SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15.w),
//             child: Divider(
//               color: Colors.grey.withOpacity(0.35),
//               thickness: 1,
//             ),
//           ),
//           SizedBox(
//             height: 5.h,
//           ),
//           Stack(
//             children: [
//               Obx(
//                 () => Container(
//                   width: 1.sw,
//                   height: 260.h,
//                   decoration: ShapeDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(statePlaces
//                           .value
//                           .images![placeDetailsController.selectedImage.value]
//                           .url!),
//                       fit: BoxFit.fill,
//                     ),
//                     shape: RoundedRectangleBorder(),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 width: 1.sw,
//                 // right: 60.w,
//                 bottom: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   child: SizedBox(
//                     height: 55,
//                     child: ListView.separated(
//                         shrinkWrap: true,
//                         physics: BouncingScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) => Center(
//                               child: InkWell(
//                                 onTap: () {
//                                   placeDetailsController.changeImage(index);
//                                 },
//                                 child: Obx(
//                                   () => Visibility(
//                                     visible: index !=
//                                         placeDetailsController
//                                             .selectedImage.value,
//                                     child: SmallImageWidget(
//                                         image: statePlaces
//                                             .value.images![index].url!),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         separatorBuilder: (context, index) => Obx(
//                               () => Visibility(
//                                 visible: index !=
//                                     placeDetailsController.selectedImage.value,
//                                 child: SizedBox(
//                                   width: 10,
//                                 ),
//                               ),
//                             ),
//                         itemCount: statePlaces.value.images!.length),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 15.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(
//                         right: Get.locale == Locale('ar') ? 20.h : 0,
//                         left: Get.locale == Locale('ar') ? 0 : 20.h),
//                     child: SizedBox(
//                       width: 180.w,
//                       child: Text(
//                         Get.locale == Locale('ar')
//                             ? statePlaces.value.nameAr!
//                             : statePlaces.value.nameEn!,
//                         maxLines: 2,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10.h,
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.star_rounded,
//                         color: Color(0xffFABF35),
//                       ),
//                       Text(
//                         statePlaces.value.rate.toString() == 'null'
//                             ? '0'
//                             : double.parse(statePlaces.value.rate!)
//                                 .round()
//                                 .toString(),
//                         style: TextStyle(
//                             color: Color(0xff636363), fontSize: 16.sp),
//                       ),
//                       SizedBox(
//                         width: 5.w,
//                       ),
//                       Text(
//                         "/",
//                         style:
//                             TextStyle(color: Color(0xff636363), fontSize: 16.w),
//                       ),
//                       SizedBox(
//                         width: 5.w,
//                       ),
//                       SizedBox(
//                         width: 120.w,
//                         child: AutoSizeText(
//                           Get.locale == Locale('ar')
//                               ? home.value!.data!.states![stateId.value].nameAr!
//                               : home
//                                   .value!.data!.states![stateId.value].nameEn!,
//                           style: TextStyle(
//                               color: Color(0xff636363), fontSize: 7.sp),
//                         ),
//                       ),
//                       Icon(
//                         Icons.location_pin,
//                         color: Color(0xff636363),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 15.w,
//               ),
//               Container(
//                 height: 65.h,
//                 width: 165.w,
//                 decoration: BoxDecoration(
//                   color: mainColor,
//                   borderRadius: Get.locale == Locale('ar')
//                       ? BorderRadius.only(
//                           topRight: Radius.circular(15),
//                           bottomRight: Radius.circular(15))
//                       : BorderRadius.only(
//                           topLeft: Radius.circular(15),
//                           bottomLeft: Radius.circular(15)),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Text(
//                       'Rate Now'.tr,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(
//                       height: 6.h,
//                     ),
//                     Text(
//                       'Share your experience to help others'.tr,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: Get.locale == Locale('ar') ? 9.w : 7.w),
//                     ),
//                     Obx(
//                       () => SmoothStarRating(
//                         allowHalfRating: true,
//                         defaultIconData: Icons.star_border_rounded,
//                         filledIconData: Icons.star_rate_rounded,
//                         halfFilledIconData: Icons.star_half_rounded,
//                         onRatingChanged: (v) {
//                           if (rated > 0) {
//                           } else {
//                             rated = 1;
//                             placeDetailsController.stars.value = v;
//                             RemoteServices.ratePlace(statePlaces.value.id, v)
//                                 .then((value) {
//                               if (value == 'Completed successfully') {
//                                 showSnackBar(context, 'Rate Added'.tr);
//                               } else {

//                               }
//                             });
//                           }
//                         },
//                         starCount: 5,
//                         rating: placeDetailsController.stars.value,
//                         size: 25.0,
//                         color: Color(0xffFABF35),
//                         borderColor: Color(0xffFABF35),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 25.w),
//             child: SizedBox(
//               height: 220.h,
//               child: SingleChildScrollView(
//                 child: ReadMoreText(
//                   Get.locale == Locale('ar')
//                       ? statePlaces.value.bodyAr!
//                       : statePlaces.value.bodyEn!,
//                   style: TextStyle(color: Colors.grey, fontSize: 12.sp),
//                   trimLines: 200,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           NormalButton(
//               color: Color(0xffCD2030),
//               fontColor: Colors.white,
//               name: 'Location'.tr,
//               onTap: () {
//                 token.value.toString() == 'null'
//                     ? Get.showSnackbar(GetSnackBar(
//                         message: 'Login is required'.tr,
//                         duration: Duration(seconds: 5),
//                       ))
//                     : MapUtils.openMap(double.parse(statePlaces.value.lat!),
//                         double.parse(statePlaces.value.long!));
//               }),
//           SizedBox(
//             height: 10.h,
//           ),
//         ],
//       ),
//     ),
//   );
// }

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
            fit: BoxFit.cover,
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
