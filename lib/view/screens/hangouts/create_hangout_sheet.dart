import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _customPlaceController = TextEditingController();

  // Discount places list for dropdown
  List<Map<String, dynamic>> _discountPlaces = [];
  bool _isLoadingPlaces = true;
  String _selectedPlaceMode = 'select'; // 'select' or 'custom'
  int? _selectedPlaceId;
  String? _selectedPlaceName;
  bool _hasWinPass = false;

  // 3-Day Date Selection
  int _selectedDayIndex = 0; // 0 = Today, 1 = Tomorrow, 2 = Day after tomorrow
  late List<DateTime> _availableDates;

  // Time Selection
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  int _seatsNeeded = 1;
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    final now = DateTime.now();
    _availableDates = [
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
    ];
    _fetchDiscountPlaces();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _customPlaceController.dispose();
    super.dispose();
  }

  Future<void> _fetchDiscountPlaces() async {
    final places = await HangoutService.searchPlaces('');
    if (mounted) {
      setState(() {
        _discountPlaces = places;
        _isLoadingPlaces = false;
        // Pre-select first Win Pass partner if available
        final firstWinPass = places.firstWhereOrNull((p) => p['has_win_pass'] == true) ??
            (places.isNotEmpty ? places.first : null);
        if (firstWinPass != null) {
          _selectedPlaceId = firstWinPass['id'];
          _selectedPlaceName = firstWinPass['name'];
          _hasWinPass = firstWinPass['has_win_pass'] == true;
        }
      });
    }
  }

  Future<void> _pickCustomTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF8B5CF6),
                onPrimary: Colors.white,
                onSurface: Color(0xFF1E293B),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatSelectedTime() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
    return DateFormat('h:mm a', 'ar').format(dt);
  }

  String _getDayTitle(int idx) {
    if (idx == 0) return 'اليوم';
    if (idx == 1) return 'غداً';
    return 'بعد غد';
  }

  String _getDateFormatted(DateTime dt) {
    return DateFormat('d MMMM', 'ar').format(dt);
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

    // 3. Resolve place
    String placeName = '';
    int? placeId;
    if (_selectedPlaceMode == 'custom') {
      placeName = _customPlaceController.text.trim();
      placeId = null;
      if (placeName.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'يرجى كتابة اسم المكان أو المنطقة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
        return;
      }
    } else {
      placeName = _selectedPlaceName ?? '';
      placeId = _selectedPlaceId;
    }

    final chosenDate = _availableDates[_selectedDayIndex];
    final meetingDateStr = DateFormat('yyyy-MM-dd').format(chosenDate);
    final meetingTimeStr = _formatSelectedTime();

    setState(() => _isLoading = true);

    final res = await HangoutService.createHangout(
      activityType: _selectedCategory,
      title: _titleController.text.trim(),
      placeId: placeId,
      placeName: placeName,
      meetingDate: meetingDateStr,
      meetingTime: meetingTimeStr,
      seatsNeeded: _seatsNeeded,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      if (mounted) Navigator.of(context).pop();
      widget.onCreated();
      Get.snackbar(
        'تم بنجاح 🎉',
        'تم نشر دعوتك! ستنتهي الدعوة تلقائياً بعد انتهاء موعد اللقاء.',
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
                          'يمكنك تحديد الموعد حتى 3 أيام قادمة',
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

              // 3. Place Selection (Dropdown of Discount Places + Custom Place)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المكان:',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  if (_hasWinPass && _selectedPlaceMode == 'select')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        'خصم Win Pass 🎫',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065F46),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 6.h),

              // Dropdown Container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPlaceMode == 'custom'
                        ? 'custom_mode'
                        : (_selectedPlaceId != null
                            ? _selectedPlaceId.toString()
                            : (_discountPlaces.isNotEmpty
                                ? _discountPlaces.first['id'].toString()
                                : 'custom_mode')),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_rounded,
                        color: Color(0xFF64748B)),
                    items: [
                      // List of Discount / Partner Places
                      ..._discountPlaces.map((p) {
                        final bool hasWP = p['has_win_pass'] == true;
                        return DropdownMenuItem<String>(
                          value: p['id'].toString(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.storefront_rounded,
                                size: 18,
                                color: hasWP
                                    ? const Color(0xFF059669)
                                    : const Color(0xFF64748B),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  p['name'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: hasWP
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              if (hasWP)
                                Container(
                                  margin: EdgeInsets.only(left: 4.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'Win Pass 🎫',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),

                      // Option to write custom place
                      DropdownMenuItem<String>(
                        value: 'custom_mode',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_location_alt_rounded,
                                size: 18, color: Color(0xFF8B5CF6)),
                            SizedBox(width: 8.w),
                            Text(
                              '✏️ مكان آخر (كتابة يدوية)',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val == null) return;
                      if (val == 'custom_mode') {
                        setState(() {
                          _selectedPlaceMode = 'custom';
                          _selectedPlaceId = null;
                          _selectedPlaceName = null;
                          _hasWinPass = false;
                        });
                      } else {
                        final found = _discountPlaces.firstWhereOrNull(
                            (p) => p['id'].toString() == val);
                        if (found != null) {
                          setState(() {
                            _selectedPlaceMode = 'select';
                            _selectedPlaceId = found['id'];
                            _selectedPlaceName = found['name'];
                            _hasWinPass = found['has_win_pass'] == true;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),

              // Custom Place Text Field (if selected)
              if (_selectedPlaceMode == 'custom') ...[
                SizedBox(height: 8.h),
                TextField(
                  controller: _customPlaceController,
                  style: TextStyle(fontSize: 13.sp),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on_outlined,
                        color: Color(0xFF8B5CF6), size: 18),
                    hintText: 'اكتب اسم المكان أو المنطقة (مثال: كافيه مادو تقسيم)...',
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
              ],
              SizedBox(height: 14.h),

              // 4. DATE SELECTION (Up to 3 Days)
              Text(
                'اليوم والتاريخ (أقصى حد 3 أيام):',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: List.generate(3, (idx) {
                  final isSelected = _selectedDayIndex == idx;
                  final dt = _availableDates[idx];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = idx),
                      child: Container(
                        margin: EdgeInsets.only(left: idx < 2 ? 8.w : 0),
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getDayTitle(idx),
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _getDateFormatted(dt),
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.9)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 14.h),

              // 5. TIME & SEATS ROW
              Row(
                children: [
                  // Time Selector
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'توقيت اللقاء (الساعة):',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        GestureDetector(
                          onTap: _pickCustomTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12.r),
                              border:
                                  Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 18, color: Color(0xFF8B5CF6)),
                                SizedBox(width: 8.w),
                                Text(
                                  _formatSelectedTime(),
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down,
                                    color: Color(0xFF94A3B8)),
                              ],
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.r),
                            border:
                                Border.all(color: const Color(0xFFE2E8F0)),
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

              // 6. Note / Details
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

              // 7. Submit Button
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
                        'نشر الدعوة الآن 🚀',
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
