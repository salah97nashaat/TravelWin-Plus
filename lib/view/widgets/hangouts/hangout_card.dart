import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/hangout_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/hangout_service.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/helpers/helper.dart';
import 'package:travelwin/logic/controllers/chat_controller.dart';
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
    if (!checkLogin(
      message: Get.locale?.languageCode == 'ar'
          ? 'يجب تسجيل الدخول للانضمام والتفاعل مع الأنشطة القريبة'
          : 'Please sign in to join meetups',
    )) return;

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
                        final isAr = Get.locale?.languageCode == 'ar';

                        Get.snackbar(
                          res['success'] == true ? 'Success'.tr : 'Alert'.tr,
                          res['success'] == true
                              ? (isAr
                                  ? 'تم إرسال طلبك بنجاح! انتظر تواصل صاحب النشاط معك عبر الرسائل للتنسيق.'
                                  : 'Request sent! Please wait for the host to contact you in chat.')
                              : (res['message'] ?? ''),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: res['success'] == true
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(12.w),
                          borderRadius: 12.r,
                          duration: const Duration(seconds: 4),
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

  void _showCreatorRequestsSheet() {
    final isAr = Get.locale?.languageCode == 'ar';
    final requests = widget.hangout.requests;
    final isFull = widget.hangout.seatsJoined >= widget.hangout.seatsNeeded;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: 0.8.sh,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Sheet Title & Close
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Icon(Icons.people_alt_rounded,
                      color: Color(0xFF7C3AED), size: 20),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAr ? 'إدارة مقاعد طلعتك' : 'Manage Hangout Seats',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        widget.hangout.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Seats Status Banner
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isFull ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isFull ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isFull ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    color: isFull ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      isAr
                          ? 'المقاعد المؤكدة: ${widget.hangout.seatsJoined} من ${widget.hangout.seatsNeeded} مقاعد • نسّق مع المهتمين بالرسائل، وعندما تتفق مع شخص اضغط (تأكيد وحجز المقعد).'
                          : 'Confirmed: ${widget.hangout.seatsJoined}/${widget.hangout.seatsNeeded} seats • Chat with applicants and confirm the agreed ones.',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF334155),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Applicants List
            Expanded(
              child: requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined,
                              size: 44, color: const Color(0xFFCBD5E1)),
                          SizedBox(height: 8.h),
                          Text(
                            isAr
                                ? 'لم يتواصل معك أحد بخصوص هذا النشاط حتى الآن'
                                : 'No applicants have contacted you yet',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isAr
                                ? 'عندما يرسل لك أي مستخدم رسالة، ستظهر تفاصيله هنا لتأكيد مقعده'
                                : 'When someone contacts you, they will appear here to confirm their seat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: requests.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final r = requests[index];
                        final isAccepted = (r.status == 'accepted');

                        return Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isAccepted
                                ? const Color(0xFFF0FDF4)
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: isAccepted
                                  ? const Color(0xFFBBF7D0)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: const Color(0xFFE2E8F0),
                                    backgroundImage: (r.applicantImage.isNotEmpty &&
                                            Uri.tryParse(r.applicantImage)
                                                    ?.hasScheme ==
                                                true)
                                        ? NetworkImage(r.applicantImage)
                                        : null,
                                    child: (r.applicantImage.isEmpty ||
                                            Uri.tryParse(r.applicantImage)
                                                    ?.hasScheme !=
                                                true)
                                        ? Text(
                                            r.applicantName.isNotEmpty
                                                ? r.applicantName[0]
                                                : 'U',
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF475569)),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.applicantName,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: isAccepted
                                          ? const Color(0xFFDCFCE7)
                                          : const Color(0xFFFEF3C7),
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isAccepted
                                            ? const Color(0xFF86EFAC)
                                            : const Color(0xFFFDE68A),
                                      ),
                                    ),
                                    child: Text(
                                      isAccepted
                                          ? (isAr
                                              ? 'تم حجز المقعد ✅'
                                              : 'Confirmed ✅')
                                          : (isAr
                                              ? 'تواصل جاري'
                                              : 'Chatting'),
                                      style: TextStyle(
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isAccepted
                                            ? const Color(0xFF15803D)
                                            : const Color(0xFFB45309),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (r.message.isNotEmpty) ...[
                                SizedBox(height: 6.h),
                                Text(
                                  '"${r.message}"',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    color: const Color(0xFF475569),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              SizedBox(height: 10.h),

                              // Actions Row
                              Row(
                                children: [
                                  // Chat button
                                  OutlinedButton.icon(
                                    onPressed: () async {
                                      Get.back();
                                      showLoaderDialog();
                                      guideName.value = r.applicantName;
                                      guideImage.value = r.applicantImage;
                                      guidenceId.value = r.applicantId;
                                      chatSubtitle.value = isAr ? 'شريك النشاط' : 'Activity Partner';
                                      await RemoteServices.fetchChatMessages(r.applicantId.toString());
                                      Get.back();
                                      final chatCtrl = Get.isRegistered<ChatController>()
                                          ? Get.find<ChatController>()
                                          : Get.put(ChatController());
                                      chatCtrl.loadMessages();
                                      Get.toNamed(Routes.ChatScreen);
                                    },
                                    icon: const Icon(Icons.chat_outlined,
                                        size: 14),
                                    label: Text(
                                      isAr ? 'محادثة' : 'Chat',
                                      style: TextStyle(fontSize: 11.5.sp),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 6.h),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),

                                  // Confirm seat or Cancel seat
                                  if (!isAccepted)
                                    ElevatedButton.icon(
                                      onPressed: isFull
                                          ? null
                                          : () async {
                                              final res = await HangoutService
                                                  .respondToRequest(
                                                r.id,
                                                action: 'accept',
                                              );
                                              Get.back();
                                              Get.snackbar(
                                                res['success'] == true
                                                    ? (isAr ? 'تم بنجاح' : 'Success')
                                                    : (isAr ? 'تنبيه' : 'Alert'),
                                                res['message'] ?? '',
                                                backgroundColor: res['success'] == true
                                                    ? const Color(0xFF10B981)
                                                    : const Color(0xFFEF4444),
                                                colorText: Colors.white,
                                              );
                                              if (res['success'] == true) {
                                                widget.onRefresh?.call();
                                              }
                                            },
                                      icon: const Icon(Icons.chair_rounded,
                                          size: 14),
                                      label: Text(
                                        isAr
                                            ? 'تأكيد وحجز المقعد'
                                            : 'Confirm Seat',
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF16A34A),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 6.h),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        elevation: 0,
                                      ),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () async {
                                        final res = await HangoutService
                                            .respondToRequest(
                                          r.id,
                                          action: 'reject',
                                        );
                                        Get.back();
                                        Get.snackbar(
                                          isAr ? 'تم الإلغاء' : 'Unbooked',
                                          res['message'] ?? '',
                                          backgroundColor: const Color(0xFF64748B),
                                          colorText: Colors.white,
                                        );
                                        widget.onRefresh?.call();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 4.h),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        isAr ? 'إلغاء المقعد' : 'Cancel Seat',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: const Color(0xFFEF4444),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = HangoutModel.getCategoryGradient(widget.hangout.activityType);
    final categoryIcon = HangoutModel.getCategoryIcon(widget.hangout.activityType);
    final categoryTitle = HangoutModel.getCategoryTitle(widget.hangout.activityType);

    final bool isFull = widget.hangout.availableSeats <= 0;
    final currentUserId = profile.value.data?.id;
    final bool isCreator = (currentUserId != null &&
        currentUserId != 0 &&
        currentUserId == widget.hangout.userId);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1.0 - value)),
            child: child,
          ),
        );
      },
      child: Container(
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

                // Live Ticking Countdown Pill (Hours, Minutes, Seconds)
                HangoutLiveCountdown(
                  expiresAt: widget.hangout.effectiveExpiresAt,
                  onExpired: widget.onRefresh,
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
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w900,
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
                          size: 17, color: Color(0xFFEA580C)),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          widget.hangout.placeName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
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

                    // Action Button: Creator manages seats, others connect to join
                    isCreator
                        ? ElevatedButton.icon(
                            onPressed: _showCreatorRequestsSheet,
                            icon: const Icon(Icons.people_alt_rounded,
                                size: 14, color: Colors.white),
                            label: Text(
                              'Manage Seats'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                          )
                        : ElevatedButton(
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
    ),
  );
}
}

