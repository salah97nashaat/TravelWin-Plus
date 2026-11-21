import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:travelwin/models/activity_model.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/screens/activities/activity_detailScreen.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final bool isActive;
  final bool isFinished;

  const ActivityCard({
    super.key, 
    required this.activity, 
    required this.isActive, 
    this.isFinished = false
  });

  @override
  Widget build(BuildContext context) {
    bool isAr = Get.locale?.languageCode == 'ar';

    return GestureDetector(
      onTap: () => Get.to(() => ActivityDetailScreen(activity: activity)),
      child: Container(
        width: Get.width * 0.75, // Card width
        margin: EdgeInsets.only(right: 15.w, bottom: 10.h, top: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: isFinished ? Colors.transparent : Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              // 1. Background Image
              Positioned.fill(
                child: ColorFiltered(
                  // Dim the image if the activity is finished
                  colorFilter: isFinished 
                    ? ColorFilter.mode(Colors.grey.shade800, BlendMode.saturation)
                    : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: CachedNetworkImage(
                    imageUrl: activity.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey.shade200),
                  ),
                ),
              ),
              // 2. Dark Gradient for Text Readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
              // 3. Status Badge
              Positioned(
                top: 15,
                left: isAr ? null : 15,
                right: isAr ? 15 : null,
                child: _buildBadge(),
              ),
              // 4. Content
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? activity.titleAr : activity.titleEn,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white70, size: 12.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            isAr ? activity.infoAr : activity.infoEn,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                          ),
                        ),
                      ],
                    ),
                    if (isActive) ...[
                      SizedBox(height: 10.h),
                      const Divider(color: Colors.white24, thickness: 0.5),
                      Text("Tap to Join Now →".tr, 
                        style: TextStyle(color: mainColor, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    Color color = activity.status == 'open' ? Colors.green : (activity.status == 'soon' ? Colors.orange : Colors.grey);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
       // backdropFilter: const ColorFilter.mode(Colors.black12, BlendMode.blur),
      ),
      child: Text(
        activity.status.tr.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}