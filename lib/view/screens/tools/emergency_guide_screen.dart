import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helpers/adv/admob_banner.dart';

class EmergencyGuideScreen extends StatelessWidget {
  const EmergencyGuideScreen({Key? key}) : super(key: key);

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final isAr = Get.locale?.languageCode == 'ar';

    final emergencyNumbersAr = [
      {'title': 'الشرطة وخدمات الأمن', 'number': '155', 'desc': 'شرطة النجدة والطوارئ العامة'},
      {'title': 'الإسعاف والطوارئ الطبية', 'number': '112', 'desc': 'خدمات الإسعاف والرعاية الفورية'},
      {'title': 'الشرطة السياحية (إسطنبول)', 'number': '+902125274503', 'desc': 'دعم السياح بعدة لغات'},
      {'title': 'خفر السواحل والإنقاذ البحري', 'number': '158', 'desc': 'طوارئ الجولات البحرية والساحلية'},
      {'title': 'الإطفاء والحرائق', 'number': '110', 'desc': 'خدمات الدفاع المدني'},
    ];

    final emergencyNumbersEn = [
      {'title': 'Police & Public Security', 'number': '155', 'desc': 'Emergency & General Police Line'},
      {'title': 'Ambulance & Medical Emergency', 'number': '112', 'desc': 'Instant Medical Care & Ambulance'},
      {'title': 'Tourist Police (Istanbul)', 'number': '+902125274503', 'desc': 'Multi-lingual Tourist Assistance'},
      {'title': 'Coast Guard & Maritime Rescue', 'number': '158', 'desc': 'Maritime & Boat Tour Emergencies'},
      {'title': 'Fire Department', 'number': '110', 'desc': 'Firefighting & Civil Defense'},
    ];

    final travelPhrasesAr = [
      {'ar': 'كم السعر؟', 'tr': 'Ne kadar? (نه كادار؟)', 'category': 'التسوق'},
      {'ar': 'الحساب من فضلك', 'tr': 'Hesap lütfen (حساب لوتفاً)', 'category': 'المطاعم'},
      {'ar': 'إلى المطار من فضلك', 'tr': 'Havalimanına lütfen (هافاليماننا لوتفاً)', 'category': 'المواصلات'},
      {'ar': 'أين المترو؟', 'tr': 'Metro nerede? (مترو نيريديه؟)', 'category': 'المواصلات'},
      {'ar': 'شكراً جزيلاً', 'tr': 'Çok teşekkürler (تشوك تشكرلار)', 'category': 'عام'},
      {'ar': 'هل تتحدث الإنجليزية؟', 'tr': 'İngilizce biliyor musunuz?', 'category': 'عام'},
      {'ar': 'أحتاج مساعدة', 'tr': 'Yardım edin lütfen (يارديم إيدين)', 'category': 'طوارئ'},
    ];

    final travelPhrasesEn = [
      {'ar': 'How much is this?', 'tr': 'Ne kadar?', 'category': 'Shopping'},
      {'ar': 'The check / bill please', 'tr': 'Hesap lütfen', 'category': 'Dining'},
      {'ar': 'To the airport please', 'tr': 'Havalimanına lütfen', 'category': 'Transport'},
      {'ar': 'Where is the metro?', 'tr': 'Metro nerede?', 'category': 'Transport'},
      {'ar': 'Thank you very much', 'tr': 'Çok teşekkürler', 'category': 'General'},
      {'ar': 'Do you speak English?', 'tr': 'İngilizce biliyor musunuz?', 'category': 'General'},
      {'ar': 'I need help please', 'tr': 'Yardım edin lütfen', 'category': 'Emergency'},
    ];

    final emergencyNumbers = isAr ? emergencyNumbersAr : emergencyNumbersEn;
    final travelPhrases = isAr ? travelPhrasesAr : travelPhrasesEn;

    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        title: Text(
          isAr ? 'دليل الطوارئ والعبارات السياحية' : 'Emergency Directory & Travel Guide',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [mainColor, Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency_outlined, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? 'أمانك وراحتك أولويتنا' : 'Your Safety is Our Priority',
                          style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          isAr
                              ? 'أرقام الطوارئ المباشرة وأهم العبارات التي تحتاجها في رحلتك.'
                              : 'Instant emergency hotlines and essential travel phrases for your trip.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Section 1: Emergency Numbers
            Row(
              children: [
                const Icon(Icons.phone_in_talk, color: mainColor, size: 20),
                SizedBox(width: 8.w),
                Text(
                  isAr ? 'أرقام الطوارئ المباشرة' : 'Direct Emergency Numbers',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            ...emergencyNumbers.map((e) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['title']!,
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            e['desc']!,
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _callNumber(e['number']!),
                      icon: const Icon(Icons.call, size: 16, color: Colors.white),
                      label: Text(
                        e['number']!,
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 16.h),

            // Section 2: Turkish Travel Phrases
            Row(
              children: [
                const Icon(Icons.translate_rounded, color: mainColor, size: 20),
                SizedBox(width: 8.w),
                Text(
                  isAr ? 'أهم العبارات التركية المفيدة للمسافر' : 'Essential Turkish Travel Phrases',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            ...travelPhrases.map((p) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: goldAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        p['category']!,
                        style: TextStyle(fontSize: 10.sp, color: const Color(0xFFB45309), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['ar']!,
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            p['tr']!,
                            style: TextStyle(fontSize: 12.sp, color: mainColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.grey),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: p['tr']!));
                        Get.snackbar(
                          isAr ? 'تم النسخ' : 'Copied',
                          '${p['tr']}',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 1),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
