import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../helpers/adv/admob_banner.dart';

class TravelAIAssistantScreen extends StatefulWidget {
  const TravelAIAssistantScreen({Key? key}) : super(key: key);

  @override
  State<TravelAIAssistantScreen> createState() => _TravelAIAssistantScreenState();
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({required this.text, required this.isUser, required this.time});
}

class _TravelAIAssistantScreenState extends State<TravelAIAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  static final String _geminiApiKey =
      utf8.decode(base64.decode('QVEuQWI4Uk42STBqb0VQM1BvU0h6V01COWszbGZxaXZWZGt6X01qalNBNm9mMkF6QlRMcGc='));
  static String get _geminiUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=$_geminiApiKey';

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'مرحباً بك! أنا رفيقك السياحي الذكي من TravelWin Plus 🌟\nكيف يمكنني مساعدتك في التخطيط لرحلتك، واقتراح أفضل الأماكن، أو نصائح السفر؟',
      isUser: false,
      time: DateTime.now(),
    ),
  ];

  final List<String> _quickPrompts = [
    'خطط لي رحلة 3 أيام في إسطنبول 🏰',
    'أفضل أماكن طبيعية في طرابزون 🌲',
    'نصائح التسوق واسترداد الضرائب 🛍️',
    'أماكن سياحية مناسبة للعائلات 👨‍👩‍👧',
    'متوسط تكاليف الرحلة السياحية 💵',
  ];

  final Map<String, String> _knowledgeBase = {
    'إسطنبول': 'إسطنبول مدينة التاريخ والسحر! إليك أفضل خطة مقترحة:\n• اليوم 1: منطقة السلطان أحمد (المسجد الأزرق، آيا صوفيا، قصر توبكابي).\n• اليوم 2: جولة البوسفور البحرية، برج غالاتا، وشارع الاستقلال.\n• اليوم 3: تل العرائس وجامع تشامليجا، والتسوق في مول وادي إسطنبول.',
    'طرابزون': 'الشمال التركي جنة الطبيعة! أهم الوجهات:\n• بحيرة أوزنجول الساحرة وقضاء يوم بين الجبال.\n• مرتفعات آيدر وشلالاتها المائية الخلابة.\n• دير سوميلا الأثري المنحوت في الصخر.\n• حيدر نبي والأنشطة الريفية المميزة.',
    'تسوق': 'نصائح التسوق الذكي:\n1. احتفظ بفواتير المشتريات التي تتجاوز 100 ليرة لطلب استرداد الضريبة (Tax Free) في المطار.\n2. أشهر الأسواق: البازار الكبير والسوق المصري للبهارات والحلويات.\n3. أشهر المولات: زورلو سنتر، استينيا بارك، ومول أوف إسطنبول.',
    'عائل': 'أفضل الأماكن العائلية والترفيهية:\n• فيالاند (إسفانبول) - أكبر مدينة ملاهي.\n• أكواريوم فلوريا والحديقة المائية.\n• حديقة أميرجان بإطلالاتها الرائعة على البوسفور.\n• جزر الأميرات وركوب العربات الكهربائية وقضاء يوم ممتع.',
    'تكاليف': 'تقدير متوسط تكاليف الرحلة لشخصين:\n• المواصلات: استخدام كارت المواصلات العام يوفر كثيراً (10-15\$ يومياً).\n• الوجبات: من 15\$ إلى 40\$ للشخص يومياً حسب نوع المطعم.\n• الجولات السياحية: الرحلات اليومية المنظمة تتراوح بين 25\$ إلى 50\$ للفرد شاملة النقل.',
  };

  Future<void> _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(_ChatMessage(text: query, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });

    _scrollToBottom();

    String reply = '';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 15),
      ));

      const systemPrompt =
          "أنت 'المساعد السياحي الذكي' الرسمي لتطبيق TravelWin Plus المتخصص في السياحة والسفر والحجوزات (خصوصاً في تركيا وإسطنبول وطرابزون وبورصة والعالم). "
          "أجب السائح بلطافة واحترافية وبمعلومات سياحية دقيقة ومفيدة ومنسقة بنقاط واضحة. أجب بنفس لغة السائل ولهجته بدون تعقيد وبشكل عملي وممتع.";

      final response = await dio.post(
        _geminiUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'contents': [
            {
              'parts': [
                {'text': '$systemPrompt\n\nسؤال المستخدم: $query'}
              ]
            }
          ]
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final candidates = response.data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            reply = parts[0]['text']?.toString().trim() ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('Gemini Live API Error: $e');
    }

    // Fallback to internal knowledge base if offline or error
    if (reply.isEmpty) {
      reply = 'شكراً لسؤالك! بخصوص "$query"، يسر فريق TravelWin Plus تزويدك بكافة تفاصيل الرحلات والخدمات وحجوزات الفنادق المتاحة عبر أقسام التطبيق المختلفة.\nهل تود مني اقتراح برنامج تفصيلي لمدينة معينة؟';

      for (var key in _knowledgeBase.keys) {
        if (query.contains(key)) {
          reply = _knowledgeBase[key]!;
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => googleGradient.createShader(bounds),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
            ),
            SizedBox(width: 8.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مساعد السفر الذكي ',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => googleGradient.createShader(bounds),
                  child: Text(
                    '(AI Guide)',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Quick Prompts Bar
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: _quickPrompts.map((p) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: ActionChip(
                      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      side: BorderSide(color: goldAccent.withOpacity(0.4), width: 1),
                      label: Text(
                        p,
                        style: TextStyle(fontSize: 11.sp, color: mainColor, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => _sendMessage(p),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, size: 14, color: goldAccent),
                        SizedBox(width: 6.w),
                        Text(
                          'المساعد الذكي يكتب لك الآن...',
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Message Input Field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'اسأل عن وجهة، فندق، أو نصيحة سفر...',
                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    backgroundColor: mainColor,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: goldAccent, size: 20),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final isUser = msg.isUser;
    final isDark = Get.isDarkMode;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        decoration: BoxDecoration(
          color: isUser
              ? mainColor
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isUser ? 16.r : 2.r),
            bottomRight: Radius.circular(isUser ? 2.r : 16.r),
          ),
          border: isUser ? null : Border.all(color: goldAccent.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: 13.sp,
            color: isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
