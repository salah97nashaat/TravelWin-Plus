import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/win_pass_model.dart';
import 'package:travelwin/services/win_pass_service.dart';
import 'package:travelwin/helpers/helper.dart';
import 'win_pass_stamp_sheet.dart';

class WinPassHeroCard extends StatefulWidget {
  final int providerId;
  final String providerName;

  const WinPassHeroCard({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  State<WinPassHeroCard> createState() => _WinPassHeroCardState();
}

class _WinPassHeroCardState extends State<WinPassHeroCard> {
  WinPassProgramModel? _program;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgram();
  }

  Future<void> _loadProgram() async {
    final prog = await WinPassService.fetchProgram(widget.providerId);
    if (mounted) {
      setState(() {
        _program = prog;
        _isLoading = false;
      });
    }
  }

  void _openSheet() {
    if (_program == null || !_program!.hasWinPass) return;
    if (!checkLogin(
      message: Get.locale?.languageCode == 'ar'
          ? 'قسم الكوبونات وبطاقات الخصم مخصص للأعضاء المسجلين.. يرجى تسجيل الدخول لتفعيل خصمك!'
          : 'Coupons are available for registered members. Please sign in!',
    )) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WinPassStampSheet(
        providerId: widget.providerId,
        providerName: widget.providerName,
        initialProgram: _program!,
      ),
    ).then((_) {
      // Re-fetch progress after returning from sheet
      _loadProgram();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_program == null || !_program!.hasWinPass) {
      return const SizedBox.shrink();
    }

    final isAr = Get.locale?.languageCode == 'ar';
    final progress = _program!.userProgress;
    final currentStep = progress?.currentStep ?? 0;
    final totalSteps = _program!.totalSteps;
    final completedCycles = progress?.completedCycles ?? 0;

    return GestureDetector(
      onTap: _openSheet,
      child: Container(
        margin: EdgeInsets.only(top: 14.h, bottom: 8.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF00B67A).withValues(alpha: 0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B67A).withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ambient watermark icon
            Positioned(
              left: isAr ? 10.w : null,
              right: isAr ? null : 10.w,
              bottom: -15.h,
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.confirmation_number_rounded,
                  size: 110.sp,
                  color: Colors.white,
                ),
              ),
            ),

            // Card content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00B67A), Color(0xFF059669)],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00B67A).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.confirmation_number_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'كوبون الخصم (Win Pass)' : 'Discount Pass (Win Pass)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                _program!.minBillAmount > 0
                                    ? (isAr ? 'حد أدنى للطلب: ${_program!.minBillAmount.toInt()} TL • اجمع أختامك 🎁' : 'Min order: ${_program!.minBillAmount.toInt()} TL • Collect stamps 🎁')
                                    : (isAr ? 'اجمع أختامك واحصل على خصومات فورية 🎁' : 'Collect stamps & get instant discounts 🎁'),
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (completedCycles > 0) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                              margin: EdgeInsets.only(left: isAr ? 6.w : 0, right: isAr ? 0 : 6.w),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 11.sp),
                                  SizedBox(width: 2.w),
                                  Text(
                                    isAr ? 'الدورة ${completedCycles + 1}' : 'Cycle ${completedCycles + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B67A).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: const Color(0xFF00B67A).withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              '$currentStep / $totalSteps',
                              style: TextStyle(
                                color: const Color(0xFF34D399),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Mini Progress Track
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: currentStep / totalSteps,
                      minHeight: 6.h,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B67A)),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentStep == 0
                            ? (isAr ? 'ابدأ جمع أختامك الآن مع أول طلب!' : 'Start collecting with your 1st order!')
                            : (progress?.nextRewardValue != null
                                ? (isAr
                                    ? 'هدفك التالي: خصم ${progress!.nextRewardValue} فوري ✨'
                                    : 'Next perk: ${progress!.nextRewardValue} discount ✨')
                                : (isAr ? 'واصل الشراء لفتح الجائزة الكبرى!' : 'Keep going for the grand reward!')),
                        style: TextStyle(
                          color: const Color(0xFFCBD5E1),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            isAr ? 'افتح الكوبون' : 'Open Pass',
                            style: TextStyle(
                              color: const Color(0xFF34D399),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                            color: const Color(0xFF34D399),
                            size: 18.sp,
                          ),
                        ],
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