/// Live Ticking Countdown Pill Widget (Hours, Minutes, Seconds)
class HangoutLiveCountdown extends StatefulWidget {
  final DateTime? expiresAt;
  final VoidCallback? onExpired;

  const HangoutLiveCountdown({
    Key? key,
    required this.expiresAt,
    this.onExpired,
  }) : super(key: key);

  @override
  State<HangoutLiveCountdown> createState() => _HangoutLiveCountdownState();
}

class _HangoutLiveCountdownState extends State<HangoutLiveCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _calculateRemaining();
      }
    });
  }

  void _calculateRemaining() {
    if (widget.expiresAt == null) {
      _remaining = Duration.zero;
      return;
    }
    final now = DateTime.now();
    final diff = widget.expiresAt!.difference(now);
    if (diff <= Duration.zero) {
      if (_remaining > Duration.zero) {
        _timer?.cancel();
        widget.onExpired?.call();
      }
      setState(() {
        _remaining = Duration.zero;
      });
    } else {
      setState(() {
        _remaining = diff;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    if (_remaining <= Duration.zero) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_off_outlined, size: 13, color: Color(0xFFDC2626)),
            SizedBox(width: 4.w),
            Text(
              isAr ? 'منتهي' : 'Expired',
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    String formattedText;
    if (days > 0) {
      formattedText = isAr
          ? '$daysي ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
          : '${days}d ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      formattedText =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    final isUrgent = _remaining.inHours < 2;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUrgent ? const Color(0xFFF87171) : const Color(0xFFFBBF24),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUrgent ? Colors.red : Colors.amber).withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUrgent ? Icons.local_fire_department_rounded : Icons.timer_outlined,
            size: 14.5.sp,
            color: isUrgent ? const Color(0xFFEF4444) : const Color(0xFFD97706),
          ),
          SizedBox(width: 4.5.w),
          Text(
            formattedText,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              letterSpacing: 0.6,
              color: isUrgent ? const Color(0xFFB91C1C) : const Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }
}
