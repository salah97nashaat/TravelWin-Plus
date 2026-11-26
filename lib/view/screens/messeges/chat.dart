import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/screens/messeges/widgets.dart';
import '../../../logic/controllers/chat_controller.dart';
import '../../../utils/theme.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController controller = TextEditingController();
  late final ChatController chatController;
  final ScrollController _scrollController = ScrollController();
  Timer? _pollTimer;
  StreamSubscription<RemoteMessage>? _fcmSub;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    chatController = Get.isRegistered<ChatController>()
        ? Get.find<ChatController>()
        : Get.put(ChatController());
    chatController.loadMessages();
    _scrollToBottom();

    // 1. Instant FCM trigger: as soon as a message arrives from server via push, refresh immediately!
    _fcmSub = FirebaseMessaging.onMessage.listen((message) {
      if (!mounted) return;
      _fetchLatestMessages();
    });

    // 2. Ultra-responsive 1.5s background polling ticker for real-time moment-by-moment chat
    _pollTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      _fetchLatestMessages();
    });
  }

  Future<void> _fetchLatestMessages() async {
    if (!mounted || guidenceId.value <= 0 || _isFetching) return;
    _isFetching = true;
    try {
      final res = await RemoteServices.fetchChatMessages(guidenceId.value.toString());
      if (res != null && res.data != null && mounted) {
        final remote = res.data!;
        final current = chatController.messages;
        final bool changed = remote.length != current.length ||
            (remote.isNotEmpty && current.isNotEmpty && remote.last.message != current.last.message);
        if (changed) {
          chatController.loadMessages();
          _scrollToBottom();
        }
      }
    } catch (_) {} finally {
      _isFetching = false;
    }
  }

  @override
  void dispose() {
    _fcmSub?.cancel();
    _pollTimer?.cancel();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty || guidenceId.value <= 0) return;
    controller.clear();

    final newMsg = Data(
      id: guidenceId.value,
      type: 'text',
      byMe: true,
      createdAt: DateTime.now().toIso8601String(),
      message: text,
    );
    chatController.messages.add(newMsg);
    _scrollToBottom();

    RemoteServices.SendMessage(guidenceId.value, text, 'text').then((val) {
      _fetchLatestMessages();
      RemoteServices.fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 0,
        title: Obx(() {
          final title = guideName.value.isNotEmpty
              ? guideName.value
              : (isAr ? 'محادثة' : 'Chat');
          final subtitle = chatSubtitle.value.isNotEmpty
              ? chatSubtitle.value
              : (isAr ? 'محادثة مباشرة' : 'Direct Chat');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          );
        }),
        leading: Obx(() {
          final imgUrl = guideImage.value;
          final hasValidUrl =
              imgUrl.isNotEmpty && Uri.tryParse(imgUrl)?.hasScheme == true;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFFE2E8F0),
              backgroundImage: hasValidUrl
                  ? NetworkImage(imgUrl)
                  : const AssetImage('assets/images/user.png') as ImageProvider,
            ),
          );
        }),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(20.r),
              child: Transform.flip(
                flipX: !isAr,
                child: SvgPicture.asset(
                  'assets/images/back.svg',
                  height: 26.h,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 54.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        isAr
                            ? 'لا توجد رسائل سابقة.\nابدأ المحادثة الآن! 👋'
                            : 'No messages yet.\nStart the conversation now! 👋',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 13.5.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (guidenceId.value > 0) {
                    await RemoteServices.fetchChatMessages(
                        guidenceId.value.toString());
                    chatController.loadMessages();
                  }
                },
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  itemBuilder: (context, index) {
                    final msg = chatController.messages[index];
                    return Message(
                      message: msg.message ?? '',
                      messageType:
                          (msg.byMe == true) ? 'me' : 'other',
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10.h),
                  itemCount: chatController.messages.length,
                ),
              );
            }),
          ),

          // Ad Banner
          const AdmobBannerUi(),

          // Message Input Field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/send 2.svg',
                        width: 22.sp,
                        colorFilter:
                            ColorFilter.mode(mainColor, BlendMode.srcIn),
                      ),
                      onPressed: _sendMessage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isAr ? 'اكتب رسالتك هنا...' : 'Type a message...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 13.sp,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                        ),
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
