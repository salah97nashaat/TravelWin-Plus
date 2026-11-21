// import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:travelwin/logic/controllers/area_details_controller.dart';
// import 'package:travelwin/logic/controllers/medicalTourismController.dart';
// import 'package:travelwin/models/Home.dart';
import 'package:travelwin/models/StatesPlaces.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/view/widgets/tourism_place.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
import '../../../routes/routes.dart';
import '../../../utils/my_string.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../../helpers/adv/admob_native.dart';
// import '../../widgets/bookmark_widget.dart';
// import '../../widgets/normalButton.dart';
import '../../widgets/place_text.dart';
import '../../widgets/places_widget.dart';

// class AreaDetails extends StatefulWidget {
//   AreaDetails({Key? key}) : super(key: key);

//   @override
//   State<AreaDetails> createState() => _AreaDetailsState();
// }

// class _AreaDetailsState extends State<AreaDetails> {
//   AreaDetailsController areaDetailsController = AreaDetailsController(
//       selected: Get.locale == Locale('ar')
//           ? Rx(statePlacesForState.value!.placesType!.first.nameAr!)
//           : Rx(statePlacesForState.value!.placesType!.first.nameEn!));
//   bool isLoading = false;
//   int pageCount = 1;
//   StatesPlaces? s;
//   late ScrollController _scrollController;
//   _scrollListener() async {
//     if (_scrollController.offset >=
//             _scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       print("comes to bottom $isLoading");
//       isLoading = true;

//       if (isLoading) {
//         s = await RemoteServices.fetchStateAreaPlaces(
//                 stateid.value,
//                 statePlacesForState.value!
//                     .placesType![areaDetailsController.selectedIndex.value].id,
//                 pageCount + 1)
//             .then((value) {
//           print(value!.statePlaces!.data!.length);
//           statesPlaces.value.statePlaces!.data!
//               .addAll(value.statePlaces!.data!);

//           setState(() {});
//           pageCount = pageCount + 1;
//           return value;
//         });
//       }
//     }
//   }

//   void addItemIntoLisT(var pageCount) {
//     print(statesPlaces.value.statePlaces!.data!.length);
//     isLoading = false;
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _scrollController = new ScrollController()..addListener(_scrollListener);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0.0,
//         leading: Container(),
//         title: Text(
//           Get.locale == Locale('ar')
//               ? home.value!.data!.states![stateId.value].nameAr!
//               : home.value!.data!.states![stateId.value].nameEn!,
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           Padding(
//             padding: Get.locale == Locale('ar')
//                 ? EdgeInsets.only(left: 25.w, top: 5.h)
//                 : EdgeInsets.only(right: 25.w, top: 5.h),
//             child: InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Transform.flip(
//                   flipX: Get.locale == Locale('ar') ? false : true,
//                   child: SvgPicture.asset(
//                     'assets/images/back.svg',
//                     height: 30,
//                   ),
//                 )),
//           ),
//         ],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         controller: _scrollController,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               child: Divider(
//                 color: Colors.grey.withOpacity(0.35),
//                 thickness: 1,
//               ),
//             ),
//             SizedBox(
//               height: 5.h,
//             ),
//             Obx(
//               () => Container(
//                 width: 359,
//                 height: 186,
//                 decoration: ShapeDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(stateImage.value),
//                     fit: BoxFit.fill,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 5.h,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               child: Divider(
//                 color: Colors.grey.withOpacity(0.35),
//                 thickness: 1,
//               ),
//             ),
//             SizedBox(
//               height: 5.h,
//             ),
//             SizedBox(
//                 height: 25.h,
//                 child: Center(
//                   child: ListView.separated(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) => Center(
//                             child: InkWell(
//                                 onTap: () async {
//                                   statesPlaces.value = (await RemoteServices
//                                       .fetchStateAreaPlaces(
//                                           home.value!.data!
//                                               .states![stateId.value].id,
//                                           statePlacesForState
//                                               .value!.placesType![index].id,
//                                           1))!;
//                                   areaDetailsController.changeTheType(
//                                       Get.locale == Locale('ar')
//                                           ? statePlacesForState
//                                               .value!.placesType![index].nameAr!
//                                           : statePlacesForState.value!
//                                               .placesType![index].nameEn!,
//                                       index);
//                                 },
//                                 child: Obx(() => PlacesText(
//                                     name: Get.locale == Locale('ar')
//                                         ? statePlacesForState
//                                             .value!.placesType![index].nameAr!
//                                         : statePlacesForState
//                                             .value!.placesType![index].nameEn!,
//                                     status: Get.locale == Locale('ar')
//                                         ? areaDetailsController.selected ==
//                                             statePlacesForState.value!
//                                                 .placesType![index].nameAr!
//                                         : areaDetailsController.selected ==
//                                             statePlacesForState.value!
//                                                 .placesType![index].nameEn!))),
//                           ),
//                       separatorBuilder: (context, index) => VerticalDivider(
//                             color: Colors.grey,
//                             thickness: 1.2,
//                           ),
//                       itemCount: statePlacesForState.value!.placesType!.length),
//                 )),
//             SizedBox(
//               height: 5.h,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               child: Divider(
//                 color: Colors.grey.withOpacity(0.35),
//                 thickness: 1,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Obx(
//                 () => GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   clipBehavior: Clip.none,
//                   itemCount: statesPlaces.value.statePlaces!.data!.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.73,
//                       crossAxisSpacing: 20,
//                       mainAxisSpacing: 15),
//                   itemBuilder: (context, index) => InkWell(
//                     onTap: () {
//                       statePlaces.value =
//                           statesPlaces.value.statePlaces!.data![index];
//                       print(statePlaces.value.rate);
//                       Get.toNamed(Routes.placeDetails);
//                     },
//                     child: Obx(
//                       () => statesPlaces
//                               .value.statePlaces!.data![index].images!.isEmpty
//                           ? Container()
//                           : PlacesWidget(
//                               image: statesPlaces.value.statePlaces!
//                                       .data![index].images![0].url ??
//                                   '',
//                               name: Get.locale == Locale('ar')
//                                   ? statesPlaces
//                                       .value.statePlaces!.data![index].nameAr!
//                                   : statesPlaces
//                                       .value.statePlaces!.data![index].nameEn!,
//                               space: '41 Km',
//                               rate: statesPlaces.value.statePlaces!.data![index]
//                                           .rate ==
//                                       null
//                                   ? '0'
//                                   : statesPlaces
//                                       .value.statePlaces!.data![index].rate!
//                                       .toString(),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class AreaDetails extends StatefulWidget {
  AreaDetails({Key? key}) : super(key: key);
  @override
  State<AreaDetails> createState() => _AreaDetailsState();
}

