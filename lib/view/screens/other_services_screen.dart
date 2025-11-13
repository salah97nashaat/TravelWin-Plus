import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/helpers/helper.dart';
import '../../../routes/routes.dart';
import '../../logic/controllers/about_controller.dart';
import '../widgets/card_ui.dart';

class OtherServicesScreen extends StatelessWidget {
  OtherServicesScreen({Key? key}) : super(key: key);
  final AboutController aboutController = Get.put(AboutController());
  final String eczanelerUrl = 'https://www.eczaneler.gen.tr/';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(children: [
        // const Padding(padding: EdgeInsets.all(20)),
        // const AdmobBannerUi(),
        // const ApplovinBannerUi(),
        SizedBox(
          height: 30.h,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CardUi(
                  image: 'assets/images/travel.svg',
                  text: 'Trips'.tr,
                  onTap: () {
                    Get.toNamed(Routes.ViewTripsScreen);
                  },
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Expanded(
                child: CardUi(
                  image: 'assets/images/pharmacy.svg',
                  text: 'Duty pharmacy'.tr,
                  onTap: () {
                    launchURL(eczanelerUrl);
                  },
                ),
              ),
            ],
          ),
        ),

        const Padding(padding: EdgeInsets.all(20)),
      ]),
    ));
  }
}
