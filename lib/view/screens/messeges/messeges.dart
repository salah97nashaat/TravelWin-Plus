// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/theme.dart';

import '../../../utils/my_string.dart';

class Messeges extends StatelessWidget {
  const Messeges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Messages".tr,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Obx(
            () => token.value == 'null'
                ? Center(
                    child: Text(
                      'Login is required'.tr,
                      style: TextStyle(fontSize: 25.sp),
                    ),
                  )
                : chats.value!.data == null || chats.value!.data!.isEmpty
                    ? Center(
                        child: Text(
                        'NO Chats yet'.tr,
                        style: TextStyle(fontSize: 25.sp),
                      ))
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            chats.value = (await RemoteServices.fetchChats());
                          },
                          child: ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ChatWidget(
                              image: chats.value!.data![index].image!,
                              message: chats.value!.data![index]
                                          .lastMessageReceived !=
                                      null
                                  ? chats.value!.data![index]
                                          .lastMessageReceived!.message ??
                                      ''
                                  : chats.value!.data![index]
                                              .lastMessageSended !=
                                          null
                                      ? chats.value!.data![index]
                                              .lastMessageSended!.message ??
                                          ''
                                      : '',
                              name: chats.value!.data![index].name!,
                              date: chats.value!.data![index]
                                          .lastMessageReceived !=
                                      null
                                  ? DateFormat('MM/dd').format(DateTime.parse(
                                      chats.value!.data![index]
                                          .lastMessageReceived!.createdAt!))
                                  : chats.value!.data![index]
                                              .lastMessageSended !=
                                          null
                                      ? DateFormat('MM/dd').format(
                                          DateTime.parse(chats
                                              .value!
                                              .data![index]
                                              .lastMessageSended!
                                              .createdAt!))
                                      : '',
                              id: chats.value!.data![index].id!.toString(),
                            ),
                            separatorBuilder: (context, index) => Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Divider(
                                    color: Colors.grey.withOpacity(0.35),
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                            itemCount: chats.value!.data!.length,
                            shrinkWrap: true,
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await GuidenceController().fetchGuidence();
          // print(guidence.value.guidances);
          Get.toNamed(Routes.SearchTour);
        },
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.message,
      required this.date,
      required this.id});

  final String name;
  final String date;
  final String message;
  final String image;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showLoaderDialog();
        await RemoteServices.fetchChatMessages(id).then((value) {
          Get.back();
          guideName.value = name;
          guideImage.value = image;
          guidenceId.value = int.parse(id);
          chatSubtitle.value = '';
          final chatCtrl = Get.isRegistered<ChatController>()
              ? Get.find<ChatController>()
              : Get.put(ChatController());
          chatCtrl.loadMessages();
          Get.toNamed(Routes.ChatScreen);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25.w,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(image),
                ),
                Positioned(
                  bottom: 0,
                  left: 3,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff92A63D),
                    radius: 7,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 15.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 16.w, color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.35,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                          fontSize: 12.w, color: Colors.grey.shade400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.grey, fontSize: 12.w),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
