import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/tourPlace_favorite_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/tourplace/tourPlace_favorite_tile.dart';

class ViewTouristAreaFavoriteScreen extends StatelessWidget {
  final TourPlaceFavoriteController tourPlaceFavoriteController =
      Get.put(TourPlaceFavoriteController());

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

      backgroundColor:
          Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
      // drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (tourPlaceFavoriteController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: tourPlaceFavoriteController.tourPlaceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TourPlacefavoriteTile(
                          tourPlaceFavoriteController.tourPlaceList[index]);
                    });
              }
            }),
          )
        ],
      ),
    );
  }
}
