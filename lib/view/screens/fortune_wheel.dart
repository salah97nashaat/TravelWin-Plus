import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controllers/wheel_controller.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelScreen extends StatefulWidget {
  FortuneWheelScreen({Key? key}) : super(key: key) {}

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  final WheelController wheelController = Get.put(WheelController());

  // final selected = BehaviorSubject<int>();
  int rewards = 0;
  void onApplePayResult(paymentResult) {
    // Send the resulting Apple Pay token to your server / PSP
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
  }

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
    final WheelController wheelController = Get.put(WheelController());

    // final selected = BehaviorSubject<int>();
    int rewards = 0;

    List colorsr = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent
    ];

    // Random random = new Random();
    //
    // int index = 0;
    // const _paymentItems = [
    //   PaymentItem(
    //     label: 'Total',
    //     amount: '99.99',
    //     status: PaymentItemStatus.final_price,
    //   )
    // ];

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   color: Colors.black,
              //   child: GooglePayButton(
              //     width: 500,
              //     paymentConfigurationAsset: 'gpay.json',
              //     paymentItems: _paymentItems,
              //     onPressed: () {
              //       print('object');
              //     },
              //     onError: (error) {
              //       print(error);
              //     },
              //     type: GooglePayButtonType.pay,
              //     margin: const EdgeInsets.only(top: 15.0),
              //     onPaymentResult: onGooglePayResult,
              //     loadingIndicator: const Center(
              //       child: Text('data'),
              //     ),
              //   ),
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       // Navigator.push(context,
              //       //     MaterialPageRoute(builder: (BuildContext context) {
              //       //   return MyApp();
              //       // }));
              //     },
              //     child: Container(
              //       width: 150,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             '0.99\$',
              //             style: TextStyle(
              //                 fontSize: 17, fontWeight: FontWeight.bold),
              //           ),
              //           Text(
              //             'VIP',
              //             style: TextStyle(
              //                 fontSize: 17, fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //             // side: BorderSide(width: 1.0, color: Colors.black),
              //             borderRadius: BorderRadius.circular(3)),
              //         minimumSize: const Size(250, 50),
              //         primary: Get.isDarkMode ? darkGreyClr : mainColor)),
              SizedBox(
                height: 300,
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
              SizedBox(
                height: 35,
              )
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
