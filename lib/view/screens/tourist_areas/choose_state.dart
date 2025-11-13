import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/view/widgets/upperContainerUi.dart';

import '../../../helpers/adv/admob_banner.dart';
import '../../../logic/controllers/state_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/trip.dart/search_text_state.dart';

class ChooseState extends StatelessWidget {
  final StateController stateController = Get.put(StateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: Center(child: Text('Choose State'.tr)),
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
      bottomNavigationBar: const AdmobBannerUi(),

      body: Column(
        children: [
          UpperContainerUi(
            searchWidget: SearchFormState(),
          ),
          Expanded(
            child: Obx(() {
              if (stateController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (stateController.searchList.isEmpty &&
                  stateController.searchTextController.text.isEmpty) {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: stateController.stateList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          child: ListTile(
                            title: Text(
                              Get.locale.toString() == "en"
                                  ? stateController.stateList[index].name
                                      .toString()
                                  : stateController.stateList[index].nameAr
                                      .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : darkGreyClr2,
                              ),
                            ),
                            onTap: () {
                              Get.toNamed(Routes.ChooseTypeTouristAreasScreen,
                                  arguments: [
                                    {
                                      "id": stateController.stateList[index].id
                                          .toString(),
                                    },
                                  ]);
                            },
                          ));
                    });
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: stateController.searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          child: ListTile(
                            title: Text(
                              Get.locale.toString() == "en"
                                  ? stateController.searchList[index].name
                                      .toString()
                                  : stateController.searchList[index].nameAr
                                      .toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : darkGreyClr2,
                              ),
                            ),
                            onTap: () {
                              Get.toNamed(Routes.ChooseTypeTouristAreasScreen,
                                  arguments: [
                                    {
                                      "id": stateController.searchList[index].id
                                          .toString(),
                                    },
                                  ]);
                            },
                          ));
                    });
              }
            }),
          )
        ],
      ),
    );
  }
}
