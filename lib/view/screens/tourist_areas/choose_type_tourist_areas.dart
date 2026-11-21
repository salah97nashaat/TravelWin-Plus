import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../logic/controllers/typeState_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../widgets/trip.dart/search_text_type_tourist.dart';
import '../../widgets/upperContainerUi.dart';

class ChooseTypeTouristAreasScreen extends StatelessWidget {
  final TypeStateController typeStateController =
      Get.put(TypeStateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: Center(child: Text('Type Tourist Areas'.tr)),
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
            searchWidget: SearchFormTypeTourist(),
          ),
          Expanded(
            child: Obx(() {
              if (typeStateController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else if (typeStateController.searchList.isEmpty &&
                  typeStateController.searchTextController.text.isEmpty) {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: typeStateController.typeStateList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          child: ListTile(
                            title: Text(
                                Get.locale.toString() == "en"
                                    ? typeStateController
                                        .typeStateList[index].name
                                        .toString()
                                    : typeStateController
                                        .typeStateList[index].nameAr
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : darkGreyClr2,
                                )),
                            onTap: () {
                              Get.toNamed(Routes.ViewTouristAreaScreen,
                                  arguments: [
                                    {
                                      "stateid": typeStateController
                                          .typeStateList[index].stateid
                                          .toString(),
                                      "typeid": typeStateController
                                          .typeStateList[index].id
                                          .toString(),
                                    },
                                  ]);
                            },
                          ));
                    });
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: typeStateController.searchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          child: ListTile(
                            title: Text(
                                Get.locale.toString() == "en"
                                    ? typeStateController.searchList[index].name
                                        .toString()
                                    : typeStateController
                                        .searchList[index].nameAr
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : darkGreyClr2,
                                )),
                            onTap: () {
                              Get.toNamed(Routes.ViewTouristAreaScreen,
                                  arguments: [
                                    {
                                      "stateid": typeStateController
                                          .searchList[index].stateid
                                          .toString(),
                                      "typeid": typeStateController
                                          .searchList[index].id
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
