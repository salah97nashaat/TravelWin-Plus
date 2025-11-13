import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../../logic/controllers/tourPlace_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/tourplace/tourPlace_tile.dart';
import '../../widgets/trip.dart/search_text_tourplace.dart';
import '../../widgets/upperContainerUi.dart';

class ViewTouristAreaScreen extends StatelessWidget {
  final TourPlaceController tourPlaceController =
      Get.put(TourPlaceController());

  ViewTouristAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: Center(child: Text('Place areas'.tr)),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.mainScreen);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      // const ApplovinBannerUi(),

      backgroundColor:
          Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
      // drawer: MyDrawer(),
      body: Column(
        children: [
          UpperContainerUi(
            searchWidget: SearchFormTourPlace(),
          ),
          Expanded(
            child: Obx(() {
              if (tourPlaceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (tourPlaceController.searchList.isEmpty &&
                    tourPlaceController.searchTextController.text.isEmpty) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: tourPlaceController.tourPlaceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TourPlaceTile(
                            tourPlaceController.tourPlaceList[index]);
                      });
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: tourPlaceController.searchList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TourPlaceTile(
                            tourPlaceController.searchList[index]);
                      });
                }
              }
            }),
          )
        ],
      ),
    );
  }
}
