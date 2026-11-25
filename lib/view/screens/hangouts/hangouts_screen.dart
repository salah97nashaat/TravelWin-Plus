import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/models/hangout_model.dart';
import 'package:travelwin/services/hangout_service.dart';
import 'package:travelwin/view/screens/hangouts/create_hangout_sheet.dart';
import 'package:travelwin/view/widgets/hangouts/hangout_card.dart';

class HangoutsScreen extends StatefulWidget {
  const HangoutsScreen({Key? key}) : super(key: key);

  @override
  State<HangoutsScreen> createState() => _HangoutsScreenState();
}

class _HangoutsScreenState extends State<HangoutsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'all';
  List<HangoutModel> _hangouts = [];
  bool _isLoading = true;

  // Periodic refresher to clean up expired hangouts from the feed automatically
  Timer? _autoRefreshTimer;

  // Pulse animation controller for the Live radar badge
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<Map<String, dynamic>> get _filterCategories => [
        {'type': 'all', 'title': 'All'.tr, 'icon': Icons.apps_rounded},
        {'type': 'coffee', 'title': 'Coffee & Meet'.tr, 'icon': Icons.local_cafe_rounded},
        {'type': 'billiard', 'title': 'Billiards & Games'.tr, 'icon': Icons.sports_esports_rounded},
        {'type': 'tour', 'title': 'City Tour'.tr, 'icon': Icons.photo_camera_rounded},
        {'type': 'camp', 'title': 'Camping & Trips'.tr, 'icon': Icons.forest_rounded},
        {'type': 'business', 'title': 'Business Meet'.tr, 'icon': Icons.business_center_rounded},
        {'type': 'sport', 'title': 'Sports & Workout'.tr, 'icon': Icons.sports_soccer_rounded},
        {'type': 'food', 'title': 'Food & Dining'.tr, 'icon': Icons.restaurant_rounded},
      ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadHangouts();

    // Auto check/refresh every 60 seconds to ensure any expired hangout drops off
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted) {
        _checkAndPruneExpired();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHangouts() async {
    setState(() => _isLoading = true);
    final list = await HangoutService.fetchHangouts(
      activityType: _selectedCategory,
    );
    if (mounted) {
      final now = DateTime.now();
      // Client-side filter guarantee: discard any hangout that already expired
      final activeOnly = list.where((h) => h.effectiveExpiresAt.isAfter(now)).toList();
      setState(() {
        _hangouts = activeOnly;
        _isLoading = false;
      });
    }
  }

  void _checkAndPruneExpired() {
    final now = DateTime.now();
    final stillActive = _hangouts.where((h) => h.effectiveExpiresAt.isAfter(now)).toList();
    if (stillActive.length != _hangouts.length) {
      setState(() {
        _hangouts = stillActive;
      });
    }
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateHangoutSheet(
        onCreated: _loadHangouts,
      ),
    );
  }

  void _showSafetyInfo() {
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
                      color: Color(0xFFECFDF5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 26),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Safety Priority'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                'Safety Details Text'.tr,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 18.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'I Understand'.tr,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5B21B6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.radar_rounded, color: Colors.white, size: 16),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              isAr ? 'مين قريب؟ (أنشطة وتجمعات)' : 'Who\'s Nearby? (Hangouts)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: Colors.white, size: 22),
            onPressed: _showSafetyInfo,
            tooltip: 'Safety Standards'.tr,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF8B5CF6),
        onRefresh: _loadHangouts,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Top Modern Gradient Hero Banner
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                isAr ? 'مباشر وتفاعلي' : 'Live & Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          isAr ? 'تجمعات حية تنتهي بانتهاء موعد النشاط' : 'Live meetups expiring with event time',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isAr
                          ? 'تجمع مع أصدقاء جدد حولك لمشاركة طاولة، نشاط أو لعبة ☕🎲'
                          : 'Meet new people around you to share a table, game, or trip ☕🎲',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 1. Stories-style Horizontal Highlights Bar
            if (_hangouts.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6.w),
                            Text(
                              'Today\'s Hangouts Near You'.tr,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FE),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${_hangouts.length} ${isAr ? 'نشط' : 'active'}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF7C3AED),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 100.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          itemCount: _hangouts.length,
                          separatorBuilder: (_, __) => SizedBox(width: 10.w),
                          itemBuilder: (context, idx) {
                            final h = _hangouts[idx];
                            final gradient = HangoutModel.getCategoryGradient(h.activityType);
                            final icon = HangoutModel.getCategoryIcon(h.activityType);

                            return Container(
                              width: 148.w,
                              padding: EdgeInsets.all(9.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: gradient),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon, size: 12.sp, color: Colors.white),
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          h.firstName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11.5.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    h.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_rounded,
                                              size: 11.sp, color: const Color(0xFF64748B)),
                                          SizedBox(width: 3.w),
                                          Text(
                                            h.meetingTime,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: const Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          '${h.seatsJoined}/${h.seatsNeeded}',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF2563EB),
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
              ),

            // 2. Filter Categories Row (Modern Animated Chips)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: SizedBox(
                  height: 38.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    itemCount: _filterCategories.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, idx) {
                      final cat = _filterCategories[idx];
                      final isSel = _selectedCategory == cat['type'];
                      final IconData iconData = cat['icon'] as IconData;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat['type']!);
                          _loadHangouts();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            gradient: isSel
                                ? const LinearGradient(
                                    colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                                  )
                                : null,
                            color: isSel ? null : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED).withOpacity(0.35),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                iconData,
                                size: 14.sp,
                                color: isSel ? Colors.white : const Color(0xFF64748B),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                cat['title']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                  color: isSel ? Colors.white : const Color(0xFF475569),
                                ),
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

            // 3. Hangouts Main Feed
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                ),
              )
            else if (_hangouts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(22.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDE9FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            size: 48,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No active hangouts'.tr,
                          style: TextStyle(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Be first hangout'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
                          onPressed: _openCreateSheet,
                          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                          label: Text(
                            'Create Activity Now'.tr,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.only(top: 8.h, bottom: 85.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      return HangoutCard(
                        key: ValueKey(_hangouts[idx].id),
                        hangout: _hangouts[idx],
                        onRefresh: _loadHangouts,
                      );
                    },
                    childCount: _hangouts.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Create Hangout'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
