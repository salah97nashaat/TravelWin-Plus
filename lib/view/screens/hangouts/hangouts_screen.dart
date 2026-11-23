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

class _HangoutsScreenState extends State<HangoutsScreen> {
  String _selectedCategory = 'all';
  List<HangoutModel> _hangouts = [];
  bool _isLoading = true;

  List<Map<String, String>> get _filterCategories => [
    {'type': 'all', 'title': 'All'.tr},
    {'type': 'coffee', 'title': 'Coffee & Meet'.tr},
    {'type': 'billiard', 'title': 'Billiards & Games'.tr},
    {'type': 'tour', 'title': 'City Tour'.tr},
    {'type': 'camp', 'title': 'Camping & Trips'.tr},
    {'type': 'business', 'title': 'Business Meet'.tr},
    {'type': 'sport', 'title': 'Sports & Workout'.tr},
    {'type': 'food', 'title': 'Food & Dining'.tr},
  ];

  @override
  void initState() {
    super.initState();
    _loadHangouts();
  }

  Future<void> _loadHangouts() async {
    setState(() => _isLoading = true);
    final list = await HangoutService.fetchHangouts(
      activityType: _selectedCategory,
    );
    if (mounted) {
      setState(() {
        _hangouts = list;
        _isLoading = false;
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
                  const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 26),
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
              SizedBox(height: 12.h),
              Text(
                'Safety Details Text'.tr,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups_rounded,
                  color: Colors.white, size: 16),
            ),
            SizedBox(width: 8.w),
            Text(
              'Activity & Table Partner'.tr,
              style: TextStyle(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined,
                color: Color(0xFF10B981), size: 22),
            onPressed: _showSafetyInfo,
            tooltip: 'Safety Standards'.tr,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHangouts,
        child: CustomScrollView(
          slivers: [
            // 1. Stories-style Horizontal Highlights Bar
            if (_hangouts.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 90.h,
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
                              width: 140.w,
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                    color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          gradient:
                                              LinearGradient(colors: gradient),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon,
                                            size: 13.sp, color: Colors.white),
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
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        h.meetingTime,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                      Text(
                                        '${h.seatsJoined}/${h.seatsNeeded}',
                                        style: TextStyle(
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2563EB),
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

            // 2. Filter Categories Row
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
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

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat['type']!);
                          _loadHangouts();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6)
                                          .withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            cat['title']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight:
                                  isSel ? FontWeight.bold : FontWeight.w600,
                              color: isSel
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // 3. Hangouts List
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
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
                          padding: EdgeInsets.all(20.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDE9FE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.groups_rounded,
                            size: 44,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No active hangouts'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
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
                          icon: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                          label: Text(
                            'Create Activity Now'.tr,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 12.h),
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
                padding: EdgeInsets.only(top: 8.h, bottom: 80.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      return HangoutCard(
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
        backgroundColor: const Color(0xFF8B5CF6),
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
