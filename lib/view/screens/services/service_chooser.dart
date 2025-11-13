import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
// import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/logic/controllers/service_controller.dart';
// import 'package:travelwin/models/banner_model.dart';
import 'package:travelwin/models/service_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/constants.dart';
// import 'package:travelwin/view/screens/services/provider_chooser.dart';
import 'package:travelwin/view/screens/services/state_chooser.dart';
import 'package:travelwin/view/widgets/services/carousel_card.dart';

import '../../../logic/controllers/service_state_controller.dart';
import '../../widgets/services/service_grid_tile.dart';
import 'add_provider_page.dart';
// import 'language_chooser.dart';

class ServiceChooser extends GetView<ServicesController> {
  const ServiceChooser({super.key});

  // ServicesController controller = Get.put(ServicesController());
  // var providersController = Get.put(ProviderController());
  // List<BannerModel> banners = [];
  // bool isLoading = false;
  // Future getData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await controller.getServices();
  //   banners = await controller.getBanners();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.getData,
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor3, //inversePrimaryColor2,
          foregroundColor: colorScheme2.onPrimary,
          title: Text(
            "choose_service".tr,
          ),
          // elevation: 4,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                        title: Text("change_state".tr),
                        onTap: () async {
                          // Get.back();
                          await Get.to(
                              () => StateChooser(
                                    onStateChoosen: (e) {
                                      // state = e;
                                      controller.getServices();
                                      Get.back();
                                    },
                                  ),
                              binding: BindingsBuilder.put(
                                  () => ServiceStateController()));
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: Text("add_service".tr),
                        onTap: () {
                          Get.back();
                          Get.to(() => const AddProviderPage(),
                              arguments: {'from': 'ServiceChooserSettings'});
                        },
                      )
                    ]),
                  ));
                },
                icon: const Icon(Icons.more_horiz))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(Icons.search),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minHeight: 0, minWidth: 0),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Obx(
          () => controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 16.0),
                    CarouselSlider(
                      items: controller.banners
                          .map((e) => CarouselCard(imageUrl: e.imageUrl))
                          .toList(),
                      options:
                          CarouselOptions(height: 150, viewportFraction: 1.0),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: controller.services.isEmpty
                          ? Center(child: Icon(Icons.block_rounded))
                          : GridView(
                              padding: const EdgeInsets.all(16.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.61,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12),
                              children: [
                                ...controller.services
                                    .map((e) => GestureDetector(
                                          onTap: () {
                                            goToProviders(e);
                                          },
                                          child: ServiceGridTile(
                                            model: e,
                                          ),
                                        ))
                              ],
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void goToProviders(ServiceModel service) {
    controller.setService(service);
    Get.toNamed(Routes.providerChooser);
  }
}
