import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:travelwin/helpers/helper.dart';
import 'package:travelwin/logic/controllers/place_details_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/normalButton.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import '../../../const.dart';
import '../../../logic/controllers/slider_controller.dart';
import '../../../services/profile_services.dart';
import '../../../utils/theme.dart';
import '../../widgets/date_details_widget.dart';
import '../tourism_areas/place_details.dart';

class ViewTripsDetailsScreen extends StatefulWidget {
  @override
  State<ViewTripsDetailsScreen> createState() => _ViewTripsDetailsScreenState();
}

class _ViewTripsDetailsScreenState extends State<ViewTripsDetailsScreen> {
  final SliderController sliderController = Get.put(SliderController());

  final PlaceDetailsController placeDetailsController =
      PlaceDetailsController();

  void _showBookingSheet() {
    final isAr = Get.locale?.languageCode == 'ar';
    final nameController =
        TextEditingController(text: profile.value.data?.name != null ? profile.value.data!.name.toString() : '');
    final phoneController =
        TextEditingController(text: profile.value.data?.mobile != null ? profile.value.data!.mobile.toString() : '');
    final notesController = TextEditingController();

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    int personsCount = 1;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final tripName = isAr
                ? (trip.value?.nameAr ?? '')
                : (trip.value?.nameEn ?? trip.value?.nameAr ?? '');

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
                          child: Icon(Icons.flight_takeoff_rounded,
                              color: mainColor, size: 24.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'حجز رحلة سياحية' : 'Book Tourist Trip',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                              Text(
                                tripName,
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
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'تاريخ الرحلة' : 'Trip Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.grey[800]),
                              ),
                              SizedBox(height: 6.h),
                              InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (picked != null) {
                                    setModalState(() => selectedDate = picked);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 18.sp, color: mainColor),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                            fontSize: 12.5.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAr ? 'الأشخاص' : 'Persons',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    color: Colors.grey[800]),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (personsCount > 1) {
                                          setModalState(() => personsCount--);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child:
                                            const Icon(Icons.remove, size: 14),
                                      ),
                                    ),
                                    Text(
                                      '$personsCount',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (personsCount < 30) {
                                          setModalState(() => personsCount++);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: mainColor.withOpacity(0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.add,
                                            size: 14, color: mainColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      isAr
                          ? 'ملاحظات إضافية (اختياري)'
                          : 'Additional Notes (Optional)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.grey[800]),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: isAr
                            ? 'أي طلبات خاصة أو تفاصيل إضافية...'
                            : 'Any special requests or notes...',
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
                                final dateStr =
                                    "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                final response = await http.post(
                                  Uri.parse(
                                      'https://travelwin1.com/api/trips/inquire'),
                                  headers: {
                                    'Accept': 'application/json',
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'trip_name': tripName,
                                    'user_name': name,
                                    'user_phone': phone,
                                    'trip_date': dateStr,
                                    'persons_count': personsCount,
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
                                                ? 'تم استلام طلبك'
                                                : 'Request Received',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        isAr
                                            ? 'شكراً لك! تم إرسال طلب الحجز بنجاح، وسيتواصل معك فريق TravelWin قريباً لتأكيد التفاصيل.'
                                            : 'Thank you! Your booking request has been submitted successfully. The TravelWin team will contact you shortly.',
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
                                  ? 'تأكيد إرسال طلب الحجز'
                                  : 'Confirm Booking Request',
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
        bottomNavigationBar: const AdmobBannerUi(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Trip Info".tr,
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
          leadingWidth: 100,
          leading: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Row(
              children: [
                SizedBox(
                  width: 25.w,
                ),
                GestureDetector(
                  onTap: () {
                    RemoteServices.addTripToFav(trip.value!.id)
                        .then((value) async {
                      print(value.data);
                      if (value.statusCode == 200) {
                        trip.value!.is_favorite = !trip.value!.is_favorite!;
                        favoriteModel.value =
                            (await RemoteServices.fetchFavorite())!;
                        setState(() {});
                      }
                    });
                  },
                  child: Obx(
                    () => trip.value!.is_favorite!
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                  ),
                )
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        //  drawer: MyDrawer(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Stack(
              children: [
                Obx(
                  () => Container(
                    width: 1.sw,
                    height: 310.h,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(trip
                            .value!
                            .images![placeDetailsController.selectedImage.value]
                            .image!),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(),
                    ),
                  ),
                ),
                Positioned(
                  //right: 60.w,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Center(
                      child: SizedBox(
                        height: 55,
                        width: Get.width - 50,
                        child: Center(
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Center(
                                    child: InkWell(
                                      onTap: () {
                                        placeDetailsController
                                            .changeImage(index);
                                      },
                                      child: Obx(
                                        () => index !=
                                                placeDetailsController
                                                    .selectedImage.value
                                            ? SmallImageWidget(
                                                image: trip.value!
                                                    .images![index].image!)
                                            : Container(),
                                      ),
                                    ),
                                  ),
                              separatorBuilder: (context, index) => Obx(
                                    () => index !=
                                            placeDetailsController
                                                .selectedImage.value
                                        ? SizedBox(
                                            width: 0,
                                          )
                                        : Container(),
                                  ),
                              itemCount: trip.value!.images!.length),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child: Text(
                Get.locale == Locale('ar')
                    ? trip.value!.nameAr!
                    : trip.value!.nameEn!,
                style: TextStyle(color: mainColor, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Text(
              'Trip Details :'.tr,
              style: TextStyle(
                color: mainColor,
                fontSize: 15.w,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateDetailsWidget(
                    from: Get.locale == Locale('ar')
                        ? trip.value!.fromAr!
                        : trip.value!.fromEn!,
                    name: 'from :'.tr,
                    width: 150.w,
                  ),
                  DateDetailsWidget(
                    from: Get.locale == Locale('ar')
                        ? trip.value!.toAr!
                        : trip.value!.toEn!,
                    name: 'to :'.tr,
                    width: Get.locale == Locale('en') ? 170.w : 150.w,
                  ),
                  // DateDetailsWidget(
                  //   from: trip.value!.date!,
                  //   name: 'Date'.tr + ' :',
                  //   width: Get.locale == Locale('en') ? 110.w : 120.w,
                  // ),
                  // DateDetailsWidget(
                  //   from: Get.locale == Locale('ar')
                  //       ? '${trip.value!.duration!.toString()} يوم'
                  //       : ' day${trip.value!.duration!.toString()}',
                  //   name: 'days count :'.tr,
                  //   width: Get.locale == Locale('en') ? 110.w : 120.w,
                  // ),
                  DateDetailsWidget(
                    from: trip.value!.type! == 'multiple'
                        ? 'Multiple'.tr
                        : 'Single'.tr,
                    name: 'Trip type'.tr + ' :',
                    width: Get.locale == Locale('en') ? 40.w : 50.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            NormalButton(
                color: mainColor,
                fontColor: Colors.white,
                name: 'Book Trip'.tr,
                onTap: _showBookingSheet),
            SizedBox(
              height: 10.h,
            ),
          ],
        ));
  }
}
