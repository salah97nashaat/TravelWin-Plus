import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travelwin/models/activity_model.dart';
import 'package:travelwin/const.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/view/screens/activities/join_activityPage.dart'; // Ensure mainColor is here

class ActivityDetailScreen extends StatelessWidget {
  final ActivityModel activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    bool isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      // Floating Bottom Button with Admob Banner
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomAction(context, isAr),
          const AdmobBannerUi(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Immersive Header Image
          _buildSliverAppBar(isAr),

          // 2. Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Status
                  _buildTitleSection(isAr),
                  SizedBox(height: 20.h),

                  // Description
                  Text(
                    "Description".tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    isAr ? activity.descAr : activity.descEn,
                    textAlign: isAr ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      height: 1.65,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Dynamic Rules/Info List (from Database)
                  if ((isAr ? activity.rulesAr : activity.rulesEn).isNotEmpty)
                    _buildRulesSection(isAr),

                  SizedBox(height: 40.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSliverAppBar(bool isAr) {
    return SliverAppBar(
      expandedHeight: 350.h,
      pinned: true,
      backgroundColor: const Color(0xFF0F172A),
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 18),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: activity.image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildTitleSection(bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBadge(activity.status, isAr),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                isAr ? activity.infoAr : activity.infoEn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: isAr ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          isAr ? activity.titleAr : activity.titleEn,
          textAlign: isAr ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildRulesSection(bool isAr) {
    List<String> currentRules = isAr ? activity.rulesAr : activity.rulesEn;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rules & Information".tr,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
          ),
          SizedBox(height: 12.h),
          ...currentRules.map((rule) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 18),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        rule,
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, bool isAr) {
    // 1. Determine the button state based on the status from Laravel
    bool isOpen = activity.status == 'open';
    bool isSoon = activity.status == 'soon';
    bool isClosed = activity.status == 'closed';

    String buttonText = "Join Now".tr;
    Color buttonColor = mainColor;
    bool isButtonEnabled = true;

    if (isSoon) {
      buttonText = "Coming Soon".tr;
      buttonColor = Colors.orange.shade700;
      isButtonEnabled = false; // Cannot click
    } else if (isClosed) {
      buttonText = "Ended".tr;
      buttonColor = Colors.grey.shade600;
      isButtonEnabled = false; // Cannot click
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: Size(double.infinity, 55.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          // Visual feedback for disabled button
          disabledBackgroundColor: buttonColor.withOpacity(0.6),
        ),
        // If enabled, open modal. If disabled, do nothing (null)
        onPressed: isButtonEnabled ? () => _openJoinModal(context) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSoon)
              const Icon(Icons.timer_outlined, color: Colors.white, size: 20),
            if (isSoon) SizedBox(width: 10.w),
            Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String status, bool isAr) {
    Color color = status == 'open'
        ? Colors.green
        : (status == 'soon' ? Colors.orange : Colors.red);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.toUpperCase().tr,
        style: TextStyle(
            color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _openJoinModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: JoinActivityPage(activityId: activity.id),
      ),
    );
  }
}
