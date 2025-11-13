import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../logic/controllers/tripe_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/trip.dart/trip_favorite_tile.dart';

class ViewFavoritrTripsScreen extends StatelessWidget {
  final TripeController tripeController = Get.put(TripeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: const Text('Tour Programs'),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.mainScreen);
            },
            icon: Icon(Icons.home),
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
              if (tripeController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: tripeController.favortestripList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TripFavoriteTile(
                          tripeController.favortestripList[index]);
                    });
            }),
          )
        ],
      ),
    );
  }
}