class _AreaDetailsState extends State<AreaDetails> {
  // Use a modern approach for localizations
  bool get isAr => Get.locale?.languageCode == 'ar';

  // Existing logic for pagination...
  late ScrollController _scrollController;
  final areaDetailsController =
      Get.put(AreaDetailsController(selected: Rx('')));
  bool isLoading = false;
  int pageCount = 1;
  StatesPlaces? s;
  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("comes to bottom $isLoading");
      isLoading = true;

      if (isLoading) {
        s = await RemoteServices.fetchStateAreaPlaces(
                stateid.value,
                statePlacesForState.value!
                    .placesType![areaDetailsController.selectedIndex.value].id,
                pageCount + 1)
            .then((value) {
          print(value!.statePlaces!.data!.length);
          statesPlaces.value.statePlaces!.data!
              .addAll(value.statePlaces!.data!);

          setState(() {});
          pageCount = pageCount + 1;
          return value;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var currentState = home.value!.data!.states![stateId.value];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(isAr ? currentState.nameAr! : currentState.nameEn!,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp)),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Immersive Header Image
            _buildStateHeader(),

            // 2. Modern Category Pills
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: _buildCategorySelector(),
            ),

            // Native Ad
            const AdmobNativeUi(),

            // 3. Places Grid
            Obx(() {
              if (areaDetailsController.isCategoryLoading.value) {
                return SizedBox(
                  height: 300.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (statesPlaces.value.statePlaces!.data!.isEmpty) {
                return SizedBox(
                  height: 300.h,
                  child:
                      Center(child: Text("No items found in this category".tr)),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: statesPlaces.value.statePlaces!.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Adjust for premium card look
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.w,
                  ),
                  itemBuilder: (context, index) {
                    var place = statesPlaces.value.statePlaces!.data![index];
                    return _buildPlaceCard(
                        place); // Using the card design from previous step
                  },
                ),
              );
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStateHeader() {
    return Container(
      margin: EdgeInsets.all(15.w),
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
        image: DecorationImage(
            image: NetworkImage(stateImage.value), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategorySelector() {
    var types = statePlacesForState.value!.placesType!;
    int? currentStateId = home.value!.data!.states![stateId.value].id;

    return SizedBox(
      height: 45.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: types.length,
        itemBuilder: (context, index) {
          String name = Get.locale?.languageCode == 'ar'
              ? types[index].nameAr!
              : types[index].nameEn!;

          return Obx(() {
            bool isSelected = areaDetailsController.selected.value == name;

            return GestureDetector(
              onTap: () => areaDetailsController.changeTheType(
                  name, index, currentStateId!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  // Use mainColor for active, white/grey for inactive
                  color: isSelected ? mainColor : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: mainColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ]
                      : [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 5)
                        ],
                  border: Border.all(
                    color: isSelected ? mainColor : Colors.grey.shade200,
                  ),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildPlaceCard(dynamic place) {
    return GestureDetector(
      onTap: () {
        statePlaces.value = place;
        Get.toNamed(Routes.placeDetails);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: place.images![0].url!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isAr ? place.nameAr! : place.nameEn!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(place.rate?.toString() ?? "0",
                          style:
                              TextStyle(fontSize: 11.sp, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
