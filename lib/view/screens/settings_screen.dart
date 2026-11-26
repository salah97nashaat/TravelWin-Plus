import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../helpers/adv/admob_banner.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import '../../routes/routes.dart';
import '../widgets/setting/share_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final SettingController settingController = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  final GetStorage authBox = GetStorage();
  final ImagePicker _picker = ImagePicker();

  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool _hasProfileImage() {
    final imageUrl = profile.value.data?.image;
    if (imageUrl == null || imageUrl.isEmpty) return false;
    final uri = Uri.tryParse(imageUrl);
    return uri != null &&
        uri.hasScheme &&
        uri.host.isNotEmpty &&
        !uri.path.endsWith('/public/') &&
        uri.path != '/';
  }

  void _showImagePickerSheet(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                isAr ? "تحديث الصورة الشخصية" : "Update Profile Photo",
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                isAr
                    ? "اختر صورة واضحة لتعزيز مصداقيتك في الأنشطة والتواصل"
                    : "Choose a clear photo to enhance your profile and meetups",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerOption(
                      icon: Icons.camera_alt_rounded,
                      color: const Color(0xFF0284C7),
                      title: isAr ? "الكاميرا" : "Camera",
                      onTap: () => _pickAndUploadImage(ImageSource.camera),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _buildPickerOption(
                      icon: Icons.photo_library_rounded,
                      color: const Color(0xFF10B981),
                      title: isAr ? "المعرض" : "Gallery",
                      onTap: () => _pickAndUploadImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final userData = profile.value.data;
      if (userData == null) return;

      Get.snackbar(
        Get.locale?.languageCode == 'ar' ? 'جاري التحميل...' : 'Uploading...',
        Get.locale?.languageCode == 'ar'
            ? 'يتم تحديث صورتك الشخصية الآن'
            : 'Updating your profile picture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0284C7),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      authController.EditProfile(
        id: userData.id.toString(),
        name: userData.name ?? '',
        age: userData.age?.toString() ?? '',
        mobile: userData.mobile?.toString() ?? '',
        email: userData.email ?? '',
        country_code: userData.country_code ?? '',
        dialcode: userData.dialcode ?? '',
        living_country: userData.living_country ?? '',
        gender: userData.gender ?? '',
        controller: authController,
        newImage: picked.path,
      );
    } catch (e) {
      debugPrint('[SettingsScreen] Photo upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String token = authBox.read('token').toString();
    final bool isLoggedIn = token != 'null' && token.isNotEmpty;
    final bool isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF1E293B),
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings".tr,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        children: [
          // 1. HERO PROFILE CARD
          Obx(() => _buildHeroProfileCard(isLoggedIn, isAr)),

          SizedBox(height: 18.h),

          // 2. ACCOUNT & PREFERENCES SECTION
          _buildSectionHeader(isAr ? "الحساب والتفضيلات" : "Account & Preferences"),
          _buildCardContainer([
            // Language Item
            _buildSettingTile(
              icon: Icons.language_rounded,
              iconColor: const Color(0xFF2563EB),
              title: "Language".tr,
              subtitle: isAr ? "العربية (تم التحديد)" : "English (Selected)",
              trailing: _buildLanguageSelectorBadge(isAr),
              onTap: () => _showLanguageModal(context, isAr),
            ),
            if (isLoggedIn) ...[
              const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),
              // Edit Profile Details
              _buildSettingTile(
                icon: Icons.badge_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: isAr ? "البيانات الشخصية الكاملة" : "Full Profile Info",
                subtitle: isAr ? "الاسم، العمر، رقم الهاتف، الدولة" : "Name, age, phone, country",
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: () => Get.toNamed(Routes.EditProfileScreen),
              ),
            ],
          ]),

          SizedBox(height: 18.h),

          // 3. SMART TRAVEL TOOLS
          _buildSectionHeader(isAr ? "أدوات المسافر الذكية" : "Smart Travel Tools"),
          _buildCardContainer([
            // AI Salo
            _buildSettingTile(
              iconWidget: Container(
                width: 38.w,
                height: 38.w,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4285F4), Color(0xFF9B51E0), Color(0xFFEA4335)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 19),
              ),
              title: "AI Salo",
              subtitle: isAr ? "مساعد السفر الذكي المدعوم بالذكاء الاصطناعي" : "AI Travel Assistant",
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "AI ✦",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
              onTap: () => Get.toNamed(Routes.travelAIAssistantScreen),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),

            // Currency Converter
            _buildSettingTile(
              icon: Icons.currency_exchange_rounded,
              iconColor: const Color(0xFF0284C7),
              title: isAr ? "محول العملات ومصاريف السفر" : "Currency Converter",
              subtitle: isAr ? "أسعار الليرة، الدولار، اليورو، والريال لحظياً" : "Live travel rates & expenses",
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              onTap: () => Get.toNamed(Routes.currencyConverterScreen),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),

            // Emergency Guide
            _buildSettingTile(
              icon: Icons.emergency_rounded,
              iconColor: const Color(0xFFEF4444),
              title: isAr ? "دليل الطوارئ والعبارات السياحية" : "Emergency & Phrase Guide",
              subtitle: isAr ? "أرقام الإسعاف والشرطة والترجمة السريعة" : "Police, ambulance & key phrases",
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              onTap: () => Get.toNamed(Routes.emergencyGuideScreen),
            ),
          ]),

          SizedBox(height: 18.h),

          // 4. PLATFORMS & COMMUNITY
          _buildSectionHeader(isAr ? "المنصات والمجتمع" : "Platforms & Community"),
          _buildCardContainer([
            // Trends Blog
            _buildSettingTile(
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xFF0284C7),
              title: isAr ? "مدونة تريندات وسياحة TravelWin" : "TravelWin Trends Blog",
              subtitle: "trends.travelwin1.com",
              trailing: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF94A3B8)),
              onTap: () => launchUrlString('https://trends.travelwin1.com', mode: LaunchMode.externalApplication),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),

            // English Blog
            _buildSettingTile(
              icon: Icons.public_rounded,
              iconColor: const Color(0xFFF97316),
              title: isAr ? "منصة TravelWin الإنجليزية" : "TravelWin English Platform",
              subtitle: "entravelwin.travelwin1.com",
              trailing: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF94A3B8)),
              onTap: () => launchUrlString('https://entravelwin.travelwin1.com/', mode: LaunchMode.externalApplication),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),

            // Share App
            _buildSettingTile(
              icon: Icons.share_rounded,
              iconColor: const Color(0xFF10B981),
              title: isAr ? "مشاركة التطبيق مع الأصدقاء" : "Share TravelWin",
              subtitle: isAr ? "ساعد أصدقاءك في خوض تجارب سفر مميزة" : "Share with friends & family",
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
              onTap: () => ShareWidget(),
            ),
          ]),

          SizedBox(height: 18.h),

          // 5. SESSION & SECURITY
          _buildSectionHeader(isAr ? "الأمان والجلسة" : "Session & Security"),
          _buildCardContainer([
            if (isLoggedIn) ...[
              // Log Out
              _buildSettingTile(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFEA580C),
                title: "Logout From App".tr,
                subtitle: isAr ? "تسجيل الخروج من هذا الجهاز" : "Sign out from this device",
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: () => _confirmLogout(context, isAr),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),
              // Delete Account
              _buildSettingTile(
                icon: Icons.delete_forever_rounded,
                iconColor: const Color(0xFFDC2626),
                title: "DeleteAccount".tr,
                subtitle: isAr ? "حذف الحساب نهائياً مع كافة البيانات" : "Permanently remove your account",
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: () => _confirmDeleteAccount(context, isAr),
              ),
            ] else ...[
              // Login Tile
              _buildSettingTile(
                icon: Icons.login_rounded,
                iconColor: const Color(0xFF2563EB),
                title: isAr ? "تسجيل الدخول / إنشاء حساب" : "Log In / Sign Up",
                subtitle: isAr ? "سجل دخولك لتتمتع بكافة مزايا التطبيق" : "Sign in to access all features",
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
                onTap: () => Get.toNamed(Routes.loginScreen),
              ),
            ],
          ]),

          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  // --- HERO PROFILE CARD ---
  Widget _buildHeroProfileCard(bool isLoggedIn, bool isAr) {
    if (!isLoggedIn) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
              ),
              child: const Icon(Icons.person_rounded, color: Color(0xFF2563EB), size: 30),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? "مرحباً بك زائرنا العزيز" : "Welcome, Guest",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    isAr ? "سجل دخولك لحفظ الرحلات والمشاركة في الأنشطة" : "Sign in to save trips and join meetups",
                    style: TextStyle(fontSize: 11.5.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.loginScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                elevation: 0,
              ),
              child: Text(
                isAr ? "دخول" : "Login",
                style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    final userData = profile.value.data;
    final bool hasImage = _hasProfileImage();
    final String name = (userData?.name != null && userData!.name!.isNotEmpty)
        ? userData.name!
        : (isAr ? 'عضو TravelWin' : 'TravelWin Member');
    final String contact = (userData?.email != null && userData!.email!.isNotEmpty)
        ? userData.email!
        : (userData?.mobile != null ? userData!.mobile.toString() : '');

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: hasImage ? const Color(0xFFE2E8F0) : const Color(0xFFBFDBFE),
          width: hasImage ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (hasImage ? Colors.black : const Color(0xFF2563EB)).withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar with Pulsing Animation if no image
              GestureDetector(
                onTap: () => _showImagePickerSheet(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Outer Pulsing Ring (Active ONLY when no image)
                    if (!hasImage)
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (ctx, child) {
                          return Transform.scale(
                            scale: _pulseScale.value,
                            child: Container(
                              width: 68.w,
                              height: 68.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2563EB).withOpacity(_pulseOpacity.value),
                              ),
                            ),
                          );
                        },
                      ),

                    // Main Avatar Circle
                    Container(
                      width: 62.w,
                      height: 62.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: hasImage ? const Color(0xFF2563EB) : const Color(0xFFF59E0B),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: hasImage
                            ? Image.network(
                                userData!.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                              )
                            : _buildAvatarFallback(),
                      ),
                    ),

                    // Camera / Add Badge at bottom corner
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: hasImage ? const Color(0xFF2563EB) : const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          hasImage ? Icons.camera_alt_rounded : Icons.add_a_photo_rounded,
                          color: Colors.white,
                          size: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Name & Contact
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.5.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (contact.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        contact,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 6.h),

                    // Status Badge (Complete or Prompt)
                    if (hasImage)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 13),
                            SizedBox(width: 4.w),
                            Text(
                              isAr ? "الملف مكتمل 100%" : "Profile 100% Complete",
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => _showImagePickerSheet(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 13),
                              SizedBox(width: 4.w),
                              Text(
                                isAr ? "أضف صورتك لتكتمل هويتك" : "Add photo to complete profile",
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Edit profile icon button
              IconButton(
                onPressed: () => Get.toNamed(Routes.EditProfileScreen),
                icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 26),
                tooltip: isAr ? "تعديل البيانات" : "Edit Profile",
              ),
            ],
          ),

          // Interactive Prompt Card below avatar if no photo
          if (!hasImage) ...[
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => _showImagePickerSheet(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEFF6FF), Color(0xFFF0FDF4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 14),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        isAr
                            ? "اضغط هنا لإضافة صورتك واكتمال حسابك 📸"
                            : "Tap here to add your profile photo 📸",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF2563EB)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Image.asset(
        'assets/images/user.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.person_rounded,
          color: Color(0xFF94A3B8),
          size: 34,
        ),
      ),
    );
  }

  // --- SECTION HEADER & CARD CONTAINER ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 6.w, right: 6.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF64748B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingTile({
    IconData? icon,
    Color? iconColor,
    Widget? iconWidget,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            iconWidget ??
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: (iconColor ?? const Color(0xFF2563EB)).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Icons.settings_rounded,
                    color: iconColor ?? const Color(0xFF2563EB),
                    size: 20.sp,
                  ),
                ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  // --- LANGUAGE SELECTOR BADGE & MODAL ---
  Widget _buildLanguageSelectorBadge(bool isAr) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isAr ? "🇸🇦 العربية" : "🇬🇧 English",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(width: 4.w),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
        ],
      ),
    );
  }

  void _showLanguageModal(BuildContext context, bool isAr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                isAr ? "اختيار لغة التطبيق" : "Choose Language",
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 18.h),
              _buildLanguageOption(
                title: "العربية",
                flag: "🇸🇦",
                isSelected: isAr,
                onTap: () {
                  Navigator.pop(context);
                  settingController.changeLanguage(ara);
                  Get.updateLocale(Locale(ara));
                },
              ),
              SizedBox(height: 10.h),
              _buildLanguageOption(
                title: "English",
                flag: "🇬🇧",
                isSelected: !isAr,
                onTap: () {
                  Navigator.pop(context);
                  settingController.changeLanguage(ene);
                  Get.updateLocale(Locale(ene));
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF0F172A),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB), size: 20),
          ],
        ),
      ),
    );
  }

  // --- LOGOUT & DELETE CONFIRMATIONS ---
  void _confirmLogout(BuildContext context, bool isAr) {
    Get.defaultDialog(
      title: "Logout From App".tr,
      titleStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
      middleText: 'Are you sure you need to logout'.tr,
      middleTextStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF475569)),
      backgroundColor: Colors.white,
      radius: 14.r,
      textCancel: "No".tr,
      cancelTextColor: const Color(0xFF64748B),
      textConfirm: "Yes".tr,
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEA580C),
      onCancel: () => Get.back(),
      onConfirm: () {
        authBox.remove('token');
        authController.signOutFromApp();
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context, bool isAr) {
    Get.defaultDialog(
      title: "attention".tr,
      titleStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: const Color(0xFFDC2626)),
      middleText: 'accountWillBeDeletedIfNotLoginFor30Days'.tr,
      middleTextStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF475569)),
      backgroundColor: Colors.white,
      radius: 14.r,
      textConfirm: "Ok".tr,
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFDC2626),
      onConfirm: () {
        authBox.remove('token');
        authController.signOutFromApp();
      },
    );
  }
}
