import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:travelwin/logic/controllers/activities_controller.dart';
import 'package:travelwin/models/activity_model.dart';
import 'package:travelwin/view/screens/activities/activities_card.dart';

class ActivitiesScreen extends StatelessWidget {
  final controller = Get.put(ActivitiesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF), // Fresh light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Activities & Events".tr,
          style: TextStyle(
              color: Color(0xFF1D1E20),
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final isEmpty = controller.activeActivities.isEmpty &&
            controller.commonActivities.isEmpty &&
            controller.finishedActivities.isEmpty;
        if (isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    controller.hasLoadError.value
                        ? Icons.cloud_off_outlined
                        : Icons.event_busy_outlined,
                    size: 48.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    controller.hasLoadError.value
                        ? 'Unable to load activities'.tr
                        : 'No activities available'.tr,
                    textAlign: TextAlign.center,
                  ),
                  if (controller.hasLoadError.value) ...[
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: controller.getActivities,
                      child: Text('Retry'.tr),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ACTIVE SECTION (Horizontal Swipe)
              if (controller.activeActivities.isNotEmpty) ...[
                _buildHeader("🔥 " + "Live Now".tr, "Ongoing events".tr),
                _buildHorizontalList(controller.activeActivities,
                    isActive: true),
              ],

              // 2. UPCOMING SECTION (Horizontal Swipe)
              if (controller.commonActivities.isNotEmpty) ...[
                _buildHeader("⏳ " + "Coming Soon".tr, "Get ready for these".tr),
                _buildHorizontalList(controller.commonActivities,
                    isActive: false),
              ],

              // 3. FINISHED SECTION (Horizontal Swipe)
              if (controller.finishedActivities.isNotEmpty) ...[
                _buildHeader(
                    "🛑 " + "Past Events".tr, "Memories and results".tr),
                _buildHorizontalList(controller.finishedActivities,
                    isActive: false, isFinished: true),
              ],

              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A))),
          Text(subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<ActivityModel> list,
      {required bool isActive, bool isFinished = false}) {
    return SizedBox(
      height: 250.h, // Height for the horizontal cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20.w, right: 10.w),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ActivityCard(
              activity: list[index],
              isActive: isActive,
              isFinished: isFinished);
        },
      ),
    );
  }
}
