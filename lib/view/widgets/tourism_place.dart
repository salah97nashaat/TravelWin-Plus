import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
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
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        width: 168.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
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
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.4, 0.65, 1.0],
                  ),
                ),
              ),
            ),
            // Province Index Badge (Clean number without #)
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // Floating Bookmark
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.white,
                  size: 15.sp,
                ),
              ),
            ),
            // Bottom Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Get.locale?.languageCode == 'ar'
                        ? (states.nameAr ?? '')
                        : (states.nameEn ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                            offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: const Color(0xFF38BDF8), size: 12.sp),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          Get.locale?.languageCode == 'ar'
                              ? 'استكشف المعالم'
                              : 'Explore places',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                            Get.locale?.languageCode == 'ar' ? 'اسطنبول - ' : 'Istanbul - ',
                            style: TextStyle(
                                color: Color(0xff92A63D), fontSize: 20.w),
                          ),
                          Text(
                            Get.locale?.languageCode == 'ar' ? 'تركيا' : 'Turkey',
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
