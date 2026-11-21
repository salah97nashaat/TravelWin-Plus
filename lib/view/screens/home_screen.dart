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
            // --- RIGHT: Favorite & Notification ---
            actions: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.travelAIAssistantScreen);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFF4285F4).withOpacity(0.4), width: 1.2),
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
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                      ),
                      SizedBox(width: 5.w),
                      ShaderMask(
                        shaderCallback: (bounds) => googleGradient.createShader(bounds),
                        child: Text(
                          'AI Guide',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
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
              ),
              SizedBox(width: 8.w),
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
              SizedBox(width: 8.w),
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
              SizedBox(width: 15.w),
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
                        padding: EdgeInsets.only(top: 10.h),
                        child: MyCarsoulSlider(
                          items: homeController.homeBanner.value,
                          height: 0.18, // Adjusted height to fit screen
                        ),
                      )),

                // 2. MIDDLE SECTION: Action Grid (Fixed 3x2 Grid)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Important
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.w,
                    crossAxisSpacing: 12.w,
                    childAspectRatio:
                        1.1, // Adjust this to make items shorter/taller
                    children: [
                      HomeActionItem(
                        title: 'Flights',
                        imagePath: 'assets/images/ticket-flight.png',
                        onTap: () => launchURL('https://kiwi.com'),
                      ),
                      HomeActionItem(
                        title: 'Daily Trips',
                        imagePath: 'assets/images/planning.png',
                        onTap: () => Get.toNamed(Routes.ViewTripsScreen),
                      ),
                      HomeActionItem(
                        title: 'Medical',
                        imagePath: 'assets/images/tourist (2).png',
                        onTap: () => Get.toNamed(Routes.MedicalTourism),
                      ),
                      HomeActionItem(
                        title: 'Activities',
                        imagePath: 'assets/images/needs (1).png',
                        onTap: () => Get.toNamed(
                            Routes.ActivitiesScreen), // New Activities tab
                      ),
                      HomeActionItem(
                        title: 'Guide',
                        imagePath: 'assets/images/tourist (3).png',
                        onTap: () => Get.toNamed(Routes.SearchTour),
                      ),
                      HomeActionItem(
                        title: 'Pharmacies',
                        imagePath: 'assets/images/pharmacy (1).png',
                        onTap: () => launchURL(eczanelerUrl),
                      ),
                    ],
                  ),
                ),

                // 3. BOTTOM SECTION HEADER
                Obx(() {
                  final states = home.value?.data?.states ?? const [];
                  return states.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tourist areas'.tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () => Get.toNamed(Routes.tourismAreas),
                                child: Text(
                                  'See All'.tr,
                                  style: TextStyle(
                                      color: mainColor, fontSize: 13.sp),
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
                      padding: EdgeInsets.only(
                          left: 15.w, right: 15.w, bottom: 20.h),
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

// Modern Home Action Button
class HomeActionItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const HomeActionItem(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40.h),
            SizedBox(height: 8.h),
            Text(
              title.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            )
          ],
        ),
      ),
    );
  }
}
