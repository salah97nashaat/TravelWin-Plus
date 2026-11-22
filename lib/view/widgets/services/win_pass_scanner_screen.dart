import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:travelwin/services/win_pass_service.dart';
import 'win_pass_success_screen.dart';

class WinPassScannerScreen extends StatefulWidget {
  final int providerId;
  final String providerName;
  final VoidCallback? onRedeemed;

  const WinPassScannerScreen({
    super.key,
    required this.providerId,
    required this.providerName,
    this.onRedeemed,
  });

  @override
  State<WinPassScannerScreen> createState() => _WinPassScannerScreenState();
}

class _WinPassScannerScreenState extends State<WinPassScannerScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  bool _isProcessing = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) return;

    _processRedeem(qrToken: code.trim());
  }

  Future<void> _processRedeem({String? qrToken, String? pin}) async {
    setState(() {
      _isProcessing = true;
    });

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00B67A)),
      ),
    );

    final result = await WinPassService.redeem(
      providerId: widget.providerId,
      qrToken: qrToken,
      pin: pin,
    );

    // Dismiss loading indicator
    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    if (!mounted) return;

    if (result.success) {
      widget.onRedeemed?.call();
      // Replace scanner with success screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WinPassSuccessScreen(
            result: result,
            onDismiss: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else {
      setState(() {
        _isProcessing = false;
      });

      _showErrorDialog(result.message);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 8.w),
            Text('تنبيه', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00B67A))),
          ),
        ],
      ),
    );
  }

  void _showManualPinDialog() {
    final TextEditingController pinController = TextEditingController();
    final isAr = Get.locale?.languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                isAr ? 'إدخال الرمز السريع (4 أرقام)' : 'Enter 4-Digit Quick Code',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                isAr
                    ? 'اكتب الرمز المكون من 4 أرقام الظاهر على شاشة الكاشير'
                    : 'Type the 4-digit PIN displayed on cashier screen',
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                autofocus: true,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 14.w,
                  fontFamily: 'monospace',
                  color: const Color(0xFF00B67A),
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••',
                  hintStyle: TextStyle(
                    letterSpacing: 14.w,
                    color: Colors.grey.shade300,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B67A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    final entered = pinController.text.trim();
                    if (entered.length == 4) {
                      Navigator.of(ctx).pop();
                      _processRedeem(pin: entered);
                    }
                  },
                  child: Text(
                    isAr ? 'تأكيد الرمز' : 'Verify Code',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanSize = 250.w;
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Dark overlay with cutout
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.65),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: scanSize,
                    height: scanSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cutout Glowing Border & Animated Laser
          Align(
            alignment: Alignment.center,
            child: Container(
              width: scanSize,
              height: scanSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: const Color(0xFF00B67A),
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedBuilder(
                  animation: _laserAnimation,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(0, (_laserAnimation.value * 2) - 1),
                      child: Container(
                        width: scanSize,
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFF00B67A),
                              Color(0xFF34D399),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF34D399).withValues(alpha: 0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Header Controls
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Text(
                    widget.providerName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: Icon(
                        _torchOn ? Icons.flash_on : Icons.flash_off,
                        color: _torchOn ? const Color(0xFFFFB800) : Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _torchOn = !_torchOn;
                          _scannerController.toggleTorch();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Instruction & Manual PIN CTA
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    isAr
                        ? 'وجّه الكاميرا نحو شاشة الكاشير لمسح كود الـ QR'
                        : 'Align camera with cashier screen QR code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 14.h),
                // 4-Digit Manual Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      side: const BorderSide(color: Color(0xFF00B67A), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: _showManualPinDialog,
                    icon: const Icon(Icons.dialpad_rounded, color: Color(0xFF00B67A)),
                    label: Text(
                      isAr ? 'أو كتابة الرمز اليدوي (4 أرقام) 🔢' : 'Or Enter 4-Digit PIN 🔢',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
