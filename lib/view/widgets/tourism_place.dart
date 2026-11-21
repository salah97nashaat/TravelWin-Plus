import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';

import '../../models/NewHome.dart';
import '../../routes/routes.dart';

// class TourismPlace extends StatelessWidget {
//   TourismPlace({super.key, required this.states, required this.index});
//   final States states;
//   final int index;
//   final AdController adController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         stateId.value = index;
//         stateid.value = states.id!;
//         statePlacesForState.value =
//             await RemoteServices.fetchStateArea(states.id);
//         statesPlaces.value = (await RemoteServices.fetchStateAreaPlaces(
//             states.id, statePlacesForState.value!.placesType!.first.id, 1))!;
//         stateImage.value = states.image!;
//         adController.showInterstitialAd();
//         Get.toNamed(Routes.areaDetails);
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.w),
//         child: Material(
//           elevation: 5,
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             height: 187.h,
//             width: Get.width - 30,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(20)),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         states.image ?? '',
//                         fit: BoxFit.cover,
//                         height: Get.height * 0.19,
//                         width: Get.width - 50,
//                       ),
//                     ),
//                     Positioned(
//                         top: 30,
//                         right: 15,
//                         child: SvgPicture.asset(
//                           'assets/images/save-instagram 1.svg',
//                           height: 25.h,
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 15.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Details Place'.tr,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           // Text('اسطنبول -',style: TextStyle(color: Color(0xff92A63D),fontSize: 20.w),),
//                           SizedBox(
//                               width: 200.w,
//                               child: Text(
//                                 Get.locale == Locale('ar')
//                                     ? states.nameAr!
//                                     : states.nameEn!,
//                                 textAlign: Get.locale == Locale('ar')
//                                     ? TextAlign.end
//                                     : TextAlign.start,
//                                 style: TextStyle(
//                                     color: Color(0xffCD2030), fontSize: 15.sp),
//                                 overflow: TextOverflow.ellipsis,
//                               )),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           SvgPicture.asset('assets/images/Vector.svg')
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class TourismPlace extends StatelessWidget {
  final States states;
  final int index;
  final AdController adController = Get.find();

  TourismPlace({super.key, required this.states, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = states.image?.trim() ?? '';
    final hasValidImage = _isValidImageUrl(imageUrl);

    return GestureDetector(
      onTap: () async {
        stateId.value = index;
        stateid.value = states.id!;
        statePlacesForState.value =
            await RemoteServices.fetchStateArea(states.id);
        statesPlaces.value = (await RemoteServices.fetchStateAreaPlaces(
            states.id, statePlacesForState.value!.placesType!.first.id, 1))!;
        stateImage.value = states.image!;
        adController.showInterstitialAd();
        Get.toNamed(Routes.areaDetails);
      },
      child: Container(
        margin: EdgeInsets.only(left: 15.w, bottom: 4.h),
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey.shade200,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: !hasValidImage
                    ? _imageFallback()
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      ),
              ),
            ),
            // Dark Gradient Bottom for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.locale?.languageCode == 'ar'
                        ? states.nameAr!
                        : states.nameEn!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: mainColor, size: 16.sp),
                      SizedBox(width: 5.w),
                      Text(
                        "Discover more".tr,
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Floating Favorite Button
            Positioned(
              top: 15,
              right: 15,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.3),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined,
            color: Colors.white70, size: 42),
      );

  bool _isValidImageUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;

    // The API uses this directory URL when an image field is empty. It is not
    // an image file and NetworkImage throws before errorBuilder can render.
    return !uri.path.endsWith('/public/') && uri.path != '/';
  }
}

class TourismPlace2 extends StatelessWidget {
  const TourismPlace2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.areaDetails);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 220.h,
            width: Get.width - 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/wallpaperflare.com_wallpaper.jpg',
                        fit: BoxFit.cover,
                        height: Get.height * 0.22,
                      ),
                    ),
                    Positioned(
                        top: 30,
                        right: 15,
                        child: SvgPicture.asset(
                          'assets/images/save-instagram 1.svg',
                          height: 25.h,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Details Place'.tr,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'اسطنبول -',
                            style: TextStyle(
                                color: Color(0xff92A63D), fontSize: 20.w),
                          ),
                          Text(
                            'تركيا',
                            style: TextStyle(
                                color: Color(0xffCD2030), fontSize: 20.w),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SvgPicture.asset('assets/images/Vector.svg')
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
