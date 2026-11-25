import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/win_pass_model.dart';
import 'package:travelwin/services/win_pass_service.dart';
import 'win_pass_scanner_screen.dart';

class WinPassStampSheet extends StatefulWidget {
  final int providerId;
  final String providerName;
  final WinPassProgramModel initialProgram;

  const WinPassStampSheet({
    super.key,
    required this.providerId,
    required this.providerName,
    required this.initialProgram,
  });

  @override
  State<WinPassStampSheet> createState() => _WinPassStampSheetState();
}

class _WinPassStampSheetState extends State<WinPassStampSheet> {
  late WinPassProgramModel _program;

  @override
  void initState() {
    super.initState();
    _program = widget.initialProgram;
  }

  Future<void> _refresh() async {
    final updated = await WinPassService.fetchProgram(widget.providerId);
    if (mounted && updated != null) {
      setState(() {
        _program = updated;
      });
    }
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WinPassScannerScreen(
          providerId: widget.providerId,
          providerName: widget.providerName,
          onRedeemed: () {
            _refresh();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final progress = _program.userProgress;
    final currentStep = progress?.currentStep ?? 0;
    final totalSteps = _program.totalSteps;
    final canScan = progress?.canScan ?? true;
    final cooldownSec = progress?.cooldownRemainingSeconds ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),

              SizedBox(height: 14.h),

              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B67A).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.confirmation_number_rounded,
                          color: const Color(0xFF00B67A),
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'كوبون الخصم (Win Pass)' : 'Discount Pass (Win Pass)',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            widget.providerName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Progress Bar & Cycles
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAr ? 'تقدمك في الأختام' : 'Your Stamp Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B67A),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '$currentStep / $totalSteps',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: currentStep / totalSteps,
                        minHeight: 8.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B67A)),
                      ),
                    ),
                    if ((progress?.completedCycles ?? 0) > 0) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: const Color(0xFFFFB800), size: 14.sp),
                          SizedBox(width: 4.w),
                          Text(
                            isAr
                                ? 'أكملت المسار ${progress!.completedCycles} مرة بنجاح! 🏆'
                                : 'Completed cycle ${progress!.completedCycles} times! 🏆',
                            style: TextStyle(
                              color: const Color(0xFFFFB800),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_program.minBillAmount > 0) ...[
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: const Color(0xFF94A3B8), size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            isAr
                                ? 'الحد الأدنى لقيمة الطلب لاحتساب الختم: ${_program.minBillAmount.toInt()} TL'
                                : 'Minimum bill for stamp: ${_program.minBillAmount.toInt()} TL',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // 10 Stamps Grid
              _buildStampsGrid(currentStep),

              SizedBox(height: 20.h),

              // Next Milestone Hint
              _buildNextRewardBanner(isAr, progress),

              SizedBox(height: 20.h),

              // Action CTA: Scan
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canScan ? const Color(0xFF00B67A) : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: canScan ? 3 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: canScan ? _openScanner : null,
                  icon: Icon(
                    canScan ? Icons.qr_code_scanner_rounded : Icons.hourglass_top_rounded,
                    size: 22.sp,
                  ),
                  label: Text(
                    canScan
                        ? (isAr ? 'مسح كود الكاشير الآن (QR)' : 'Scan Cashier QR Now')
                        : (isAr
                            ? 'متبقي ${((cooldownSec / 60).ceil())} دقيقة للطلب القادم'
                            : 'Wait ${((cooldownSec / 60).ceil())} min for next scan'),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStampsGrid(int currentStep) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 12.w,
        runSpacing: 14.h,
        alignment: WrapAlignment.center,
        children: List.generate(10, (index) {
          final stepNum = index + 1;
          final isCompleted = stepNum <= currentStep;
          final isCurrent = stepNum == currentStep + 1;

          // Find reward for this step
          final stepDef = _program.steps.firstWhereOrNull((s) => s.stepNumber == stepNum);
          final hasReward = stepDef != null && stepDef.hasReward;

          return _buildStampItem(
            stepNum: stepNum,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            stepDef: stepDef,
            hasReward: hasReward,
          );
        }),
      ),
    );
  }

  Widget _buildStampItem({
    required int stepNum,
    required bool isCompleted,
    required bool isCurrent,
    required WinPassStepModel? stepDef,
    required bool hasReward,
  }) {
    final isAr = Get.locale?.languageCode == 'ar';
    Color borderColor;
    Color bgColor;
    Widget content;

    if (isCompleted) {
      borderColor = const Color(0xFF00B67A);
      bgColor = const Color(0xFF00B67A);
      content = Icon(Icons.check_rounded, color: Colors.white, size: 22.sp);
    } else if (isCurrent) {
      borderColor = const Color(0xFF00B67A);
      bgColor = const Color(0xFF00B67A).withValues(alpha: 0.1);
      content = Icon(Icons.star_rounded, color: const Color(0xFF00B67A), size: 24.sp);
    } else {
      borderColor = hasReward ? const Color(0xFFFFB800) : Colors.grey.shade300;
      bgColor = hasReward ? const Color(0xFFFFFBEB) : Colors.white;
      content = Text(
        '$stepNum',
        style: TextStyle(
          color: hasReward ? const Color(0xFFD97706) : Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          fontFamily: 'monospace',
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border.all(color: borderColor, width: isCurrent ? 2.5 : 1.5),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: const Color(0xFF00B67A).withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Center(child: content),
            ),
            if (hasReward)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB800),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    stepNum == 10 ? '🎁' : (stepDef?.rewardValue ?? (isAr ? 'خصم' : 'Discount')),
                    style: TextStyle(
                      color: const Color(0xFF78350F),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          hasReward ? (stepDef?.rewardValue ?? '') : (isAr ? 'طلب $stepNum' : 'Order $stepNum'),
          style: TextStyle(
            fontSize: 9.sp,
            color: hasReward ? const Color(0xFFD97706) : Colors.grey.shade600,
            fontWeight: hasReward ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildNextRewardBanner(bool isAr, UserWinPassProgressModel? progress) {
    final nextRewardTitle = progress?.nextRewardTitle;
    final nextRewardVal = progress?.nextRewardValue;

    if (nextRewardVal == null || nextRewardVal.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.card_giftcard_rounded, color: const Color(0xFF059669), size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'مكافأتك القادمة:' : 'Your Next Reward:',
                  style: TextStyle(
                    color: const Color(0xFF065F46),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  nextRewardTitle ?? (isAr ? '$nextRewardVal خصم' : '$nextRewardVal Discount'),
                  style: TextStyle(
                    color: const Color(0xFF047857),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
