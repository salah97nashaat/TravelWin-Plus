import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../../const.dart';
import '../../widgets/normalButton.dart';

class MedicalTourism extends StatelessWidget {
  MedicalTourism({Key? key}) : super(key: key);

  final MedicalTourismController medicalTourismController =
      MedicalTourismController();

  void _showConsultationSheet(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final nameController =
        TextEditingController(text: profile.value.data?.name != null ? profile.value.data!.name.toString() : '');
    final phoneController =
        TextEditingController(text: profile.value.data?.mobile != null ? profile.value.data!.mobile.toString() : '');
    final notesController = TextEditingController();
    bool isSubmitting = false;

    final specialty = isAr
        ? (medicalTrips.value?.medicalTrips?[medicalTourismController.index.value].titleAr ?? '')
        : (medicalTrips.value?.medicalTrips?[medicalTourismController.index.value].titleEn ??
            medicalTrips.value?.medicalTrips?[medicalTourismController.index.value].titleAr ?? '');

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
                                    ? 'استشارة سياحة علاجية مجانية'
                                    : 'Free Medical Consultation',
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
                          ? 'تفاصيل الحالة أو الاستفسار'
                          : 'Medical Case Details / Inquiries',
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
                            ? 'اشرح ما تحتاجه أو أي تفاصيل ترغب باستشارة الطبيب عنها...'
                            : 'Describe your medical inquiry or condition...',
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
                                final response = await http.post(
                                  Uri.parse(
                                      'https://travelwin1.com/api/medical-tourism/inquire'),
                                  headers: {
                                    'Accept': 'application/json',
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'specialty': specialty,
                                    'user_name': name,
                                    'user_phone': phone,
                                    'notes': notesController.text.trim(),
                                    'lang': isAr ? 'ar' : 'en',
                                  }),
                                );

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
                                                ? 'تم استلام استشارتك'
                                                : 'Consultation Received',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        isAr
                                            ? 'شكراً لتواصلك! تم إرسال استشارتك بنجاح، وسيتواصل معك مستشار TravelWin الطبي بأقرب وقت ممكن.'
                                            : 'Thank you! Your inquiry has been sent successfully. A TravelWin medical advisor will contact you shortly.',
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
                                  ? 'إرسال طلب الاستشارة المجانية'
                                  : 'Submit Free Consultation Request',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        leading: Container(),
        title: Text(
          "Medical tourism".tr,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: Get.locale == Locale('ar')
                ? EdgeInsets.only(left: 25.w, top: 5.h)
                : EdgeInsets.only(right: 25.w, top: 5.h),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset(
                    'assets/images/back.svg',
                    height: 30,
                  ),
                )),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          Center(
              child: SvgPicture.asset(
            'assets/images/medical tourism.svg',
            height: Get.locale == Locale('ar') ? 160.h : 150.h,
            width: 180.w,
          )),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                "We help tourism to obtain the best medical services at costs less than 70%"
                    .tr,
                style: TextStyle(
                    color: mainColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: mainColor.withOpacity(0.12),
                      child: CircleAvatar(
                        radius: 9.w,
                        backgroundColor: mainColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'With the same European international medical standards'
                            .tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 20.h : 10.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'Arrangement of hotel accommodation, transportation, translation services, appointments and the hospital'
                            .tr
                            .tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 26.h : 12.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'JCI Non-Profit Certificate'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(
                      height: Get.locale == Locale('ar') ? 24.h : 16.h,
                    ),
                    SizedBox(
                      width: 262,
                      child: Text(
                        'Develop a treatment plan and free consultation'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: 350.w,
            height: 195.h,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 2)),
                ],
                borderRadius: BorderRadius.circular(15)),
            child: RawScrollbar(
              thumbColor: mainColor,
              radius: Radius.circular(15),
              interactive: false,
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Obx(
                  () => InkWell(
                      onTap: () {
                        medicalTourismController.changeIndex(index);
                      },
                      child: MedicalService(
                          name: Get.locale == Locale('ar')
                              ? medicalTrips
                                  .value!.medicalTrips![index].titleAr!
                              : medicalTrips
                                  .value!.medicalTrips![index].titleEn!,
                          chosen: medicalTourismController.index == index)),
                ),
                itemCount: medicalTrips.value!.medicalTrips!.length,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          NormalButton(
            onTap: () => _showConsultationSheet(context),
            color: mainColor,
            name: 'Medical Consultation'.tr,
            fontColor: Colors.white,
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    ),
    );
  }
}

class MedicalService extends StatelessWidget {
  MedicalService({super.key, required this.name, required this.chosen});

  final String name;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
          color: chosen ? Color(0xffE9EFF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            CircleAvatar(
              backgroundColor: chosen ? mainColor : Colors.grey.shade300,
              radius: 10.w,
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: mainColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
          ],
        ),
      ),
    );
  }
}
