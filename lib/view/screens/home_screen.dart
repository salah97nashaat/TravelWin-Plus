import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/logic/controllers/guidence_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:upgrader/upgrader.dart';
import '../../helpers/helper.dart';
import '../../logic/controllers/home_controller.dart';
import '../../routes/routes.dart';
import '../../services/profile_services.dart';
import '../../utils/theme.dart';
import 'package:travelwin/services/notification_services.dart' as n;
// import '../widgets/card_ui.dart';
import '../widgets/slider/carsoul_slider.dart';
import '../widgets/tourism_place.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final GetStorage authBox = GetStorage();
  GuidenceController guidenceController = Get.put(GuidenceController());

  final String eczanelerUrl = 'https://www.eczaneler.gen.tr/';
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((event) async {
      showSnackBar(
        context,
        event.notification!.title! + '\n' + event.notification!.body!,
      );
      chatMessages.value =
          (await RemoteServices.fetchChatMessages(guidenceId.value))!;
      notification.value = (await n.RemoteServices.fetchNotifications('1'))!;
      print(
          'Got a message whilst in the foreground!----------------------------------------');
      print('Message data: ${event.data}');

      if (event.notification != null) {
        print('Message also contained a notification: ${event.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      showSnackBar(
        context,
        event.notification!.title! + '\n' + event.notification!.body!,
      );
      chatMessages.value =
          (await RemoteServices.fetchChatMessages(guidenceId.value))!;
      notification.value = (await n.RemoteServices.fetchNotifications('1'))!;
      print(
          'Got a message whilst in the foreground!----------------------------------------');
      print('Message data: ${event.data}');

      if (event.notification != null) {
        print('Message also contained a notification: ${event.notification}');
      }
    });
    super.initState();
  }

  final AdController adController = Get.find();
  @override
  Widget build(BuildContext context) {
    String token = authBox.read('token').toString();
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'.tr),
              content: Text('Do you want to exit an App?'.tr),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white
                      //  minimumSize: const Size(360, 50),
                      ),
                  // color: Get.isDarkMode ? darkGreyClr : mainColor,
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text("No".tr),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white
                      //  minimumSize: const Size(360, 50),
                      ),
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'.tr),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup, //call function on back button press
      child: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        dialogStyle: UpgradeDialogStyle.material,
        shouldPopScope: () => false,
        upgrader: Upgrader(
            //debugDisplayAlways: true, // remove this in production
            ),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            toolbarHeight: 75.h,
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            // --- CENTER: Logo ---
            title: Image.asset(
              'assets/images/travel win.png',
              height: 38.h,
              fit: BoxFit.contain,
            ),
            // --- LEFT: Profile & Settings ---
            leadingWidth: 120.w,
            leading: Row(
              children: [
                SizedBox(width: 15.w),
                // 1. Profile with Static Fallback
                Visibility(
                  visible: token.toString() != 'null',
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.ProfileScreen),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: mainColor.withOpacity(0.3), width: 1.5),
                      ),
                      child: Obx(() {
                        final imageUrl = profile.value.data?.image;
                        final profileImageUri =
                            imageUrl == null ? null : Uri.tryParse(imageUrl);
                        final bool hasImage = profileImageUri != null &&
                            profileImageUri.hasScheme &&
                            profileImageUri.host.isNotEmpty &&
                            !profileImageUri.path.endsWith('/public/') &&
                            profileImageUri.path != '/';

                        return CircleAvatar(
                          radius: 20.w,
                          backgroundColor: Colors.white,
                          // If hasImage is true, use NetworkImage, else use static Asset
                          backgroundImage: hasImage
                              ? NetworkImage(imageUrl!)
                              : const AssetImage('assets/images/user.png')
                                  as ImageProvider, // <-- Your static user image path
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // 2. Settings
                _buildIconButton(
                  icon: 'assets/images/setting.svg',
                  onTap: () => Get.toNamed(Routes.SettingsScreen),
                ),
              ],
            ),
            // --- RIGHT: Tools, Favorite & Notification ---
            actions: [
              if (Get.locale?.languageCode == 'ar') ...[
                // Arabic (RTL): Right is Emergency, Middle is AI, Left is Currency
                _buildEmergencyButton(),
                SizedBox(width: 6.w),
                _buildAiButton(),
                SizedBox(width: 6.w),
                _buildCurrencyButton(),
              ] else ...[
                // English (LTR): Left is Currency, Middle is AI, Right is Emergency
                _buildCurrencyButton(),
                SizedBox(width: 6.w),
                _buildAiButton(),
                SizedBox(width: 6.w),
                _buildEmergencyButton(),
              ],
              SizedBox(width: 6.w),
              _buildIconButton(
                icon: 'assets/images/favorite.svg',
                onTap: () {
                  if (token != 'null') {
                    Get.toNamed(Routes.favorites);
                  } else {
                    showSnackBar(context, 'Login is required'.tr);
                  }
                },
              ),
              SizedBox(width: 6.w),
              _buildIconButton(
                icon: 'assets/images/notification.svg',
                onTap: () {
                  if (token != 'null') {
                    Get.toNamed(Routes.ViewNotificationScreen);
                  } else {
                    showSnackBar(context, 'Login is required'.tr);
                  }
                },
              ),
              SizedBox(width: 12.w),
            ],
          ),
          // AppBar(
          //   toolbarHeight: 70.h,
          //   elevation: 0,
          //   backgroundColor: Colors.white,
          //   title: Image.asset('assets/images/travel win.png'),
          //   centerTitle: true,
          //   leadingWidth: 115.w,
          //   leading: Row(
          //     children: [
          //       SizedBox(
          //         width: 15.w,
          //       ),
          //       Visibility(
          //         visible: token.toString() != 'null',
          //         child: GestureDetector(
          //           onTap: () {
          //             Get.toNamed(Routes.ProfileScreen);
          //           },
          //           child: CircleAvatar(
          //             radius: 25.w,
          //             backgroundColor: Color(0xff92A63D),
          //             child: Hero(
          //               tag: 'profile',
          //               child: Obx(
          //                 () => profile.value.data == null ||
          //                         profile.value.data!.image == ''
          //                     ? Icon(
          //                         Icons.person,
          //                         color: mainColor,
          //                       )
          //                     : CircleAvatar(
          //                         radius: 23.w,
          //                         backgroundColor: mainColor,
          //                         child: profile.value.data == null ||
          //                                 profile.value.data!.image == ''
          //                             ? Icon(
          //                                 Icons.person,
          //                                 color: mainColor,
          //                               )
          //                             : Container(),
          //                         backgroundImage: NetworkImage(
          //                             profile.value.data == null
          //                                 ? ''
          //                                 : profile.value.data!.image),
          //                       ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 15.w,
          //       ),
          //       InkWell(
          //           onTap: () {
          //             Get.toNamed(Routes.SettingsScreen);
          //           },
          //           child: SvgPicture.asset('assets/images/setting.svg')),
          //     ],
          //   ),
          //   actions: [
          //     Row(
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             if (token != 'null') {
          //               Get.toNamed(Routes.favorites);
          //             } else {
          //               showSnackBar(context, 'Login is required'.tr);
          //             }
          //           },
          //           child: SvgPicture.asset(
          //             'assets/images/favorite.svg',
          //           ),
          //         ),
          //         SizedBox(
          //           width: 10.w,
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             if (token != 'null') {
          //               Get.toNamed(Routes.ViewNotificationScreen);
          //             } else {
          //               showSnackBar(context, 'Login is required'.tr);
          //             }
          //           },
          //           child: SvgPicture.asset(
          //             'assets/images/notification.svg',
          //           ),
          //         ),
          //         SizedBox(
          //           width: 15.w,
          //         )
          //       ],
          //     )
          //   ],
          // ),
          body: Container(
            width: Get.width,
            height: Get.height, // Locks the height to the screen size
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Group.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                // 1. TOP SECTION: Carousel Slider (approx 22% of height)
                Obx(() => homeController.homeBanner.value.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: MyCarsoulSlider(
                          items: homeController.homeBanner.value,
                          height: 0.165, // Adjusted height to fit screen comfortably
                        ),
                      )),

                // --- SLIM WEATHER MICRO TICKER (Non-cluttering) ---
                _buildWeatherBar(),

                // 2. MIDDLE SECTION: Action Grid (Fixed 3x2 Grid)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Important
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1.15, // Sleek modern proportion
                    children: [
                      HomeActionItem(
                        title: 'Flights',
                        icon: Icons.flight_takeoff_rounded,
                        gradientColors: const [Color(0xFF2563EB), Color(0xFF38BDF8)],
                        onTap: () => launchURL('https://kiwi.com'),
                      ),
                      HomeActionItem(
                        title: 'Daily Trips',
                        icon: Icons.explore_rounded,
                        gradientColors: const [Color(0xFF059669), Color(0xFF34D399)],
                        onTap: () => Get.toNamed(Routes.ViewTripsScreen),
                      ),
                      HomeActionItem(
                        title: 'Medical',
                        icon: Icons.health_and_safety_rounded,
                        gradientColors: const [Color(0xFFE11D48), Color(0xFFFB7185)],
                        onTap: () => Get.toNamed(Routes.MedicalTourism),
                      ),
                      HomeActionItem(
                        title: 'Activities',
                        icon: Icons.attractions_rounded,
                        gradientColors: const [Color(0xFFD97706), Color(0xFFFBBF24)],
                        onTap: () => Get.toNamed(Routes.ActivitiesScreen),
                      ),
                      HomeActionItem(
                        title: 'Guide',
                        icon: Icons.badge_rounded,
                        gradientColors: const [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                        onTap: () => Get.toNamed(Routes.SearchTour),
                      ),
                      HomeActionItem(
                        title: 'Pharmacies',
                        icon: Icons.local_pharmacy_rounded,
                        gradientColors: const [Color(0xFF0D9488), Color(0xFF2DD4BF)],
                        onTap: () => launchURL(eczanelerUrl),
                      ),
                    ],
                  ),
                ),

                // 3. BOTTOM SECTION HEADER
                Obx(() {
                  final states = home.value?.data?.states ?? const [];
                  final count = states.length;
                  return states.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    Get.locale?.languageCode == 'ar'
                                        ? 'المناطق والولايات'
                                        : 'Tourist Provinces',
                                    style: TextStyle(
                                        color: const Color(0xFF0F172A),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0F2FE),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                          color: const Color(0xFF0284C7)
                                              .withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      Get.locale?.languageCode == 'ar'
                                          ? '$count ولاية 🇹🇷'
                                          : '$count States 🇹🇷',
                                      style: TextStyle(
                                        color: const Color(0xFF0284C7),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => Get.toNamed(Routes.tourismAreas),
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 4.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        Get.locale?.languageCode == 'ar'
                                            ? 'عرض الكل'
                                            : 'See All',
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(width: 3.w),
                                      Icon(
                                        Get.locale?.languageCode == 'ar'
                                            ? Icons.arrow_back_ios_new_rounded
                                            : Icons.arrow_forward_ios_rounded,
                                        size: 11.sp,
                                        color: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                }),

                // 4. BOTTOM SECTION: Horizontal List (Fills remaining space)
                Expanded(
                  child: Obx(() {
                    final states = home.value?.data?.states ?? const [];
                    if (states.isEmpty) {
                      return homeController.isHomeLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: states.length,
                      itemBuilder: (context, index) => TourismPlace(
                        states: states[index],
                        index: index,
                      ),
                    );
                  }),
                ),

                // Buffer space for the Bottom Nav Bar
                SizedBox(height: 5.h),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          //   onPressed: () {
          //     Get.toNamed(Routes.ViewTicketScreen);
          //   },
          //   // tooltip: 'Increment',
          //   child: const Icon(Icons.credit_card, color: Colors.white),
          // ),
        ),
      ),
    );
  }

  // Widget _buildAppBarButton(
  //     {required String icon, required VoidCallback onTap}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 5.w),
  //     child: Center(
  //       child: InkWell(
  //         onTap: onTap,
  //         borderRadius: BorderRadius.circular(12),
  //         child: Container(
  //           height: 40.w,
  //           width: 40.w,
  //           padding: EdgeInsets.all(10.w),
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade50, // Very subtle background
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(color: Colors.grey.shade100),
  //           ),
  //           child: SvgPicture.asset(
  //             icon,
  //             colorFilter:
  //                 const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAiButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.travelAIAssistantScreen);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: const Color(0xFF4285F4).withOpacity(0.4), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4285F4).withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => googleGradient.createShader(bounds),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 15),
            ),
            SizedBox(width: 4.w),
            ShaderMask(
              shaderCallback: (bounds) => googleGradient.createShader(bounds),
              child: Text(
                'AI Salo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.currencyConverterScreen);
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.currency_exchange_rounded,
          color: Color(0xFFD4AF37),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.emergencyGuideScreen);
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.emergency_outlined,
          color: Color(0xFFEF4444),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildWeatherBar() {
    final bool isAr = Get.locale?.languageCode == 'ar';
    final List<Map<String, dynamic>> citiesWeather = [
      {'nameAr': 'إسطنبول', 'nameEn': 'Istanbul', 'temp': '19°', 'icon': '🌤️'},
      {'nameAr': 'طرابزون', 'nameEn': 'Trabzon', 'temp': '15°', 'icon': '🌧️'},
      {'nameAr': 'أنطاليا', 'nameEn': 'Antalya', 'temp': '24°', 'icon': '☀️'},
      {'nameAr': 'كبادوكيا', 'nameEn': 'Cappadocia', 'temp': '16°', 'icon': '⛅'},
      {'nameAr': 'بورصة', 'nameEn': 'Bursa', 'temp': '17°', 'icon': '🌦️'},
      {'nameAr': 'ريزا', 'nameEn': 'Rize', 'temp': '14°', 'icon': '🌲'},
      {'nameAr': 'فتحية', 'nameEn': 'Fethiye', 'temp': '23°', 'icon': '🏖️'},
    ];

    return Container(
      height: 27.h,
      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: citiesWeather.length,
        itemBuilder: (context, index) {
          final item = citiesWeather[index];
          return AnimatedWeatherChip(item: item, isAr: isAr);
        },
      ),
    );
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.asset(
          icon,
          height: 18.h,
          colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
        ),
      ),
    );
  }
}

