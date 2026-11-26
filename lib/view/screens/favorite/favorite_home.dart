import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../../routes/routes.dart';
import '../../widgets/card_ui.dart';

class FavoriteHomeScreen extends StatelessWidget {
  FavoriteHomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottomNavigationBar: const AdmobBannerUi(),

          // const ApplovinBannerUi(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              //
              // shrinkWrap: true,
              children: [
                CardUi(
                  image: 'assets/images/travel.svg',
                  text: 'Trips'.tr,
                  onTap: () {
                    Get.toNamed(Routes.ViewFavoritrTripsScreen);
                  },
                ),
                SizedBox(height: 18.h),
                CardUi(
                  image: 'assets/images/holiday.png',
                  text: 'Tourist areas'.tr,
                  onTap: () {
                    Get.toNamed(Routes.ViewTouristAreaFavoriteScreen);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
