import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../logic/controllers/wheel_controller.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelScreenVIP extends StatefulWidget {
  FortuneWheelScreenVIP({Key? key}) : super(key: key) {}

  @override
  State<FortuneWheelScreenVIP> createState() => _FortuneWheelScreenVIPState();
}

class _FortuneWheelScreenVIPState extends State<FortuneWheelScreenVIP> {
  final WheelController wheelController = Get.put(WheelController());

  // final selected = BehaviorSubject<int>();
  int rewards = 0;

  List colorsr = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent
  ];

  Random random = new Random();

  int index = 0;

  // List<int> items = [100, 200, 500, 1000, 2000];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          elevation: 0,
          title: Center(child: Text('wheel of luck'.tr)),
          actions: [
            IconButton(
              onPressed: () {
                Get.offAllNamed(Routes.mainScreen);
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300.h,
                child: FortuneWheel(
                  selected: wheelController.selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0;
                        i < wheelController.items.length;
                        i++) ...<FortuneItem>{
                      FortuneItem(
                          style: FortuneItemStyle(
                            color: colorsr[
                                i], // <-- custom circle slice fill color
                            borderColor: Colors
                                .black, // <-- custom circle slice stroke color
                            borderWidth:
                                3, // <-- custom circle slice stroke width
                          ),
                          child: Text(
                            wheelController.items[i].toString(),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                    },
                  ],
                  onAnimationEnd: () {
                    rewards =
                        wheelController.items[wheelController.selected.value];
                    // setState(() {
                    //   rewards = items[selected.value];
                    // });
                    wheelController.check_wheel(rewards.toString());
                    // print(rewards);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //         "You just won " + rewards.toString() + " Points!"),
                    //   ),
                    // );
                  },
                ),
              ),

              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       selected.add(Fortune.randomInt(0, items.length));
              //     });
              //   },
              //   child: Container(
              //     height: 40,
              //     width: 120,
              //     color: Colors.redAccent,
              //     child: Center(
              //       child: Text("SPIN"),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
