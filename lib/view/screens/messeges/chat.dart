import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:pay/pay.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/screens/messeges/widgets.dart';
import '../../../logic/controllers/chat_controller.dart';
import '../../../utils/theme.dart';

// import 'payment_configration.dart' as payment_configurations;
class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController controller = TextEditingController();
  ChatController chatController = Get.put(ChatController());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<ProductDetails> _products = [];
  late StreamSubscription<List<PurchaseDetails>> subscription;
  late InAppPurchase _iap;
  initState() {
    super.initState();
    _iap = InAppPurchase.instance;
    subscription = _iap.purchaseStream.listen((event) {});
    _iap.queryProductDetails({'product1', 'product2', 'product3'}).then((e) {
      if (e.error == null) {
        _products.addAll(e.productDetails);
      }
    });
  }

  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    (RemoteServices.fetchChats());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guideName.value,
                style: TextStyle(
                    fontSize: 15.w,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'مرشد سياحي',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12.w),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
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
          leading: Padding(
            padding: Get.locale == Locale('ar')
                ? EdgeInsets.only(right: 15.w, top: 5.h)
                : EdgeInsets.only(left: 15.w, top: 5.h),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 25.w,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(guideImage.value),
                ),
                Positioned(
                  bottom: 5,
                  left: 3,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff92A63D),
                    radius: 5,
                  ),
                )
              ],
            ),
          )),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          // GooglePayButton(
          //   paymentConfigurationAsset: 'gpay.json',
          //   onError: (e){
          //     print(e.toString());
          //   },
          //   paymentItems: [
          //     PaymentItem(
          //       label: 'Total',
          //       amount: '1.99',
          //       status: PaymentItemStatus.final_price,
          //     )
          //   ],
          //   type: GooglePayButtonType.pay,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: (resul){
          //     print(resul);
          //   },
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          Expanded(
            child: Obx(
              () => (chatController.sticker.value.isEmpty)
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'There is no messages in this chat yet choose one of the welcome stickers to start the chat'
                                .tr,
                            style: TextStyle(color: mainColor, fontSize: 15.w),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: 145.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                WelcomeSticker(
                                  sticker: 'assets/images/Hello-bro.svg',
                                  price: '1.99',
                                  onTap: () {
                                    if (_products.isNotEmpty) {
                                      _iap.buyNonConsumable(
                                        purchaseParam: PurchaseParam(
                                            productDetails: _products[0]),
                                      );
                                    } else {
                                      showSnackBar(context,
                                          'Product not available yet, please try again later.');
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                WelcomeSticker(
                                  sticker: 'assets/images/Hello-rafiki 1.svg',
                                  price: '1.99',
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                WelcomeSticker(
                                  sticker: 'assets/images/rose flower-bro.svg',
                                  price: '1.99',
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView(children: [
                      RefreshIndicator(
                      onRefresh: () async {
                        (await RemoteServices.fetchChats());
                      },
                        child: Obx(
                          () => Align(
                            alignment: Alignment.centerRight,
                            child: Visibility(
                                visible: chatController.sticker.isNotEmpty,
                                child: SvgPicture.asset(
                                  chatController.sticker.value,
                                  height: 140.h,
                                  width: 200,
                                )),
                          ),
                        ),
                      ),
                      Obx(                          
                        () => ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15.h,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            //chatController.messages.refresh();
                            return Message(
                                message: chatController
                                        .messages[index].message ??
                                    '',
                                messageType:
                                    chatController.messages[index].byMe!
                                        ? 'me'
                                        : 'other');
                          },
                          itemCount: chatController.messages.length,
                        ),
                      ),
                    ]),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: IconTheme(
              data: IconThemeData(color: mainColor),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6Ff),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/send 2.svg',
                            width: 25,
                            // color: mainColor,
                            colorFilter:
                                ColorFilter.mode(mainColor, BlendMode.srcIn),
                          ),
                          onPressed: () {
                            if (chatController.sticker.value.isEmpty) {
                            } else {
                              if (controller.text.isEmpty) {
                              } else {
                                RemoteServices.SendMessage(guidenceId.value,
                                        controller.text, 'text')
                                    .then((value) async {
                                  if (value == 'sended successfully') {
                                    //chatMessages.value=(await  RemoteServices.fetchChatMessages(guidenceId.value))!;
                                    chatController.messages.add(Data(
                                        id: guidenceId.value,
                                        type: 'text',
                                        byMe: true,
                                        createdAt: '',
                                        message: controller.text));
                                    setState(() {});
                                    controller.clear();
                                    chats.value =
                                        (await RemoteServices.fetchChats())!;
                                  }
                                });
                              }
                            }
                          }),
                    ),
                    Flexible(
                      child: TextField(
                        controller: controller,
                        onSubmitted: (c) {
                          if (chatController.sticker.value.isNotEmpty) {
                          } else {
                            if (controller.text.isEmpty) {
                            } else {
                              RemoteServices.SendMessage(
                                      guidenceId.value, controller.text, 'text')
                                  .then((value) async {
                                if (value == 'sended successfully') {
                                  chatMessages.value =
                                      (await RemoteServices.fetchChatMessages(
                                          guidenceId.value))!;
                                }
                              });
                              controller.clear();
                              setState(() {});
                            }
                          }
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: "Send a message".tr,
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
