import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/hangout_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/hangout_service.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/hangouts/hangout_report_dialog.dart';

class HangoutCard extends StatefulWidget {
  final HangoutModel hangout;
  final VoidCallback? onRefresh;

  const HangoutCard({
    Key? key,
    required this.hangout,
    this.onRefresh,
  }) : super(key: key);

  @override
  State<HangoutCard> createState() => _HangoutCardState();
}

class _HangoutCardState extends State<HangoutCard> {
  bool _isJoining = false;

  void _handleJoin() {
    if (isUserProfileIncomplete()) {
      _showIncompleteProfileAlert();
      return;
    }

    // Show quick join confirmation dialog
    final TextEditingController noteCtrl = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.handshake_rounded,
                        color: Color(0xFF2563EB), size: 24),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Join Request'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                '${'Send quick msg to'.tr} (${widget.hangout.firstName}):',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF64748B)),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: noteCtrl,
                maxLines: 2,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: 'Join hint'.tr,
                  hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                      ),
                      child: Text('Cancel'.tr, style: TextStyle(fontSize: 13.sp)),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        setState(() => _isJoining = true);
                        final res = await HangoutService.joinHangout(
                          widget.hangout.id,
                          message: noteCtrl.text.trim(),
                        );
                        setState(() => _isJoining = false);

                        Get.snackbar(
                          res['success'] == true ? 'Success'.tr : 'Alert'.tr,
                          res['message'] ?? '',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: res['success'] == true
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(12.w),
                          borderRadius: 12.r,
                        );

                        if (res['success'] == true && widget.onRefresh != null) {
                          widget.onRefresh!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        elevation: 0,
                      ),
                      child: Text('Send Request'.tr,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIncompleteProfileAlert() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off_rounded,
                  color: Color(0xFFEF4444),
                  size: 34,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Profile Incomplete'.tr,
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Profile Incomplete Desc'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.ProfileScreen);
                },
                icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                label: Text(
                  'Complete Profile Now'.tr,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  minimumSize: Size(double.infinity, 44.h),
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel'.tr,
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF94A3B8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => HangoutReportDialog(
        hangoutId: widget.hangout.id,
        hangoutTitle: widget.hangout.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = HangoutModel.getCategoryGradient(widget.hangout.activityType);
    final categoryIcon = HangoutModel.getCategoryIcon(widget.hangout.activityType);
    final categoryTitle = HangoutModel.getCategoryTitle(widget.hangout.activityType);

    final bool isFull = widget.hangout.availableSeats <= 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. TOP BAR: Category + Countdown + Prominent Red Report Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                // Category Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.first.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, color: Colors.white, size: 14.sp),
                      SizedBox(width: 5.w),
                      Text(
                        categoryTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Expiry countdown pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: Color(0xFFB45309)),
                      SizedBox(width: 4.w),
                      Text(
                        widget.hangout.timeLeftFormatted,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Prominent Red Report / Complaint Button
                InkWell(
                  onTap: _openReportDialog,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                          color: const Color(0xFFFCA5A5), width: 1.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.flag_rounded,
                          size: 13,
                          color: Color(0xFFEF4444),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Report'.tr,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. MAIN CONTENT
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity Title
                Text(
                  widget.hangout.title,
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                    height: 1.3,
                  ),
                ),

                // Place name & Win Pass badge
                if (widget.hangout.placeName != null &&
                    widget.hangout.placeName!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 16, color: Color(0xFFEA580C)),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          widget.hangout.placeName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                      if (widget.hangout.hasWinPass) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.5.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF059669), Color(0xFF10B981)],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.confirmation_num_rounded,
                                  color: Colors.white, size: 12),
                              SizedBox(width: 3.w),
                              Text(
                                'Win Pass Discount'.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Note / Details if provided
                if (widget.hangout.note != null &&
                    widget.hangout.note!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Text(
                      widget.hangout.note!,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: const Color(0xFF475569),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 12.h),

                // 3. BOTTOM INFO & ACTION ROW
                Row(
                  children: [
                    // Creator Avatar
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: const Color(0xFFE2E8F0),
                      backgroundImage: (widget.hangout.creatorImage.isNotEmpty &&
                              Uri.tryParse(widget.hangout.creatorImage)
                                      ?.hasScheme ==
                                  true)
                          ? NetworkImage(widget.hangout.creatorImage)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                    SizedBox(width: 8.w),

                    // Creator first name & Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hangout.firstName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  size: 13, color: Color(0xFF64748B)),
                              SizedBox(width: 3.w),
                              Text(
                                widget.hangout.meetingTime,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              const Icon(Icons.people_outline_rounded,
                                  size: 13, color: Color(0xFF64748B)),
                              SizedBox(width: 3.w),
                              Text(
                                '${widget.hangout.seatsJoined}/${widget.hangout.seatsNeeded} ${'Seats Label'.tr}',
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Join Action Button
                    ElevatedButton(
                      onPressed: (isFull || _isJoining) ? null : _handleJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFull
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF2563EB),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isJoining
                          ? SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isFull ? 'Seats Full'.tr : 'Join Request'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
    );
  }
}
