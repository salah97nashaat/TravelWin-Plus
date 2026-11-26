import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../logic/controllers/main_controller.dart';
import '../../logic/controllers/service_controller.dart';
import '../../routes/routes.dart';
import '../../helpers/helper.dart';
import '../../utils/my_string.dart';
import '../../utils/theme.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final controller = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    // Length is 5: Home, Services, TWA, Activities, Messages
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Helper widget to build nav items to keep code clean and attractive
  Widget buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    VoidCallback? customTap,
  }) {
    bool isActive = controller.currentIndex.value == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          if (customTap != null) {
            customTap();
          } else {
            setState(() {
              controller.currentIndex.value = index;
              tabController.animateTo(index);
            });
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.only(bottom: 4.h),
              child: SvgPicture.asset(
                iconPath,
                height: isActive ? 22.h : 18.h, // Slight scale effect for active icon
                colorFilter: ColorFilter.mode(
                    isActive ? mainColor : Colors.grey.shade600,
                    BlendMode.srcIn),
              ),
            ),
            Text(
              label.tr,
              style: TextStyle(
                color: isActive ? mainColor : Colors.grey.shade600,
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            // Indicator Line
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: EdgeInsets.only(top: 4.h),
                height: 3.h,
                width: 20.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      height: 85.h, // Adjusted for 5 items
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Row(
          children: [
            // 0: Home
            buildNavItem(
              index: 0,
              iconPath: 'assets/images/home.svg',
              label: 'Home',
            ),
            // 1: Services
            buildNavItem(
              index: 1,
              iconPath: 'assets/images/income.svg',
              label: 'Services',
              customTap: () {
                ServicesController sc = Get.put(ServicesController());
                sc.getBanners();
                sc.getServices();
                setState(() {
                  controller.currentIndex.value = 1;
                  tabController.animateTo(1);
                });
              },
            ),
            // 2: TWA (NEW)
            buildNavItem(
              index: 2,
              iconPath: 'assets/images/hiking.svg', // Ensure this asset exists
              label: 'TWA',
              customTap: () {
                setState(() {
                  controller.currentIndex.value = 2;
                  tabController.animateTo(2);
                });
              },
            ),
            // // 3: Activities (NEW)
            // buildNavItem(
            //   index: 3,
            //   iconPath: 'assets/images/activities.svg', // Ensure this asset exists
            //   label: 'Activities',
            //   customTap: () {
            //     if (token.value != 'null') {
            //       setState(() {
            //         controller.currentIndex.value = 3;
            //         tabController.animateTo(3);
            //       });
            //     } else {
            //       showSnackBar(context, 'Login is required'.tr);
            //     }
            //   },
            // ),
            // 4: Messages (Index moved from 2 to 4)
            buildNavItem(
              index: 4,
              iconPath: 'assets/images/send.svg',
              label: 'Messages',
              customTap: () {
                if (!checkLogin(
                  message: Get.locale?.languageCode == 'ar'
                      ? 'قسم الرسائل والمحادثات مخصص للأعضاء.. يرجى تسجيل الدخول للتواصل'
                      : 'Please sign in to view and send messages',
                )) return;
                if (token.value != 'null') {
                  setState(() {
                    controller.currentIndex.value = 3;
                    tabController.animateTo(3);
                  });
                }
              },
            ),

            /* 
            // REAL ESTATE REMOVED/COMMITED
            buildNavItem(
              index: 5,
              iconPath: 'assets/images/real state.svg',
              label: 'Real estate',
            ),
            */
          ],
        ),
      ),
    ));
  }
}