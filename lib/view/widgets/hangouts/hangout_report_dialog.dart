import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/services/hangout_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HangoutReportDialog extends StatefulWidget {
  final int hangoutId;
  final String hangoutTitle;

  const HangoutReportDialog({
    Key? key,
    required this.hangoutId,
    required this.hangoutTitle,
  }) : super(key: key);

  @override
  State<HangoutReportDialog> createState() => _HangoutReportDialogState();
}

class _HangoutReportDialogState extends State<HangoutReportDialog> {
  String _selectedReason = 'احتيال أو طلب أموال مشبوه';
  final TextEditingController _detailsController = TextEditingController();
  bool _isLoading = false;

  final List<String> _reasons = [
    'احتيال أو طلب أموال مشبوه',
    'سلوك غير لائق أو مضايقة',
    'إعلان وهمي أو غير حقيقي',
    'عدم الحضور أو انتحال شخصية',
    'أخرى (يرجى التوضيح)',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    setState(() => _isLoading = true);
    final res = await HangoutService.reportHangout(
      widget.hangoutId,
      reason: _selectedReason,
      details: _detailsController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      Get.snackbar(
        res['success'] == true ? 'تم استلام البلاغ' : 'تنبيه',
        res['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: res['success'] == true
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: EdgeInsets.all(12.w),
        borderRadius: 12.r,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFEF4444),
                      size: 26,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تقديم شكوى أو إبلاغ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'نظام حماية المجتمع والأنشطة',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Text(
                'ما هو سبب الإبلاغ عن هذا النشاط؟',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 10.h),

              // Reasons list
              ..._reasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return GestureDetector(
                  onTap: () => setState(() => _selectedReason = reason),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF94A3B8),
                          size: 20,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            reason,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF1E40AF)
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 12.h),

              // Additional details text field
              TextField(
                controller: _detailsController,
                maxLines: 3,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: 'ملاحظات أو تفاصيل إضافية (اختياري)...',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Direct WhatsApp Assistance
              InkWell(
                onTap: () async {
                  final url = Uri.parse(
                      'https://wa.me/905391234567?text=${Uri.encodeComponent('إبلاغ عاجل بخصوص نشاط: ${widget.hangoutTitle}')}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.support_agent_rounded,
                          color: Color(0xFF16A34A), size: 18),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'للحالات العاجلة: تحدث مع الإدارة مباشرة عبر واتساب',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF15803D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'إرسال البلاغ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
}
