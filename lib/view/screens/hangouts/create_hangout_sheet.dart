import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/hangout_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/hangout_service.dart';
import 'package:travelwin/utils/my_string.dart';

class CreateHangoutSheet extends StatefulWidget {
  final VoidCallback onCreated;

  const CreateHangoutSheet({Key? key, required this.onCreated}) : super(key: key);

  @override
  State<CreateHangoutSheet> createState() => _CreateHangoutSheetState();
}

class _CreateHangoutSheetState extends State<CreateHangoutSheet> {
  String _selectedCategory = 'coffee';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _placeSearchController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(text: '8:00 مساءً');

  int? _selectedPlaceId;
  String? _selectedPlaceName;
  bool _hasWinPass = false;
  int _seatsNeeded = 1;
  bool _isLoading = false;

  List<Map<String, dynamic>> _placeResults = [];
  bool _isSearchingPlaces = false;

  final List<Map<String, dynamic>> _categories = [
    {'type': 'coffee', 'title': 'قهوة وتعارف', 'icon': Icons.local_cafe_rounded},
    {'type': 'billiard', 'title': 'بلياردو وألعاب', 'icon': Icons.sports_esports_rounded},
    {'type': 'tour', 'title': 'جولة سياحية', 'icon': Icons.photo_camera_rounded},
    {'type': 'camp', 'title': 'تخييم ورحلات', 'icon': Icons.forest_rounded},
    {'type': 'business', 'title': 'لقاء أعمال', 'icon': Icons.business_center_rounded},
    {'type': 'sport', 'title': 'رياضة وتمارين', 'icon': Icons.sports_soccer_rounded},
    {'type': 'food', 'title': 'طعام ومطاعم', 'icon': Icons.restaurant_rounded},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _placeSearchController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _searchPlaces(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _placeResults = []);
      return;
    }
    setState(() => _isSearchingPlaces = true);
    final results = await HangoutService.searchPlaces(q.trim());
    if (mounted) {
      setState(() {
        _placeResults = results;
        _isSearchingPlaces = false;
      });
    }
  }

  Future<void> _submitHangout() async {
    // 1. Profile Completion Check
    if (isUserProfileIncomplete()) {
      Navigator.of(context).pop();
      _showIncompleteProfileAlert();
      return;
    }

    // 2. Title Validation
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى كتابة عنوان مختصر للنشاط (مثلاً: شرب قهوة في كافيه)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await HangoutService.createHangout(
      activityType: _selectedCategory,
      title: _titleController.text.trim(),
      placeId: _selectedPlaceId,
      placeName: _selectedPlaceName ?? _placeSearchController.text.trim(),
      meetingTime: _timeController.text.trim().isEmpty
          ? 'اليوم مساءً'
          : _timeController.text.trim(),
      seatsNeeded: _seatsNeeded,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      if (mounted) Navigator.of(context).pop();
      widget.onCreated();
      Get.snackbar(
        'تم بنجاح 🎉',
        'تم نشر دعوتك! ستنتهي الدعوة تلقائياً بعد 24 ساعة.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        res['message'] ?? 'فشل إنشاء النشاط',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
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
                'الملف الشخصي غير مكتمل ⚠️',
                style: TextStyle(
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'لضمان أمان وموثوقية مجتمع Travel Win، لا يمكن إنشاء نشاط أو البحث عن شريك قبل إكمال بياناتك الشخصية (الاسم، رقم الهاتف، والصورة الشخصية).',
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
                  'إكمال الملف الشخصي الآن',
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
                  'إلغاء',
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF94A3B8)),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet Handle
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE9FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.groups_rounded,
                        color: Color(0xFF8B5CF6), size: 22),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أنشئ دعوة نشاط أو طلعة 🤝',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'تنتهي صلاحية الدعوة تلقائياً بعد 24 ساعة',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // 1. Choose Category
              Text(
                'نوع النشاط:',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 42.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, idx) {
                    final cat = _categories[idx];
                    final isSel = _selectedCategory == cat['type'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat['type']),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSel
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              cat['icon'] as IconData,
                              size: 16.sp,
                              color: isSel ? Colors.white : const Color(0xFF64748B),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              cat['title'],
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight:
                                    isSel ? FontWeight.bold : FontWeight.normal,
                                color: isSel ? Colors.white : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 14.h),

              // 2. Activity Title
              Text(
                'عنوان النشاط:',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: 13.5.sp),
                decoration: InputDecoration(
                  hintText: 'مثال: قهوة ودردشة في باشاك شهير، بلياردو اليوم...',
                  hintStyle: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // 3. Place / Partner Linking
              Text(
                'المكان (اختر مكاناً مسجلاً للاستفادة من خصومات وين باس):',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: _placeSearchController,
                onChanged: _searchPlaces,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFF94A3B8), size: 20),
                  suffixIcon: _selectedPlaceName != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedPlaceId = null;
                              _selectedPlaceName = null;
                              _hasWinPass = false;
                              _placeSearchController.clear();
                              _placeResults = [];
                            });
                          },
                        )
                      : null,
                  hintText: 'ابحث عن كافيه، مطعم، أو معلم مسجل...',
                  hintStyle: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),

              // Selected Place Win Pass Badge
              if (_selectedPlaceName != null && _hasWinPass) ...[
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: Color(0xFF059669), size: 18),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'رائع! هذا المكان يقدم خصم حصري عبر بطاقة وين باس 🎫',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065F46),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Autocomplete Results
              if (_placeResults.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 160.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _placeResults.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    itemBuilder: (context, idx) {
                      final p = _placeResults[idx];
                      final bool pHasWinPass = p['has_win_pass'] == true;
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.location_on,
                          color: pHasWinPass
                              ? const Color(0xFF059669)
                              : const Color(0xFF64748B),
                          size: 20,
                        ),
                        title: Text(
                          p['name'] ?? '',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          p['address'] ?? '',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                        trailing: pHasWinPass
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  'وين باس 🎫',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF065F46),
                                  ),
                                ),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedPlaceId = p['id'];
                            _selectedPlaceName = p['name'];
                            _hasWinPass = pHasWinPass;
                            _placeSearchController.text = p['name'];
                            _placeResults = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 14.h),

              // 4. Meeting Time & Seats Row
              Row(
                children: [
                  // Time
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الموعد / التوقيت:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        TextField(
                          controller: _timeController,
                          style: TextStyle(fontSize: 13.sp),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.access_time_rounded,
                                size: 18, color: Color(0xFF64748B)),
                            hintText: '8:00 م',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Seats Needed
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المقاعد المطلوبة:',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _seatsNeeded,
                              isExpanded: true,
                              items: [1, 2, 3, 4, 5].map((count) {
                                return DropdownMenuItem<int>(
                                  value: count,
                                  child: Text(
                                    '$count ${count == 1 ? "شخص" : "أشخاص"}',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _seatsNeeded = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // 5. Note / Details
              Text(
                'ملاحظة أو فكرة اللقاء (اختياري):',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 6.h),
              TextField(
                controller: _noteController,
                maxLines: 2,
                style: TextStyle(fontSize: 13.sp),
                decoration: InputDecoration(
                  hintText: 'مثال: الحساب عليّ، حابب نتعرف وندردش بمجال العمل...',
                  hintStyle: TextStyle(
                      fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // 6. Submit Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitHangout,
                icon: _isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 20),
                label: _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'نشر الدعوة الآن (سارية 24 ساعة) 🚀',
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
    );
  }
}
