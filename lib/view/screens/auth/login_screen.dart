import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final AuthController _authController = Get.find<AuthController>();

  bool _isPasswordVisible = false;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;

  late AnimationController _entryController;
  late AnimationController _floatingController;

  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;
  late Animation<double> _actionsFade;
  late Animation<Offset> _actionsSlide;
  late Animation<double> _footerFade;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    // 1. Staggered Entrance Animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    ));

    _formFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
    ));

    _actionsFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
    );
    _actionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
    ));

    _footerFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    // 2. Continuous Ambient Floating Animation (slow & relaxing)
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Focus listeners for reactive UI styling
    _emailFocus.addListener(() {
      setState(() => _emailHasFocus = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _passwordHasFocus = _passwordFocus.hasFocus);
    });

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      _authController.logInUsingAPI(email: email, password: password);
    }
  }

  void _toggleLanguage() {
    final settingCtrl = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());
    final currentLang = Get.locale?.languageCode ?? ara;
    if (currentLang == ara) {
      settingCtrl.changeLanguage(ene);
      Get.updateLocale(Locale(ene));
    } else {
      settingCtrl.changeLanguage(ara);
      Get.updateLocale(Locale(ara));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Ambient Background Glow Orbs
          _buildAmbientBackground(),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.h),

                  // Top Navigation & Language Switch Bar
                  _buildTopBar(isAr),

                  SizedBox(height: 16.h),

                  // Header with Animated Logo & Welcome Text
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _buildHeader(isAr),
                    ),
                  ),

                  SizedBox(height: 26.h),

                  // Modern Form Card (Email + Password + Forgot + Login CTA)
                  FadeTransition(
                    opacity: _formFade,
                    child: SlideTransition(
                      position: _formSlide,
                      child: _buildFormCard(isAr),
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Social Logins & Guest Fast-track
                  FadeTransition(
                    opacity: _actionsFade,
                    child: SlideTransition(
                      position: _actionsSlide,
                      child: _buildSecondaryActions(isAr),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Footer: Register new account
                  FadeTransition(
                    opacity: _footerFade,
                    child: _buildFooter(isAr),
                  ),

                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. Ambient Background Decor ---
  Widget _buildAmbientBackground() {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, _) {
        return Stack(
          children: [
            // Top Right Sapphire Glow
            Positioned(
              top: -60 + _floatAnim.value,
              right: -50,
              child: Container(
                width: 240.w,
                height: 240.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      mainColor.withOpacity(0.12),
                      mainColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Middle Left Soft Azure Glow
            Positioned(
              top: 320.h - _floatAnim.value,
              left: -70,
              child: Container(
                width: 220.w,
                height: 220.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0284C7).withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- 2. Top Bar (Back button + Language Switcher) ---
  Widget _buildTopBar(bool isAr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button (if navigated from within the app)
        Navigator.canPop(context)
            ? GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.sp,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              )
            : const SizedBox.shrink(),

        const Spacer(),

        // Language Switcher Chip
        GestureDetector(
          onTap: _toggleLanguage,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 16.sp,
                  color: mainColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  isAr ? 'العربية 🇸🇦' : 'English 🇬🇧',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 3. Header: Animated Logo & Greetings ---
  Widget _buildHeader(bool isAr) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _floatAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnim.value * 0.5),
              child: child,
            );
          },
          child: Hero(
            tag: 'logo',
            child: Container(
              width: 90.w,
              height: 90.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: mainColor.withOpacity(0.15),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(0.14),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icon/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          isAr ? 'مرحباً بك مجدداً! 👋' : 'Welcome Back! 👋',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            isAr
                ? 'سجّل دخولك لمتابعة رحلاتك واستكشاف أحدث الوجهات'
                : 'Sign in to access your trips and discover new destinations',
            style: TextStyle(
              fontSize: 12.5.sp,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // --- 4. Form Card ---
  Widget _buildFormCard(bool isAr) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input Label
            _buildFieldLabel(
              icon: Icons.alternate_email_rounded,
              title: isAr ? 'البريد الإلكتروني' : 'Email Address',
            ),
            SizedBox(height: 8.h),
            _buildEmailField(isAr),

            SizedBox(height: 18.h),

            // Password Input Label
            _buildFieldLabel(
              icon: Icons.lock_outline_rounded,
              title: isAr ? 'كلمة المرور' : 'Password',
            ),
            SizedBox(height: 8.h),
            _buildPasswordField(isAr),

            SizedBox(height: 10.h),

            // Forgot Password Link
            Align(
              alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.toNamed(Routes.forgotPasswordScreen),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    isAr ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Primary Login CTA Button
            _buildLoginButton(isAr),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: mainColor),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(bool isAr) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _emailHasFocus ? mainColor : const Color(0xFFE2E8F0),
          width: _emailHasFocus ? 1.6 : 1.0,
        ),
        boxShadow: _emailHasFocus
            ? [
                BoxShadow(
                  color: mainColor.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocus,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: isAr ? 'أدخل بريدك الإلكتروني' : 'name@example.com',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return isAr
                ? 'يرجى إدخال البريد الإلكتروني'
                : 'Please enter your email';
          }
          if (!RegExp(validationEmail).hasMatch(value.trim())) {
            return 'Invalid email'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(bool isAr) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _passwordHasFocus ? mainColor : const Color(0xFFE2E8F0),
          width: _passwordHasFocus ? 1.6 : 1.0,
        ),
        boxShadow: _passwordHasFocus
            ? [
                BoxShadow(
                  color: mainColor.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocus,
        obscureText: !_isPasswordVisible,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleLogin(),
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: isAr ? '••••••••' : '••••••••',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF94A3B8),
            letterSpacing: 2.0,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: const Color(0xFF64748B),
              size: 20.sp,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return isAr
                ? 'يرجى إدخال كلمة المرور'
                : 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password should be longer or equal to 6 characters'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton(bool isAr) {
    return Obx(() {
      final isLoading = _authController.isLoading.value;

      return Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0D6898),
              Color(0xFF215B82),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isAr ? 'تسجيل الدخول' : 'Log In',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      isAr
                          ? Icons.arrow_back_rounded
                          : Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ],
                ),
        ),
      );
    });
  }

  // --- 5. Secondary Actions (Divider + Social Logins + Guest Entry) ---
  Widget _buildSecondaryActions(bool isAr) {
    return Column(
      children: [
        // "OR" Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFFCBD5E1),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Text(
                isAr ? 'أو المتابعة عبر' : 'Or continue with',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFCBD5E1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Social Buttons: Google & Apple
        Row(
          children: [
            // Google Sign-In Button
            Expanded(
              child: _buildSocialCard(
                title: 'Google',
                iconWidget: Image.asset(
                  'assets/images/Google Logo.png',
                  height: 20.h,
                ),
                onTap: () => _authController.googleSinUpApp(),
              ),
            ),

            if (Platform.isIOS) ...[
              SizedBox(width: 12.w),
              // Apple Sign-In Button (iOS only)
              Expanded(
                child: _buildSocialCard(
                  title: 'Apple',
                  iconWidget: Image.asset(
                    'assets/images/apple.png',
                    height: 20.h,
                  ),
                  onTap: () => _authController.appleSignUpApp(),
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: 14.h),

        // Guest Fast-Track Card (الدخول كزائر)
        _buildGuestCard(isAr),
      ],
    );
  }

  Widget _buildSocialCard({
    required String title,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCard(bool isAr) {
    return InkWell(
      onTap: () {
        // Fast-track navigation directly to main screen as guest
        Get.offAllNamed(Routes.mainScreen);
      },
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: const Color(0xFFBAE6FD),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.explore_outlined,
                size: 20.sp,
                color: const Color(0xFF0284C7),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'المتابعة كزائر 🧭' : 'Continue as Guest 🧭',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0369A1),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isAr
                        ? 'تصفح البرامج والرحلات والأماكن فوراً دون تسجيل'
                        : 'Explore tours, trips, and places without signing in',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF0284C7).withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
              size: 14.sp,
              color: const Color(0xFF0284C7),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. Footer (Don't have an account? Sign up) ---
  Widget _buildFooter(bool isAr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isAr ? 'ليس لديك حساب؟' : "Don't have an Account?",
          style: TextStyle(
            fontSize: 13.5.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: () {
            Get.offNamed(Routes.signUpScreen);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Text(
              isAr ? 'إنشاء حساب جديد' : 'Sign up',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: mainColor,
                decoration: TextDecoration.underline,
                decorationColor: mainColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