// Animated Weather Chip with Dynamic Weather Micro-Animations
class AnimatedWeatherChip extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isAr;

  const AnimatedWeatherChip({
    super.key,
    required this.item,
    required this.isAr,
  });

  @override
  State<AnimatedWeatherChip> createState() => _AnimatedWeatherChipState();
}

class _AnimatedWeatherChipState extends State<AnimatedWeatherChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String icon = widget.item['icon']!;
    final bool isRain = icon.contains('🌧️') || icon.contains('🌦️');
    final bool isSun = icon.contains('☀️') || icon.contains('🌤️');
    final String cityName =
        widget.isAr ? widget.item['nameAr']! : widget.item['nameEn']!;

    return Container(
      margin: EdgeInsets.only(
          right: widget.isAr ? 0 : 8.w, left: widget.isAr ? 8.w : 0),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSun
              ? Colors.amber.withOpacity(0.3)
              : (isRain
                  ? Colors.blue.withOpacity(0.25)
                  : Colors.blueGrey.withOpacity(0.12)),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: isSun
                ? Colors.amber.withOpacity(0.08)
                : Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              if (isSun) {
                // Sun pulses with smooth scale
                return Transform.scale(
                  scale: 1.0 + (_anim.value.abs() * 0.1),
                  child: child,
                );
              } else if (isRain) {
                // Rain gently bobs up/down like falling droplets
                return Transform.translate(
                  offset: Offset(0, _anim.value),
                  child: child,
                );
              } else {
                // Clouds gently drift horizontally
                return Transform.translate(
                  offset: Offset(_anim.value, 0),
                  child: child,
                );
              }
            },
            child: Text(
              icon,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            cityName,
            style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              widget.item['temp']!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0284C7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modern Animated Home Action Button (Pulse Glow & Spring Tap)
class HomeActionItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const HomeActionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<HomeActionItem> createState() => _HomeActionItemState();
}

class _HomeActionItemState extends State<HomeActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.93 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: widget.gradientColors.first.withOpacity(0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.gradientColors.first.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.gradientColors.first
                                    .withOpacity(0.35 * _pulseAnimation.value),
                                blurRadius: 6 * _pulseAnimation.value,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 19.sp,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.title.tr,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
