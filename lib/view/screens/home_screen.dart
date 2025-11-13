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
            toolbarHeight: 70.h,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Image.asset('assets/images/travel win.png'),
            centerTitle: true,
            leadingWidth: 115.w,
            leading: Row(
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Visibility(
                  visible: token.toString() != 'null',
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ProfileScreen);
                    },
                    child: CircleAvatar(
                      radius: 25.w,
                      backgroundColor: Color(0xff92A63D),
                      child: Hero(
                        tag: 'profile',
                        child: Obx(
                          () => profile.value.data == null ||
                                  profile.value.data!.image == ''
                              ? Icon(
                                  Icons.person,
                                  color: mainColor,
                                )
                              : CircleAvatar(
                                  radius: 23.w,
                                  backgroundColor: mainColor,
                                  child: profile.value.data == null ||
                                          profile.value.data!.image == ''
                                      ? Icon(
                                          Icons.person,
                                          color: mainColor,
                                        )
                                      : Container(),
                                  backgroundImage: NetworkImage(
                                      profile.value.data == null
                                          ? ''
                                          : profile.value.data!.image),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                InkWell(
                    onTap: () {
                      Get.toNamed(Routes.SettingsScreen);
                    },
                    child: SvgPicture.asset('assets/images/setting.svg')),
              ],
            ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (token != 'null') {
                        Get.toNamed(Routes.favorites);
                      } else {
                        showSnackBar(context, 'Login is required'.tr);
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/images/favorite.svg',
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (token != 'null') {
                        Get.toNamed(Routes.ViewNotificationScreen);
                      } else {
                        showSnackBar(context, 'Login is required'.tr);
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/images/notification.svg',
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  )
                ],
              )
            ],
          ),
          body: Obx(
            () => home.value!.data == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/Group.png'),
                              fit: BoxFit.fill)),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //   const AdmobBannerUi() ,
                            Obx(
                              () => homeController.homeBanner.value.isEmpty
                                  ? Container()
                                  : MyCarsoulSlider(
                                      items: homeController.homeBanner.value,
                                      height: 0.14,
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      HomeContainer(
                                        svg: 'assets/images/ticket-flight.png',
                                        onTap: () {
                                          launchURL(
                                              'https://www.kiwi.com/en/cheap-flights/');
                                        },
                                        name: 'flight reservations'.tr,
                                      ),
                                      Container(
                                          height: 100.h,
                                          child: VerticalDivider(
                                            color: Colors.grey.withOpacity(0.35),
                                            thickness: 1,
                                          )),
                                      HomeContainer(
                                        svg: 'assets/images/planning.png',
                                        onTap: () {
                                          Get.toNamed(Routes.ViewTripsScreen);
                                        },
                                        name: 'daily trips'.tr,
                                      ),
                                      Container(
                                          height: 100.h,
                                          child: VerticalDivider(
                                            color: Colors.grey.withOpacity(0.35),
                                            thickness: 1,
                                          )),
                                      HomeContainer(
                                        svg: 'assets/images/tourist (2).png',
                                        onTap: () {
                                          Get.toNamed(Routes.MedicalTourism);
                                        },
                                        name: 'Medical tourism'.tr,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Divider(
                                      color: Colors.grey.withOpacity(0.35),
                                      thickness: 1,
                                    ),
                                  ),
                                  //SizedBox(height: 2.h,),
                                  Row(
                                    children: [
                                      HomeContainer(
                                        svg: 'assets/images/needs (1).png',
                                        onTap: () {
                                          showSnackBar(context, 'coming soon'.tr);
                                        },
                                        name: 'Other activities'.tr,
                                      ),
                                      Container(
                                          height: 120,
                                          child: VerticalDivider(
                                            color: Colors.grey.withOpacity(0.35),
                                            thickness: 1,
                                          )),
                                      HomeContainer(
                                        svg: 'assets/images/tourist (3).png',
                                        onTap: () {
                                          Get.toNamed(Routes.SearchTour);
                                        },
                                        name: 'Private tour guide'.tr,
                                      ),
                                      Container(
                                          height: 120,
                                          child: VerticalDivider(
                                            color: Colors.grey.withOpacity(0.35),
                                            thickness: 1,
                                          )),
                                      HomeContainer(
                                        svg: 'assets/images/pharmacy (1).png',
                                        onTap: () {
                                          launchURL(eczanelerUrl);
                                        },
                                        name: 'Duty pharmacies'.tr,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.35),
                                thickness: 1,
                              ),
                            ),
                            Obx(
                              () => home.value!.data!.states!.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tourist areas'.tr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                
                                                Get.toNamed(Routes.tourismAreas);
                                              },
                                              child: Text(
                                                'See All'.tr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp),
                                              ))
                                        ],
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
        
                            SizedBox(
                              height: 187.h,
                              child: ListView.builder(
                                itemBuilder: (context, index) => TourismPlace(
                                  states: home.value!.data!.states![index],
                                  index: index,
                                ),
                                shrinkWrap: false,
                                itemCount: home.value!.data!.states!.length,
                                padding: EdgeInsets.only(bottom: 10),
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
}

class HomeContainer extends StatelessWidget {
  const HomeContainer(
      {super.key, required this.name, required this.svg, required this.onTap});
  final String svg;
  final String name;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: Get.width * 0.28,
            height: Get.height * 0.12,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SizedBox(
                  height: 6.h,
                ),
                Image.asset(
                  svg,
                  height: 50.h,
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 10.w),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
