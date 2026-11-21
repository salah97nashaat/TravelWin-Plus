import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../logic/controllers/chat_controller.dart';
import 'package:pay/pay.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../utils/my_string.dart';

class WelcomeSticker extends StatelessWidget {
  WelcomeSticker(
      {super.key, required this.sticker, required this.price, this.onTap});
  final String sticker;
  final String price;
  final VoidCallback? onTap;

  // late final Pay _payClient;

// When you are ready to load your configuration

  final ChatController chatController = Get.find<ChatController>();
  // Future<void> onGooglePayResult() async {
  //   // _payClient = Pay({
  //   //   PayProvider.google_pay:
  //   //       PaymentConfiguration.fromJsonString(defaultGooglePay),
  //   //   PayProvider.apple_pay:
  //   //       PaymentConfiguration.fromJsonString(defaultGooglePay),
  //   // });
  //   await _payClient.showPaymentSelector(
  //     PayProvider.google_pay,
  //     [
  //       PaymentItem(
  //         label: 'Total',
  //         amount: price,
  //         status: PaymentItemStatus.final_price,
  //       )
  //     ],
  //   );
  //   chatController.putSticker(sticker);
  //   // Send the resulting Google Pay token to your server / PSP
  // }

  @override
  Widget build(BuildContext context) {
    // _payClient = Pay({
    //   PayProvider.google_pay:
    //       PaymentConfiguration.fromJsonString(defaultGooglePay),
    //   PayProvider.apple_pay:
    //       PaymentConfiguration.fromJsonString(defaultGooglePay),
    // });
    // List<PaymentItem> _paymentItems = [
    //   PaymentItem(
    //     label: 'Total',
    //     amount: price,
    //     status: PaymentItemStatus.final_price,
    //   )
    // ];
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () async {
        onTap?.call();
        // Get.defaultDialog(
        //   title: 'Payment'.tr,
        //     backgroundColor: Colors.white,
        //    content:
        // RawGooglePayButton(
        //   // width: 500,
        //   // height: 45.h,
        //   // paymentItems: _paymentItems,
        //   // onPaymentResult: onGooglePayResult,
        //   // loadingIndicator: const Center(
        //   //   child: CircularProgressIndicator(),
        //   // ),
        //   type: GooglePayButtonType.pay,
        //   onPressed: () async {
        //     final result = await _payClient.showPaymentSelector(
        //       PayProvider.google_pay,
        //       [
        //         PaymentItem(
        //           label: 'Total',
        //           amount: price,
        //           status: PaymentItemStatus.final_price,
        //         )
        //       ],
        //     ).then((value) {
        //       print(value);
        //       chatController.putSticker(sticker);
        //     });
        //
        //   },
        //   // onError: (e){
        //   //   print(e.toString());
        //   // },
        //   // margin: const EdgeInsets.only(top: 15.0),
        //   // paymentConfiguration:await PaymentConfiguration.fromAsset('gpay.json')
        // ));

        // _payClient = Pay({
        //   PayProvider.google_pay:
        //       PaymentConfiguration.fromJsonString(defaultGooglePay),
        //   PayProvider.apple_pay:
        //       PaymentConfiguration.fromJsonString(defaultGooglePay),
        // });
        // var val = await _payClient.userCanPay(PayProvider.google_pay);
        // await _payClient.showPaymentSelector(
        //   PayProvider.google_pay,
        //   [
        //     PaymentItem(
        //       label: 'Total',
        //       amount: price,
        //       type: PaymentItemType.total,
        //       status: PaymentItemStatus.final_price,
        //     )
        //   ],
        // ).then((value) {
        //   print(value);
        //   chatController.putSticker(sticker);
        // }).onError((Err, stacktrace) {
        //   print(Err.toString());
        // });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                spreadRadius: 3,
                blurRadius: 3)
          ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                sticker,
                height: 95.h,
                width: 200.w,
              ),
              SizedBox(
                height: 6.h,
              ),
              Text('$price \$'),
              SizedBox(
                height: 5.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  Message({super.key, required this.message, required this.messageType});

  final String message;
  final String messageType;

  @override
  Widget build(BuildContext context) {
    return messageType == 'me'
        ? MyMessage(
            message: message,
          )
        : OtherPersonMessage(
            message: message,
          );
  }
}

class MyMessage extends StatelessWidget {
  const MyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Get.locale == Locale('ar')
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff215B82).withOpacity(0.25),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            message,
            style: TextStyle(color: Color(0xff215B82), fontSize: 15.w),
          ),
        ),
      ),
    );
  }
}

class OtherPersonMessage extends StatelessWidget {
  const OtherPersonMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffE4E4E4),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.black, fontSize: 15.w),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: 15.w,
          // ),
          // CircleAvatar(
          //   radius: 20.w,
          //   backgroundColor: Colors.white,
          //   backgroundImage:
          //       AssetImage('assets/images/pexels-pixabay-220453.jpg'),
          // ),
        ],
      ),
    );
  }
}
