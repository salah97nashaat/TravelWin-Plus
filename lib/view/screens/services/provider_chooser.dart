import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/logic/controllers/service_controller.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/helpers/adv/admob_native.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import '../../widgets/slider/carsoul_slider.dart';

// import 'package:travelwin/models/service_model.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:travelwin/view/screens/services/favorites_page.dart';
import 'package:travelwin/view/screens/services/provider_details.dart';
import 'package:travelwin/view/widgets/services/provider_list_tile.dart';
import 'package:travelwin/view/widgets/services/service_list_tile.dart';

import '../../../utils/my_string.dart';
import 'on_the_map.dart';

class ProviderChooser extends GetView<ProviderController> {
  ProviderChooser({super.key});
  // final ServiceModel service;
  // final ProviderController providersController = Get.find();
  // ServicesController servicesController = Get.find();
  // bool isLoading = false;
  ServicesController get servicesController => Get.find<ServicesController>();
  // late var selectedService = widget.service;
  final appBarBackColor = Colors.white;
  final appBarForeColor1 = mainColor2;
  final appBarForeColor2 = Colors.black;
  // Future getData() async {
  //   await providersController.getProviders();
  // }

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        surfaceTintColor: appBarBackColor,
        backgroundColor: appBarBackColor,
        foregroundColor: appBarForeColor1,
        title: Text(
          "choose_provider".tr,
          style: TextStyle(color: appBarForeColor2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              color: mainColor2,
              onPressed: () {
                Get.to(() => const FavoritesPage());
              },
              icon: const Icon(Icons.favorite_border))
        ],
        // elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45.0),
          child: SizedBox(
              height: 45,
              child: Obx(() => ListView(
                    padding: const EdgeInsets.all(8.0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...servicesController.services.map((e) => GestureDetector(
                            onTap: () {
                              if (controller.isLoading == true) {
                                return;
                              }
                              servicesController.setService(e);
                              // setState(() {
                              //   // selectedService = e;
                              //   getData();
                              // });
                              // getData();
                              // providersController.providers
                              //     .add(ProviderModel(name: "asd"));
                            },
                            child: ServiceListTile(
                              service: e,
                              selected: e.id == servicesController.service.id,
                            ),
                          ))
                    ],
                  ))),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                Expanded(
                    child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  children: [
                    if (servicesController.banners.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: MyCarsoulSlider(
                          items: servicesController.banners,
                          height: 0.16,
                        ),
                      ),
                    const AdmobNativeUi(),
                    ...controller.providers
                        .where(
                            (p) => p.serviceId == servicesController.service.id)
                        .map((e) => GestureDetector(
                              onTap: () {
                                try {
                                  if (Get.isRegistered<AdController>()) {
                                    Get.find<AdController>().showInterstitialAd();
                                  }
                                } catch (_) {}
                                Get.to(() => ProviderDetailsPage(provider: e));
                              },
                              child: ProviderListTile(
                                provider: e,
                              ),
                            )),
                  ],
                ))
              ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor2,
        foregroundColor: Colors.white,
        onPressed: () {
          var providers = controller.providers
              .where((p) => p.serviceId == servicesController.service.id);
          if (providers.isNotEmpty) {
            Get.to(() => OnTheMapPage(service: servicesController.service));
          } else {
            showSnackBar(context, "No service providers to show".tr);
          }
        },
        child: const Icon(Icons.map),
      ),
    );
  }
}
