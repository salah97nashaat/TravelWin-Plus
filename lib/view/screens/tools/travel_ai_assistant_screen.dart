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

  late List<_ChatMessage> _messages;
  String? _contextPlaceName;
  List<String>? _customPlacePrompts;

  final List<String> _quickPromptsAr = [
    'خطط لي رحلة 3 أيام في إسطنبول 🏰',
    'أفضل أماكن طبيعية في طرابزون 🌲',
    'نصائح التسوق واسترداد الضرائب 🛍️',
    'أماكن سياحية مناسبة للعائلات 👨‍👩‍👧',
    'متوسط تكاليف الرحلة السياحية 💵',
  ];

  final List<String> _quickPromptsEn = [
    'Plan a 3-day itinerary in Istanbul 🏰',
    'Top scenic nature spots in Trabzon 🌲',
    'Shopping tips & Tax-Free guide 🛍️',
    'Family-friendly attractions 👨‍👩‍👧',
    'Estimated travel expenses & budget 💵',
  ];

  final Map<String, String> _knowledgeBaseAr = {
    'إسطنبول': 'إسطنبول مدينة التاريخ والسحر! إليك أفضل خطة مقترحة:\n• اليوم 1: منطقة السلطان أحمد (المسجد الأزرق، آيا صوفيا، قصر توبكابي).\n• اليوم 2: جولة البوسفور البحرية، برج غالاتا، وشارع الاستقلال.\n• اليوم 3: تل العرائس وجامع تشامليجا، والتسوق في مول وادي إسطنبول.',
    'طرابزون': 'الشمال التركي جنة الطبيعة! أهم الوجهات:\n• بحيرة أوزنجول الساحرة وقضاء يوم بين الجبال.\n• مرتفعات آيدر وشلالاتها المائية الخلابة.\n• دير سوميلا الأثري المنحوت في الصخر.\n• حيدر نبي والأنشطة الريفية المميزة.',
    'تسوق': 'نصائح التسوق الذكي:\n1. احتفظ بفواتير المشتريات التي تتجاوز 100 ليرة لطلب استرداد الضريبة (Tax Free) في المطار.\n2. أشهر الأسواق: البازار الكبير والسوق المصري للبهارات والحلويات.\n3. أشهر المولات: زورلو سنتر، استينيا بارك، ومول أوف إسطنبول.',
    'عائل': 'أفضل الأماكن العائلية والترفيهية:\n• فيالاند (إسفانبول) - أكبر مدينة ملاهي.\n• أكواريوم فلوريا والحديقة المائية.\n• حديقة أميرجان بإطلالاتها الرائعة على البوسفور.\n• جزر الأميرات وركوب العربات الكهربائية وقضاء يوم ممتع.',
    'تكاليف': 'تقدير متوسط تكاليف الرحلة لشخصين:\n• المواصلات: استخدام كارت المواصلات العام يوفر كثيراً (10-15\$ يومياً).\n• الوجبات: من 15\$ إلى 40\$ للشخص يومياً حسب نوع المطعم.\n• الجولات السياحية: الرحلات اليومية المنظمة تتراوح بين 25\$ إلى 50\$ للفرد شاملة النقل.',
  };

  final Map<String, String> _knowledgeBaseEn = {
    'istanbul': 'Istanbul: A city where East meets West! Recommended 3-day plan:\n• Day 1: Historic Sultanahmet (Blue Mosque, Hagia Sophia, Topkapi Palace).\n• Day 2: Bosphorus Cruise, Galata Tower, and Istiklal Street.\n• Day 3: Camlica Hill & Mosque, and shopping at Vadistanbul Mall.',
    'trabzon': 'Trabzon & Black Sea nature highlights:\n• Uzungöl Lake: Breathtaking mountain lake day trip.\n• Ayder Plateau: Thermal springs and stunning waterfalls.\n• Sumela Monastery: Ancient historic cliff-side monastery.\n• Hıdırnebi Plateau: Serene village and nature walks.',
    'shopping': 'Smart Shopping Tips in Turkey:\n1. Keep receipts over 100 TL for Tax-Free VAT refund at airports.\n2. Historic Bazaars: Grand Bazaar and Spice Bazaar for authentic sweets & spices.\n3. Modern Malls: Zorlu Center, Istinye Park, and Mall of Istanbul.',
    'family': 'Top Family & Fun Attractions:\n• Vialand (Isfanbul) Theme Park.\n• Florya Aquarium and coastal park.\n• Emirgan Park with panoramic Bosphorus views.\n• Princes\' Islands for a calm day trip with electric shuttles and bicycles.',
    'cost': 'Average Travel Budget for Two in Turkey:\n• Transport: Public transit Istanbulkart is very economical (\$10-\$15/day).\n• Dining: \$15 to \$40 per person per day depending on venue.\n• Day Tours: Group excursions range between \$25 to \$50 per person.',
  };

  @override
  void initState() {
    super.initState();
    final bool isAr = Get.locale?.languageCode == 'ar';

    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('placeName')) {
      final name = args['placeName']?.toString();
      if (name != null && name.trim().isNotEmpty) {
        _contextPlaceName = name.trim();
        _customPlacePrompts = isAr
            ? [
                'أفضل المطاعم والمقاهي القريبة من $_contextPlaceName 🍽️',
                'أفضل وقت وزاوية لالتقاط الصور في $_contextPlaceName 📸',
                'نصائح هامة وتنبيهات الزيارة لـ $_contextPlaceName 💡',
                'كيف أصل بالمواصلات إلى $_contextPlaceName؟ 🚗',
              ]
            : [
                'Best restaurants & cafes near $_contextPlaceName 🍽️',
                'Top photo spots & timing at $_contextPlaceName 📸',
                'Important visiting tips for $_contextPlaceName 💡',
                'How to get to $_contextPlaceName by transport? 🚗',
              ];
      }
    }

    final welcomeText = _contextPlaceName != null
        ? (isAr
            ? 'أهلاً بك! أنا رفيقك السياحي الذكي 🌟\nأنا جاهز لمساعدتك بكل ما يخص ($_contextPlaceName)!\nما الذي تود معرفته عن هذا المكان؟'
            : 'Welcome! I am your AI Travel Concierge 🌟\nI am ready to help you with everything about ($_contextPlaceName)!\nWhat would you like to know about this spot?')
        : (isAr
            ? 'مرحباً بك! أنا رفيقك السياحي الذكي من TravelWin Plus 🌟\nكيف يمكنني مساعدتك في التخطيط لرحلتك، واقتراح أفضل الأماكن، أو نصائح السفر؟'
            : 'Welcome! I am your AI Travel Concierge from TravelWin Plus 🌟\nHow can I help you plan your itinerary, recommend top attractions, or share essential travel tips?');

    _messages = [
      _ChatMessage(
        text: welcomeText,
        isUser: false,
        time: DateTime.now(),
      ),
    ];
  }

  Future<void> _sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    final bool isAr = Get.locale?.languageCode == 'ar';
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

      final placeContext = _contextPlaceName != null
          ? (isAr
              ? "السياق الحالي: السائح يستفسر بالتحديد عن '$_contextPlaceName' في تركيا. "
              : "Current Context: The tourist is inquiring specifically about '$_contextPlaceName' in Turkey. ")
          : "";

      final systemPrompt = isAr
          ? "أنت 'المساعد السياحي الذكي' الرسمي لتطبيق TravelWin Plus المتخصص في السياحة والسفر والحجوزات (خصوصاً في تركيا وإسطنبول وطرابزون وبورصة والعالم). "
            "$placeContext"
            "أجب السائح بلطافة واحترافية وبمعلومات سياحية دقيقة ومفيدة ومنسقة بنقاط واضحة. أجب باللغة العربية بأسلوب عملي وممتع."
          : "You are the official 'AI Travel Concierge' for TravelWin Plus, specialized in travel, tourism, and bookings (especially in Turkey, Istanbul, Trabzon, Bursa, and worldwide). "
            "$placeContext"
            "Provide tourists with polite, accurate, practical, and well-structured travel recommendations and itineraries formatted with clear bullet points. Answer in English.";

      final response = await dio.post(
        _geminiUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'contents': [
            {
              'parts': [
                {'text': '$systemPrompt\n\nUser Question: $query'}
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
            reply = parts[0]['text'] ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('Gemini API call failed, using local travel engine: $e');
    }

    // High quality offline fallback
    if (reply.trim().isEmpty) {
      reply = _generateLocalAnswer(query, isAr);
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      });
      _scrollToBottom();
    }
  }

  String _generateLocalAnswer(String query, bool isAr) {
    final lower = query.toLowerCase();
    final kb = isAr ? _knowledgeBaseAr : _knowledgeBaseEn;

    for (final entry in kb.entries) {
      if (lower.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    if (isAr) {
      return "شكراً لسؤالك! بخصوص '$query':\n"
          "يسعدنا في TravelWin مساعدتك بأفضل التوصيات. ننصحك دائماً بالتخطيط المسبق لحجوزاتك، واختيار المواقع القريبة من محطات المواصلات الرئيسية لسهولة التنقل. "
          "هل تود الحصول على خطة سياحية مخصصة أو الاستفسار عن منطقة محددة؟";
    } else {
      return "Thank you for asking! Regarding '$query':\n"
          "At TravelWin, we are delighted to assist you with the best travel recommendations. We always suggest booking attractions in advance and staying close to primary transit lines for effortless travel. "
          "Would you like a customized daily itinerary or tips for a specific city?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final bool isDark = Get.isDarkMode;
    final bool isAr = Get.locale?.languageCode == 'ar';
    final quickPrompts = _customPlacePrompts ?? (isAr ? _quickPromptsAr : _quickPromptsEn);

    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: goldAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: goldAccent, size: 18),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAr ? 'المساعد السياحي الذكي' : 'AI Travel Concierge',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  isAr ? 'مدعوم بالذكاء الاصطناعي • متصل' : 'AI Powered • Online',
                  style: TextStyle(fontSize: 10.sp, color: Colors.greenAccent),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg, isDark);
              },
            ),
          ),

          // Typing indicator
          if (_isTyping)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: mainColor),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isAr ? 'المساعد الذكي يكتب لك الآن...' : 'AI Assistant is typing...',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Quick Suggestion Chips
          Container(
            height: 38.h,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: quickPrompts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ActionChip(
                    label: Text(quickPrompts[index]),
                    labelStyle: TextStyle(fontSize: 11.sp, color: mainColor, fontWeight: FontWeight.w600),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    side: BorderSide(color: mainColor.withOpacity(0.2)),
                    onPressed: () => _sendMessage(quickPrompts[index]),
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: isAr ? 'اسأل المساعد الذكي عن أي مكان...' : 'Ask the AI Guide anything...',
                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [mainColor, Color(0xFF1E3A8A)]),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
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

  Widget _buildMessageBubble(_ChatMessage msg, bool isDark) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 0.82.sw),
        decoration: BoxDecoration(
          color: msg.isUser
              ? mainColor
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(msg.isUser ? 16.r : 4.r),
            bottomRight: Radius.circular(msg.isUser ? 4.r : 16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SelectableText(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
            fontSize: 13.5.sp,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
