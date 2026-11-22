// import 'package:app/controllers/provider_controller.dart';
// import 'package:app/core/constants.dart';
// import 'package:app/models/provider_model.dart';
// import 'package:app/views/widgets/provider_avatar.dart';
// import 'package:app/views/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';
// import 'package:get_storage/get_storage.dart';
import 'provider_avatar.dart';
import 'rating_badge.dart';
import 'rounded_rect_container.dart';

class ProviderListTile extends StatelessWidget {
  const ProviderListTile({super.key, required this.provider});
  final ProviderModel provider;

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    ProviderController controller = Get.find();
    var isAr = Get.locale!.languageCode == "ar";
    var name = isAr ? provider.nameAr! : provider.nameEn!;
    var rating = provider.rating ?? 5;
    var ratingColor = getRatingColor(rating);
    var minFee = provider.minFee ?? 10;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ProviderAvatar(
                  rating: rating, radius: 28, imageUrl: provider.logoUrl),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FIXED: Title Row with Overflow Handling
                    Row(
                      children: [
                        RatingBadge(ratingColor: ratingColor, rating: rating),
                        SizedBox(width: 6.w),
                        Flexible(
                          // <--- Allows the text to shrink
                          child: Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: Colors.black87),
                            overflow: TextOverflow.ellipsis, // <--- Adds "..."
                            maxLines: 1, // <--- Limits to one line
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text("Min $minFee TL",
                            style:
                                secondaryTextStyle.copyWith(fontSize: 11.sp)),
                        Text(" • ", style: secondaryTextStyle),
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text("${provider.openTime} - ${provider.closeTime}",
                            style:
                                secondaryTextStyle.copyWith(fontSize: 11.sp)),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.confirmation_number_rounded, size: 11.sp, color: const Color(0xFF059669)),
                          SizedBox(width: 4.w),
                          Text(
                            'كوبون الخصم (Win Pass) 🎫',
                            style: TextStyle(
                              color: const Color(0xFF047857),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // REACTIVE: Wrap Icon in Obx for instant color change
              GetBuilder<ProviderController>(
                builder: (controller) {
                  // Check live status from the controller's storage logic
                  bool isCurrentlyFav =
                      controller.getFav().contains(provider.id);

                  return IconButton(
                    color: mainColor2,
                    onPressed: () {
                      controller.toggleFav(provider);
                    },
                    icon: Icon(
                      isCurrentlyFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: isCurrentlyFav ? mainColor2 : Colors.black,
                    ),
                  );
                },
              )
            ]),
            // Notes logic...
          ],
        ),
      ),
    );
  }
}
