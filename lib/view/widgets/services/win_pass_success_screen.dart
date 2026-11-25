import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/models/win_pass_model.dart';

class WinPassSuccessScreen extends StatefulWidget {
  final WinPassRedeemResult result;
  final VoidCallback? onDismiss;

  const WinPassSuccessScreen({
    super.key,
    required this.result,
    this.onDismiss,
  });

  @override
  State<WinPassSuccessScreen> createState() => _WinPassSuccessScreenState();
}

class _WinPassSuccessScreenState extends State<WinPassSuccessScreen>
    with SingleTickerProviderStateMixin {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Live ticking clock every second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm:ss').format(_currentTime);
    final formattedDate = DateFormat('yyyy/MM/dd').format(_currentTime);
    final isAr = Get.locale?.languageCode == 'ar';

    final hasReward = widget.result.rewardType != null &&
        widget.result.rewardType != 'none' &&
        widget.result.rewardValue != null;

    return Scaffold(
      backgroundColor: const Color(0xFF064E3B), // Deep Emerald Green
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient animated background rings
            Positioned(
              top: -80.h,
              right: -80.w,
              child: Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h,
              left: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF047857).withValues(alpha: 0.25),
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Live Verification Pill (Anti-Screenshot)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: const Color(0xFF34D399).withValues(alpha: 0.5),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF34D399),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF34D399),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '$formattedTime • $formattedDate',
                          style: TextStyle(
                            color: const Color(0xFFE6FFFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            fontFamily: 'monospace',
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25.h),

                  // Animated Checkmark Icon with Glow
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF34D399), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF34D399).withValues(alpha: 0.45),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Success Title
                  Text(
                    isAr ? 'تم احتساب طلبك بنجاح! 🎉' : 'Order Recorded! 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 6.h),

                  // Provider Name
                  Text(
                    widget.result.providerName ?? 'Travel Win Partner',
                    style: TextStyle(
                      color: const Color(0xFFA7F3D0),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24.h),

                  // Reward Highlight Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hasReward
                                  ? Icons.local_offer_rounded
                                  : Icons.verified_rounded,
                              color: const Color(0xFF059669),
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              hasReward
                                  ? (isAr ? 'خصم مستحق الآن!' : 'Discount Unlocked!')
                                  : (isAr ? 'ختم جديد أضيف لرصيدك' : 'New Stamp Added!'),
                              style: TextStyle(
                                color: const Color(0xFF065F46),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        if (hasReward) ...[
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF86EFAC),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              widget.result.rewardValue ?? (isAr ? 'خصم فوري' : 'Instant Discount'),
                              style: TextStyle(
                                color: const Color(0xFF15803D),
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            isAr
                                ? 'أبرز هذه الشاشة للكاشير لتطبيق الخصم فوراً'
                                : 'Show this screen to the cashier for immediate discount',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (widget.result.stepNumber == (widget.result.totalSteps ?? 10)) ...[
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: const Color(0xFFFDE68A)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.emoji_events_rounded, color: const Color(0xFFD97706), size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    isAr ? 'أتممت الـ 10 أختام! ستبدأ دورتك الجديدة بطلبك القادم 🏆' : 'All 10 stamps completed! Next visit starts new cycle 🏆',
                                    style: TextStyle(
                                      color: const Color(0xFF92400E),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ] else ...[
                          SizedBox(height: 10.h),
                          Text(
                            isAr
                                ? 'أنت الآن في الختم رقم ${widget.result.stepNumber ?? 1} من ${widget.result.totalSteps ?? 10}'
                                : 'You are now on stamp ${widget.result.stepNumber ?? 1} of ${widget.result.totalSteps ?? 10}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isAr
                                ? 'تابع الشراء للحصول على الخصم القادم والوجبة المجانية!'
                                : 'Keep visiting to unlock the next discount and free reward!',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom Button: Done
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onDismiss?.call();
                      },
                      child: Text(
                        isAr ? 'تم الاستخدام والعودة' : 'Done & Return',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdmobBannerUi(),
    );
  }
}
