import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/logic/controllers/service_controller.dart';
// import 'package:travelwin/models/banner_model.dart';
import 'package:travelwin/models/service_model.dart';
import 'package:travelwin/routes/routes.dart';
// import 'package:travelwin/view/screens/services/provider_chooser.dart';
import 'package:travelwin/view/screens/services/state_chooser.dart';
import 'package:travelwin/view/widgets/slider/carsoul_slider.dart';

import '../../../logic/controllers/service_state_controller.dart';
import '../../../logic/controllers/adController.dart';
import '../../../helpers/adv/admob_native.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../widgets/services/service_grid_tile.dart';
import 'add_provider_page.dart';
// import 'language_chooser.dart';

// class ServiceChooser extends GetView<ServicesController> {
//   const ServiceChooser({super.key});

//   // ServicesController controller = Get.put(ServicesController());
//   // var providersController = Get.put(ProviderController());
//   // List<BannerModel> banners = [];
//   // bool isLoading = false;
//   // Future getData() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   await controller.getServices();
//   //   banners = await controller.getBanners();
//   //   setState(() {
//   //     isLoading = false;
//   //   });
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   getData();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: controller.getData,
//       child: Scaffold(
//         // backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: mainColor3, //inversePrimaryColor2,
//           foregroundColor: colorScheme2.onPrimary,
//           title: Text(
//             "choose_service".tr,
//           ),
//           // elevation: 4,
//           centerTitle: true,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   Get.dialog(AlertDialog(
//                     content: Column(mainAxisSize: MainAxisSize.min, children: [
//                       ListTile(
//                         title: Text("change_state".tr),
//                         onTap: () async {
//                           // Get.back();
//                           await Get.to(
//                               () => StateChooser(
//                                     onStateChoosen: (e) {
//                                       // state = e;
//                                       controller.getServices();
//                                       Get.back();
//                                     },
//                                   ),
//                               binding: BindingsBuilder.put(
//                                   () => ServiceStateController()));
//                           Get.back();
//                         },
//                       ),
//                       ListTile(
//                         title: Text("add_service".tr),
//                         onTap: () {
//                           Get.back();
//                           Get.to(() => const AddProviderPage(),
//                               arguments: {'from': 'ServiceChooserSettings'});
//                         },
//                       )
//                     ]),
//                   ));
//                 },
//                 icon: const Icon(Icons.more_horiz))
//           ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(kTextTabBarHeight),
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                       prefixIcon: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.0),
//                         child: Icon(Icons.search),
//                       ),
//                       prefixIconConstraints:
//                           BoxConstraints(minHeight: 0, minWidth: 0),
//                       isDense: true,
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: InputBorder.none),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         body: Obx(
//           () => controller.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//                   children: [
//                     const SizedBox(height: 16.0),
//                     CarouselSlider(
//                       items: controller.banners
//                           .map((e) => CarouselCard(imageUrl: e.imageUrl))
//                           .toList(),
//                       options:
//                           CarouselOptions(height: 150, viewportFraction: 1.0),
//                     ),
//                     const SizedBox(height: 4.0),
//                     Expanded(
//                       child: controller.services.isEmpty
//                           ? Center(child: Icon(Icons.block_rounded))
//                           : GridView(
//                               padding: const EdgeInsets.all(16.0),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 4,
//                                       childAspectRatio: 0.61,
//                                       crossAxisSpacing: 12,
//                                       mainAxisSpacing: 12),
//                               children: [
//                                 ...controller.services
//                                     .map((e) => GestureDetector(
//                                           onTap: () {
//                                             goToProviders(e);
//                                           },
//                                           child: ServiceGridTile(
//                                             model: e,
//                                           ),
//                                         ))
//                               ],
//                             ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
class ServiceChooser extends GetView<ServicesController> {
  const ServiceChooser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      backgroundColor: const Color(0xFFF8F9FD), // Soft background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "choose_service".tr,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            onPressed: () => _showServiceOptions(),
            icon: const Icon(Icons.tune_rounded,
                color: Colors.black), // More modern icon
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.getData,
        child: Obx(() => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // 1. Modern Carousel
                  if (controller.banners.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: MyCarsoulSlider(
                          items: controller.banners,
                          height: 0.16,
                        ),
                      ),
                    ),
                  // Native Ad in Services
                  const SliverToBoxAdapter(
                    child: AdmobNativeUi(),
                  ),
                  // 2. Service Grid
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: controller.services.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                                child: Icon(Icons.inventory_2_outlined,
                                    size: 50, color: Colors.grey)))
                        : SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 15.h,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var service = controller.services[index];
                                return GestureDetector(
                                  onTap: () => goToProviders(service),
                                  child: ServiceGridTile(model: service),
                                );
                              },
                              childCount: controller.services.length,
                            ),
                          ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              )),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "search service".tr,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  void goToProviders(ServiceModel service) {
    controller.setService(service);
    try {
      if (Get.isRegistered<AdController>()) {
        Get.find<AdController>().showInterstitialAd();
      }
    } catch (_) {}
    Get.toNamed(Routes.providerChooser);
  }

  void _showServiceOptions() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.blue),
          title: Text("change_state".tr),
          onTap: () async {
            Get.back(); // Close dialog
            await Get.to(
                () => StateChooser(
                      onStateChoosen: (e) {
                        controller.getServices();
                        Get.back();
                      },
                    ),
                binding: BindingsBuilder.put(() => ServiceStateController()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_business_outlined, color: Colors.green),
          title: Text("add_service".tr),
          onTap: () {
            Get.back(); // Close dialog
            Get.to(() => const AddProviderPage(),
                arguments: {'from': 'ServiceChooserSettings'});
          },
        )
      ]),
    ));
  }
}
