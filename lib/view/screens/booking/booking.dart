import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:travelwin/logic/controllers/booking_controller.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
// import 'package:travelwin/logic/controllers/medicalTourismController.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
import '../../widgets/date_details_widget.dart';
import '../../widgets/normalButton.dart';

class Booking extends StatefulWidget {
  Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  BookingController bookingController = BookingController();
  late final Pay _payClient;
  @override
  void initState() {
    _payClient = Pay({
      PayProvider.google_pay:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      PayProvider.apple_pay:
          PaymentConfiguration.fromJsonString(defaultApplePay),
    });
    final applePayConfig = PaymentConfiguration.fromJsonString(defaultApplePay);
    //print("merchantIdentifier: ${applePayConfig.merchantIdentifier}");
// print("supportedNetworks: ${applePayConfig.supportedNetworks}");
// print("merchantCapabilities: ${applePayConfig.merchantCapabilities}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        title: Text(
          "Booking".tr,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Get.locale == Locale('ar')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                'Booking Date :'.tr,
                style: TextStyle(color: Colors.black, fontSize: 12.w),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Center(
                                child: Container(
                                  height: 400,
                                  width: 343,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue),
                                  child: SfDateRangePicker(
                                    onCancel: () {
                                      Get.back();
                                    },
                                    onSubmit: (Object? v) {
                                      if (v is PickerDateRange) {
                                        bookingController.setValues(
                                            DateTime.parse(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(v.startDate!)),
                                            DateTime.parse(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(v.endDate!)),
                                            double.parse(guidence
                                                .value
                                                .guidances![guidenceIndex.value]
                                                .salary!
                                                .toString()));
                                        Get.back();
                                      }
                                    },
                                    cancelText: 'CANCEL'.tr,
                                    confirmText: 'OK'.tr,
                                    enablePastDates: false,
                                    showActionButtons: true,
                                    backgroundColor: Colors.white,
                                    view: DateRangePickerView.month,
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                            firstDayOfWeek: 1),
                                    selectionMode:
                                        DateRangePickerSelectionMode.range,
                                    selectionColor: mainColor,
                                    maxDate:
                                        DateTime.now().add(Duration(days: 365)),
                                  ),
                                ),
                              ),
                            ),
                          ));
                },
                child: Container(
                  width: 94,
                  height: 87,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 6,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      SvgPicture.asset('assets/images/calender.svg'),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'select here'.tr,
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 12.w,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'the selected date is :'.tr,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateDetailsWidget(
                    from: bookingController.form.value,
                    name: 'from :'.tr,
                    width: 150.w,
                  ),
                  DateDetailsWidget(
                    from: bookingController.to.value,
                    name: 'to :'.tr,
                    width: Get.locale == Locale('en') ? 170.w : 150.w,
                  ),
                  DateDetailsWidget(
                    from: bookingController.days.value,
                    name: 'days count :'.tr,
                    width: Get.locale == Locale('en') ? 110.w : 120.w,
                  ),
                  DateDetailsWidget(
                    from: bookingController.price.value,
                    name: 'price should you pay :'.tr,
                    width: Get.locale == Locale('en') ? 40.w : 50.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 40.w),
            //   child: Text(
            //       'The amount will be deposited with the program administration and after you finish the trip and run it as you wish in the best way, the amount will be transferred and deposited to the account of the guide who was contracted with.'
            //           .tr,
            //   style: TextStyle(color: Colors.black,fontSize: 12.w,height: 1.5),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 40.w),
            //   child: Text(
            //       'And any malfunction or damage that occurs, a complaint will be submitted and it will be considered'
            //           .tr,
            //   style: TextStyle(color: Colors.black,fontSize: 12.w,height: 1.5),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 40.w),
            //   child: Divider(
            //     color: Colors.grey.withOpacity(0.35),
            //     thickness: 1,
            //   ),
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // SizedBox(
            //   width: 280,
            //   height: 78,
            //   child: Text(
            //     'ملاحظة : يجب تقيم المرشد بعد الانتهاء من الرحلة.'.tr,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       color: Colors.black.withOpacity(0.5),
            //       fontSize: 10,
            //       fontFamily: 'Readex Pro',
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 150.h,
            ),
            SizedBox(
              width: 343.w,
              height: 32.h,
              child: Obx(
                () => isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : NormalButton(
                        onTap: () async {
                          isLoading.value = true;

                          if (!bookingController.selected.value) {
                            isLoading.value = false;
                            showSnackBar(context,
                                'You have to choose the date first'.tr);
                            return;
                          }

                          PayProvider selectedProvider;
                          if (Platform.isAndroid) {
                            selectedProvider = PayProvider.google_pay;
                          } else if (Platform.isIOS) {
                            selectedProvider = PayProvider.apple_pay;
                          } else {
                            isLoading.value = false;
                            showSnackBar(context, 'Unsupported platform'.tr);
                            return;
                          }

                          bool canPay =
                              await _payClient.userCanPay(selectedProvider);

                          if (!canPay) {
                            isLoading.value = false;
                            showSnackBar(
                                context, 'Payment method not available'.tr);
                            return;
                          }

                          try {
                            await _payClient.showPaymentSelector(
                              selectedProvider,
                              [
                                PaymentItem(
                                  label: 'Travel Win',
                                  amount: bookingController.price.value,
                                  type: PaymentItemType.total,
                                  status: PaymentItemStatus.final_price,
                                )
                              ],
                            );

                            // After successful payment, continue your booking logic:
                            GuidenceController guidenceController =
                                GuidenceController();
                            String result =
                                await guidenceController.reserveGuidence(
                              guidenceId.value,
                              bookingController.form.value.replaceAll('/', '-'),
                              bookingController.to.value.replaceAll('/', '-'),
                            );

                            if (result == 'Created successfully') {
                              Get.back();
                              Get.showSnackbar(GetSnackBar(
                                message:
                                    'Your booking has been confirmed\n${' you have paid'.tr}  ${bookingController.price.value}\$'
                                        .tr,
                                duration: Duration(seconds: 5),
                              ));
                            } else {
                              Get.showSnackbar(GetSnackBar(
                                message: result,
                                duration: Duration(seconds: 5),
                              ));
                            }
                          } catch (e) {
                            showSnackBar(context, 'Something went wrong'.tr);
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        color: bookingController.selected.value
                            ? mainColor
                            : Colors.grey,
                        fontColor: Colors.white,
                        name: 'Confirm'.tr,
                      ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
