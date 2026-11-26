import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';

class MedicalTourism extends StatefulWidget {
  const MedicalTourism({Key? key}) : super(key: key);

  @override
  State<MedicalTourism> createState() => _MedicalTourismState();
}

class _MedicalTourismState extends State<MedicalTourism> {
  int _selectedIndex = 0;
  final MedicalTourismController medicalTourismController =
      Get.isRegistered<MedicalTourismController>()
          ? Get.find<MedicalTourismController>()
          : Get.put(MedicalTourismController());

  void _showConsultationSheet(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final nameController = TextEditingController(
        text: profile.value.data?.name != null
            ? profile.value.data!.name.toString()
            : '');
    final phoneController = TextEditingController(
        text: profile.value.data?.mobile != null
            ? profile.value.data!.mobile.toString()
            : '');
    final notesController = TextEditingController();
    File? selectedImage;
    bool isSubmitting = false;

    final specialty = isAr
        ? (medicalTrips.value?.medicalTrips?[_selectedIndex].titleAr ?? '')
        : (medicalTrips.value?.medicalTrips?[_selectedIndex].titleEn ??
            medicalTrips.value?.medicalTrips?[_selectedIndex].titleAr ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.medical_services_outlined,
                              color: mainColor, size: 24.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr
                                    ? 'طلب استشارة مجانية وعرض سعر 🩺'
                                    : 'Free Consultation & Quote 🩺',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                              Text(
                                specialty,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      isAr ? 'الاسم الكامل *' : 'Full Name *',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: isAr ? 'أدخل اسمك الكريم' : 'Enter your name',
                        hintStyle: TextStyle(
                            fontSize: 12.sp, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: mainColor, width: 1.5)),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      isAr ? 'رقم الهاتف / واتساب *' : 'Phone / WhatsApp *',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText:
                            isAr ? '+90 5XX XXX XX XX' : '+90 5XX XXX XX XX',
                        hintStyle: TextStyle(
                            fontSize: 12.sp, color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 12.h),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: mainColor, width: 1.5)),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      isAr
                          ? 'وصف الحالة أو الاستفسار (اختياري)'
                          : 'Case Description / Inquiries (Optional)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: isAr
                            ? 'أرغب في معرفة التكلفة، مدة العلاج، أو أي تفاصيل...'
                            : 'Describe your medical inquiry, desired goals, or questions...',
                        hintStyle: TextStyle(
                            fontSize: 12.sp, color: Colors.grey[400]),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: mainColor, width: 1.5)),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // Image Attachment Section
                    Text(
                      isAr
                          ? 'إرفاق صورة للحالة (اختياري)'
                          : 'Attach Condition Photo (Optional)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isAr
                          ? 'مثلاً: صورة الأسنان أو الشعر لتقييم الطبيب المنسق'
                          : 'e.g. photo of teeth or hair for doctor evaluation',
                      style: TextStyle(fontSize: 11.5.sp, color: Colors.grey[500]),
                    ),
                    SizedBox(height: 8.h),
                    if (selectedImage == null)
                      InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedImage = File(picked.path);
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey[300]!, style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  color: mainColor, size: 22.sp),
                              SizedBox(width: 8.w),
                              Text(
                                isAr
                                    ? 'اختر صورة من المعرض 📷'
                                    : 'Select photo from gallery 📷',
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                selectedImage!,
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isAr ? 'تم إرفاق الصورة' : 'Photo Attached',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700]),
                                  ),
                                  Text(
                                    selectedImage!.path.split(Platform.pathSeparator).last,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11.sp, color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.redAccent),
                              onPressed: () {
                                setModalState(() {
                                  selectedImage = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final name = nameController.text.trim();
                              final phone = phoneController.text.trim();
                              if (name.isEmpty || phone.isEmpty) {
                                Get.snackbar(
                                  isAr ? 'تنبيه' : 'Alert',
                                  isAr
                                      ? 'يرجى إدخال الاسم ورقم الهاتف'
                                      : 'Please enter your name and phone number',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                );
                                return;
                              }

                              setModalState(() => isSubmitting = true);
                              try {
                                var request = http.MultipartRequest(
                                  'POST',
                                  Uri.parse(
                                      'https://travelwin1.com/api/medical-tourism/inquire'),
                                );
                                request.headers.addAll({
                                  'Accept': 'application/json',
                                });
                                request.fields['specialty'] = specialty;
                                request.fields['user_name'] = name;
                                request.fields['user_phone'] = phone;
                                request.fields['notes'] =
                                    notesController.text.trim();
                                request.fields['lang'] = isAr ? 'ar' : 'en';

                                if (selectedImage != null) {
                                  request.files.add(
                                    await http.MultipartFile.fromPath(
                                        'image', selectedImage!.path),
                                  );
                                }

                                final streamedResponse = await request.send();
                                final response = await http.Response.fromStream(
                                    streamedResponse);

                                if (response.statusCode == 200) {
                                  Navigator.pop(ctx);
                                  Get.dialog(
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: Row(
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Colors.green, size: 28),
                                          const SizedBox(width: 8),
                                          Text(
                                            isAr
                                                ? 'تم استلام استشارتك بنجاح'
                                                : 'Consultation Received',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        isAr
                                            ? 'شكراً لتواصلك! تم إرسال طلب الاستشارة للمنسق الطبي لـ TravelWin بنجاح، وسيتواصل معك مباشرة لتقديم الخطة العلاجية وعرض السعر.'
                                            : 'Thank you! Your consultation request has been delivered to TravelWin medical coordinator. We will contact you shortly with the treatment plan and quote.',
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text(
                                            isAr ? 'حسناً' : 'OK',
                                            style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  throw Exception(
                                      'Server error: ${response.statusCode}');
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                Get.snackbar(
                                  isAr ? 'خطأ' : 'Error',
                                  isAr
                                      ? 'تعذر إرسال الطلب، يرجى المحاولة لاحقاً'
                                      : 'Failed to submit request, please try again',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              isAr
                                  ? 'تأكيد وإرسال الطلب'
                                  : 'Confirm & Send Request',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _getSpecialtyIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('شعر') || t.contains('hair')) {
      return Icons.face_retouching_natural_rounded;
    }
    if (t.contains('أسنان') ||
        t.contains('سن') ||
        t.contains('dental') ||
        t.contains('teeth')) {
      return Icons.sentiment_very_satisfied_rounded;
    }
    if (t.contains('عين') || t.contains('عيون') || t.contains('eye')) {
      return Icons.remove_red_eye_rounded;
    }
    if (t.contains('سمنة') ||
        t.contains('تكميم') ||
        t.contains('weight') ||
        t.contains('bariatric')) {
      return Icons.monitor_weight_outlined;
    }
    if (t.contains('تجميل') ||
        t.contains('plastic') ||
        t.contains('cosmetic')) {
      return Icons.auto_awesome_rounded;
    }
    if (t.contains('قلب') || t.contains('heart') || t.contains('cardio')) {
      return Icons.favorite_rounded;
    }
    return Icons.medical_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';

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
          "Medical tourism".tr,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0F2B48),
                    Color(0xFF1B4D73),
                    Color(0xFF215B82),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F2B48).withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded,
                            color: const Color(0xFF38BDF8), size: 14.sp),
                        SizedBox(width: 5.w),
                        Text(
                          isAr
                              ? 'معايير أوروبية واعتماد دولي JCI'
                              : 'European Standards & JCI Accredited',
                          style: TextStyle(
                            color: const Color(0xFFE0F2FE),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "We help tourism to obtain the best medical services at costs less than 70%"
                        .tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    isAr
                        ? 'إشراف استشاريين معتمدين، إقامة فندقية فاخرة، ومرافقة ومتابعة شاملة طوال فترة العلاج.'
                        : 'Certified consultants, luxury hotel stay, translation, and VIP medical escort throughout your treatment.',
                    style: TextStyle(
                      color: const Color(0xFFE2E8F0),
                      fontSize: 12.sp,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            // Highlights Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined,
                      color: mainColor, size: 19.sp),
                  SizedBox(width: 8.w),
                  Text(
                    isAr
                        ? 'مزايا باقة الرعاية الطبية المتكاملة'
                        : 'Integrated Medical Care Highlights',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Highlights 2x2 Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.hotel_rounded,
                          iconColor: const Color(0xFF0284C7),
                          title: isAr
                              ? 'إقامة وتنقلات VIP'
                              : 'VIP Accommodation',
                          desc: isAr
                              ? 'فندق فاخر واستقبال خاص'
                              : 'Luxury stay & transfers',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.translate_rounded,
                          iconColor: const Color(0xFF7C3AED),
                          title: isAr
                              ? 'مترجم طبي خاص'
                              : 'Medical Translator',
                          desc: isAr
                              ? 'مرافقة طوال المواعيد'
                              : 'Escort during visits',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.verified_user_rounded,
                          iconColor: const Color(0xFF059669),
                          title: isAr
                              ? 'مستشفيات JCI معتمدة'
                              : 'JCI Accredited',
                          desc: isAr
                              ? 'أعلى معايير الأمان الطبي'
                              : 'Top safety standards',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _buildFeatureCard(
                          icon: Icons.assessment_outlined,
                          iconColor: const Color(0xFFD97706),
                          title: isAr
                              ? 'استشارة مجانية'
                              : 'Free Assessment',
                          desc: isAr
                              ? 'خطة علاجية وعرض سعر'
                              : 'Plan & exact quote',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // Specialties Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category_rounded,
                          color: mainColor, size: 19.sp),
                      SizedBox(width: 8.w),
                      Text(
                        isAr
                            ? 'اختر التخصص الطبي المطلوب'
                            : 'Select Medical Specialty',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    final count =
                        medicalTrips.value?.medicalTrips?.length ?? 0;
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isAr ? '$count تخصصات' : '$count Specialties',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Specialties List
            Obx(() {
              final list = medicalTrips.value?.medicalTrips ?? [];
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.h),
                    child: CircularProgressIndicator(color: mainColor),
                  ),
                );
              }
              if (_selectedIndex >= list.length) {
                _selectedIndex = 0;
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: List.generate(list.length, (index) {
                    final item = list[index];
                    final name = isAr
                        ? (item.titleAr ?? '')
                        : (item.titleEn ?? item.titleAr ?? '');
                    final isSelected = _selectedIndex == index;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                            medicalTourismController.changeIndex(index);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFF0F7FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? mainColor
                                    : const Color(0xFFE2E8F0),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: mainColor.withOpacity(0.10),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                else
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? mainColor
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getSpecialtyIcon(name),
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 13.5.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? mainColor
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? mainColor
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? mainColor
                                          : const Color(0xFFCBD5E1),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check,
                                          size: 14.sp, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final list = medicalTrips.value?.medicalTrips ?? [];
                if (list.isEmpty || _selectedIndex >= list.length) {
                  return const SizedBox.shrink();
                }
                final selectedItem = list[_selectedIndex];
                final selectedTitle = isAr
                    ? (selectedItem.titleAr ?? '')
                    : (selectedItem.titleEn ?? selectedItem.titleAr ?? '');
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isAr ? 'التخصص المختار:' : 'Selected:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          selectedTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showConsultationSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    elevation: 3,
                    shadowColor: mainColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services_rounded,
                          color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          isAr
                              ? 'طلب استشارة مجانية وعرض سعر 🩺'
                              : 'Request Free Consultation & Quote 🩺',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF64748B),
                    height: 1.25,
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
