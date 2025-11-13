import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../logic/controllers/main_controller.dart';
import '../../logic/controllers/service_controller.dart';
import '../../routes/routes.dart';
import '../../utils/my_string.dart';
import '../../utils/theme.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    super.key,
  });

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
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Get.height * 0.1,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: [
          Material(
            elevation: 15,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Container(
              height: Get.height * 0.07,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          setState(() {
                            controller.currentIndex.value = 0;
                            tabController.animateTo(0);
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/home.svg',
                              height: 17.h,
                              // color: tabController.index == 0
                              //     ? mainColor
                              //     : Colors.black,
                              colorFilter: ColorFilter.mode(
                                  tabController.index == 0
                                      ? mainColor
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Home'.tr,
                              style: TextStyle(
                                  color: tabController.index == 0
                                      ? mainColor
                                      : Colors.black,
                                  fontSize: 12.w),
                            ),
                            Visibility(
                              visible: tabController.index == 0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: Get.height * 0.006,
                                    width: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (token.value != 'null') {
                            ServicesController sc =
                                Get.put(ServicesController());
                            sc.getBanners();
                            sc.getServices();
                            setState(() {
                              controller.currentIndex.value = 1;
                              tabController.animateTo(1);
                            });
                          } else {
                            showSnackBar(context, 'Login is required'.tr);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/income.svg',
                              // width: 19.w,
                              height: 17.h,
                              // color: tabController.index == 1
                              //     ? mainColor
                              //     : Colors.black,
                              colorFilter: ColorFilter.mode(
                                  tabController.index == 1
                                      ? mainColor
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Services'.tr,
                              style: TextStyle(
                                  color: tabController.index == 1
                                      ? mainColor
                                      : Colors.black,
                                  fontSize: 12.w),
                            ),
                            Visibility(
                              visible: tabController.index == 1,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: Get.height * 0.006,
                                    width: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  // Spacer(
                  //   flex: 3,
                  // ),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          setState(() {
                            controller.currentIndex.value = 2;
                            tabController.animateTo(2);
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/send.svg',
                              // width: 25.w,
                              // width: 19.w,
                              height: 17.h,
                              // color: tabController.index == 2
                              //     ? mainColor
                              //     : Colors.black,
                              colorFilter: ColorFilter.mode(
                                  tabController.index == 2
                                      ? mainColor
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Messages'.tr,
                              style: TextStyle(
                                  color: tabController.index == 2
                                      ? mainColor
                                      : Colors.black,
                                  fontSize: 12.w),
                            ),
                            Visibility(
                              visible: tabController.index == 2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: Get.height * 0.006,
                                    width: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          setState(() {
                            controller.currentIndex.value = 3;
                            tabController.animateTo(3);
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/real state.svg',
                              // width: 25.w,
                              // width: 19.w,
                              height: 17.h,
                              // color: tabController.index == 3
                              //     ? mainColor
                              //     : Colors.black,
                              colorFilter: ColorFilter.mode(
                                  tabController.index == 3
                                      ? mainColor
                                      : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Real estate'.tr,
                              style: TextStyle(
                                  color: tabController.index == 3
                                      ? mainColor
                                      : Colors.black,
                                  fontSize: 12.w),
                            ),
                            Visibility(
                              visible: tabController.index == 3,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: Get.height * 0.006,
                                    width: Get.width * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          // Positioned(
          //   top: -5,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Material(
          //         elevation: 5,
          //         borderRadius: BorderRadius.circular(50),
          //         child: CircleAvatar(
          //           radius: 33.w,
          //           backgroundColor: Colors.white,
          //           child: FloatingActionButton(
          //             heroTag: "tickets",
          //             shape: CircleBorder(),
          //             onPressed: () {
          //               if (token.value != 'null') {
          //                 Get.toNamed(Routes.ViewTicketScreen);
          //               } else {
          //                 showSnackBar(context, 'Login is required'.tr);
          //               }
          //             },
          //             backgroundColor: mainColor,
          //             child: SvgPicture.asset(
          //               'assets/images/tickets.svg',
          //               width: 35.w,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class ConvexAppBarStyle extends StyleHook {
  @override
  double get activeIconSize => 10;

  @override
  double get activeIconMargin => 5;

  @override
  double get iconSize => 40;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      color: Colors.black,
    );
  }
}
