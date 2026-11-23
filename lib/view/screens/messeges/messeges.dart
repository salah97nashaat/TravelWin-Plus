import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/logic/controllers/chat_controller.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../utils/my_string.dart';

class Messeges extends StatelessWidget {
  const Messeges({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          "Messages".tr,
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      body: Obx(() {
        if (token.value == 'null' || token.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 56.sp, color: Colors.grey.shade400),
                SizedBox(height: 12.h),
                Text(
                  'Login is required'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          );
        }

        final chatList = chats.value?.data ?? [];
        if (chatList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline_rounded,
                    size: 56.sp, color: Colors.grey.shade300),
                SizedBox(height: 12.h),
                Text(
                  'NO Chats yet'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  isAr
                      ? 'ستظهر هنا محادثاتك مع شركاء الأنشطة والمرشدين'
                      : 'Your chats with activity partners will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            chats.value = await RemoteServices.fetchChats();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final item = chatList[index];
              final msg = item.lastMessageReceived?.message ??
                  item.lastMessageSended?.message ??
                  '';
              final rawDate = item.lastMessageReceived?.createdAt ??
                  item.lastMessageSended?.createdAt ??
                  '';
              String formattedDate = '';
              if (rawDate.isNotEmpty) {
                try {
                  final dt = DateTime.parse(rawDate);
                  formattedDate = DateFormat('MM/dd').format(dt);
                } catch (_) {}
              }

              // Animated Item
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 250 + (index * 60).clamp(0, 400)),
                curve: Curves.easeOutQuad,
                builder: (context, val, child) {
                  return Opacity(
                    opacity: val,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - val)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.r),
                      onTap: () async {
                        showLoaderDialog();
                        final idStr = item.id.toString();
                        await RemoteServices.fetchChatMessages(idStr);
                        Get.back();
                        guideName.value = item.name ?? '';
                        guideImage.value = item.image ?? '';
                        guidenceId.value = item.id ?? -1;
                        chatSubtitle.value = '';
                        final chatCtrl = Get.isRegistered<ChatController>()
                            ? Get.find<ChatController>()
                            : Get.put(ChatController());
                        chatCtrl.loadMessages();
                        Get.toNamed(Routes.ChatScreen);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: Row(
                          children: [
                            // Avatar with online status ring
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  backgroundImage: (item.image != null &&
                                          item.image!.isNotEmpty &&
                                          Uri.tryParse(item.image!)?.hasScheme ==
                                              true)
                                      ? NetworkImage(item.image!)
                                      : const AssetImage(
                                              'assets/images/user.png')
                                          as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: isAr ? null : 1,
                                  left: isAr ? 1 : null,
                                  child: Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 12.w),

                            // Name & Snippet
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      if (formattedDate.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 10.5.sp,
                                              color: const Color(0xFF64748B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    msg.isNotEmpty
                                        ? msg
                                        : (isAr ? 'محادثة جديدة' : 'New chat'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: msg.isNotEmpty
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF94A3B8),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        elevation: 3,
        child: const Icon(
          Icons.add_comment_rounded,
          color: Colors.white,
        ),
        onPressed: () async {
          await GuidenceController().fetchGuidence();
          Get.toNamed(Routes.SearchTour);
        },
      ),
    );
  }
}
