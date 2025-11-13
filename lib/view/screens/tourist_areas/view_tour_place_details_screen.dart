import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:travelwin/helpers/adv/admob_banner.dart';
import '../../../helpers/helper.dart';
import '../../../logic/controllers/sliderTourPlace_controller.dart';
import '../../../utils/theme.dart';
import '../../widgets/text_utils.dart';
import 'package:map_launcher/map_launcher.dart';

class ViewTourPlaceDetailsScreen extends StatelessWidget {
  final SliderTourPlaceController sliderTourPlaceController =
      Get.put(SliderTourPlaceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          elevation: 0,
          title: Center(child: Text('Details Place'.tr)),
          actions: [
            Obx(() => sliderTourPlaceController.isLoadingFavorite.isTrue
                ? Text('')
                : sliderTourPlaceController.favorite.value.toString() != 'no'
                    ? IconButton(
                        onPressed: () {
                          sliderTourPlaceController.DeleteFavoriteTrip(
                              sliderTourPlaceController.favorite.value
                                  .toString());
                          sliderTourPlaceController.change_favorite('no');
                        },
                        icon: SvgPicture.asset(
                          'assets/images/remove-favorites.svg',
                          // color: Colors.red,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.srcIn),
                        ))
                    : IconButton(
                        onPressed: () {
                          sliderTourPlaceController.AddFavorite(
                              id: sliderTourPlaceController.id.value);
                          sliderTourPlaceController.change_favorite(
                              sliderTourPlaceController.favorite.value
                                  .toString());
                        },
                        icon: SvgPicture.asset(
                          'assets/images/add-favoritess.svg',
                          // color: Colors.white,
                          colorFilter:
                              ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ))),
            IconButton(
              onPressed: () {
                sliderTourPlaceController.AddReqPoint(
                    sliderTourPlaceController.id.value.toString());
                Share.share('https://travelwin1.com/place/share?id_post=' +
                    sliderTourPlaceController.id.value.toString() +
                    '&id_user=' +
                    sliderTourPlaceController.displayUserId.value.toString());
                //  Get.offAllNamed(Routes.mainScreen);
              },
              icon: Icon(Icons.share),
            )
          ],
          leading: IconButton(
            onPressed: () {
              //Get.offAllNamed(Routes.mainScreen);
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            const AdmobBannerUi(),
            Obx(() {
              if (sliderTourPlaceController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                // return Container(
                //   color:
                //   Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
                // //  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                //   child: CarouselSlider(
                //     options: CarouselOptions(height: 250.0,
                //
                //     ),
                //     items: sliderTourPlaceController.sliderList.map((i) {
                //       return Builder(
                //         builder: (BuildContext context) {
                //           return GestureDetector(
                //             onTap: () {
                //               print("Container clicked");
                //             },
                //             child: Container(
                //                 width: MediaQuery
                //                     .of(context)
                //                     .size
                //                     .width,
                //                 child: Text(
                //                   (sliderTourPlaceController.sliderList
                //                       .indexOf(i)+1)
                //                       .toString()+"/"+sliderTourPlaceController.sliderList.length.toString(),
                //                   style: TextStyle(fontSize: 18.0,color: Colors.orange),
                //                 ),
                //                 decoration: BoxDecoration(
                //                     image: DecorationImage(
                //                         image: NetworkImage('$i',),
                //                         fit: BoxFit.contain)
                //                 )
                //
                //
                //             ),
                //           );
                //         },
                //       );
                //     }).toList(),
                //   ),
                // );
                return SizedBox(
                  // margin: const EdgeInsets.fromLTRB(0,20, 0, 0),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(15)),
                      CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {}),
                        items: sliderTourPlaceController.sliderList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  print("Container clicked");
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      (sliderTourPlaceController.sliderList
                                                      .indexOf(i) +
                                                  1)
                                              .toString() +
                                          "/" +
                                          sliderTourPlaceController
                                              .sliderList.length
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.orange),
                                    ),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              '$i',
                                            ),
                                            fit: BoxFit.contain))),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }

              //-----------------------------
            }),
            Padding(padding: EdgeInsets.all(15)),
            Container(
              margin: EdgeInsets.all(20),
              color: Get.isDarkMode ? darkGreyClr : litmain,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.all(20),
                    color: Get.isDarkMode ? darkGreyClr2 : mainColor,
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        "Tourist area information".tr,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
                  ),
                  Obx(() => ListTile(
                          title: Row(
                        children: [
                          Text('Name'.tr),
                          Text(' : '),
                          Text(Get.locale.toString() == "en"
                              ? sliderTourPlaceController.name.toString()
                              : sliderTourPlaceController.name_ar.toString()),
                        ],
                      ))),
                  Text('Tourist area Details'.tr),
                  Obx(() => Container(
                        width: (MediaQuery.of(context).size.width) - 100,
                        child: Text(Get.locale.toString() == "en"
                            ? sliderTourPlaceController.notes.toString()
                            : sliderTourPlaceController.notes_ar.toString()),
                      )),
                  Padding(padding: EdgeInsets.all(20)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Get.isDarkMode ? darkGreyClr2 : mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        )),
                    onPressed: () async {
                      if (showLoginScreenIfNotLogin) {
                        return;
                      }
                      // if (await showMessageIfGust(context)) {
                      //   return ;
                      // }

                      final availableMaps = await MapLauncher.installedMaps;
                      print(
                          availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                      await availableMaps.first.showMarker(
                          coords: Coords(
                              double.parse(sliderTourPlaceController.lat.value
                                  .toString()),
                              double.parse(sliderTourPlaceController
                                  .longitude.value
                                  .toString())),
                          title: sliderTourPlaceController.name_ar.value
                              .toString());

                      // MapLauncher.showMarker(
                      //     mapType: MapType.google,
                      //     coords: Coords(
                      //         double.parse(sliderTourPlaceController.lat.value
                      //             .toString()),
                      //         double.parse(sliderTourPlaceController
                      //             .longitude.value
                      //             .toString())),
                      //     title: sliderTourPlaceController.name_ar.value
                      //         .toString());

                      // String lat =
                      //     sliderTourPlaceController.lat.value.toString();
                      // String lng =
                      //     sliderTourPlaceController.longitude.value.toString();
                      // ;
                      // String mapUrl = "geo:$lat,$lng";
                      // if (await canLaunch(mapUrl)) {
                      //   await launch(mapUrl);
                      // } else {
                      //   throw "Couldn't launch Map";
                      // }
                    },
                    child: TextUtils(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      text: 'Location'.tr,
                      color: Colors.white,
                      underLine: TextDecoration.none,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(15)),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(15)),
          ],
        ));
    // ListView(
    //   children: [
    //
    //     Obx(() {
    //       if (sliderTourPlaceController.isLoading.value)
    //         return Center(child: CircularProgressIndicator());
    //       else {
    //         return Container(
    //           color:
    //               Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
    //           margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    //           child: CarouselSlider(
    //             options: CarouselOptions(height: 250.0),
    //             items: sliderTourPlaceController.sliderList.map((i) {
    //               return Builder(
    //                 builder: (BuildContext context) {
    //                   return GestureDetector(
    //                     onTap: () {
    //                       print("Container clicked");
    //                     },
    //                     child: Container(
    //                       width: MediaQuery.of(context).size.width,
    //                       margin: EdgeInsets.symmetric(horizontal: 5.0),
    //                       decoration: BoxDecoration(
    //                           color:
    //                               Get.isDarkMode ? darkGreyClr : litmain),
    //                       child:
    //                           // PhotoView(
    //                           //   imageProvider: NetworkImage('$i'),
    //                           //   backgroundDecoration: BoxDecoration(color: Colors.white),
    //                           // ),
    //                           Image.network('$i'),
    //
    //                       //Text('text $i' , style: TextStyle(fontSize: 16.0),)
    //                     ),
    //                   );
    //                 },
    //               );
    //             }).toList(),
    //           ),
    //         );
    //       }
    //
    //       //-----------------------------
    //     }),
    //     Padding(padding: EdgeInsets.all(15)),
    //     Container(
    //       margin: EdgeInsets.all(20),
    //       color: Get.isDarkMode ? darkGreyClr : litmain,
    //       child: Column(
    //         children: [
    //           Container(
    //             margin: EdgeInsetsDirectional.all(40),
    //             color: Get.isDarkMode ? darkGreyClr2 : mainColor,
    //             child: Center(
    //                 child: Text(
    //               "Tourist area information".tr,
    //               style: TextStyle(color: Colors.white, fontSize: 20),
    //             )),
    //           ),
    //           Obx(() => ListTile(
    //                   title: Row(
    //                 children: [
    //                   Text('Name'.tr),
    //                   Text(' : '),
    //                   Text(Get.locale.toString() == "en"
    //                       ? sliderTourPlaceController.name.toString()
    //                       : sliderTourPlaceController.name_ar.toString()),
    //                 ],
    //               ))),
    //           Text('Tourist area Details'.tr),
    //           Obx(() => Container(
    //                 width: (MediaQuery.of(context).size.width) - 100,
    //                 child: Text(Get.locale.toString() == "en"
    //                     ? sliderTourPlaceController.notes.toString()
    //                     : sliderTourPlaceController.notes_ar.toString()),
    //               )),
    //           Padding(padding: EdgeInsets.all(20)),
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //                 backgroundColor:
    //                     Get.isDarkMode ? darkGreyClr2 : mainColor,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 40,
    //                   vertical: 12,
    //                 )),
    //             onPressed: () async {
    //               MapLauncher.showMarker(mapType: MapType.google, coords: Coords( double.parse(sliderTourPlaceController.lat.value.toString()),  double.parse(sliderTourPlaceController.longitude.value.toString())), title: sliderTourPlaceController.name_ar.value.toString());
    //               // String lat =
    //               //     sliderTourPlaceController.lat.value.toString();
    //               // String lng =
    //               //     sliderTourPlaceController.longitude.value.toString();
    //               // ;
    //               // String mapUrl = "geo:$lat,$lng";
    //               // if (await canLaunch(mapUrl)) {
    //               //   await launch(mapUrl);
    //               // } else {
    //               //   throw "Couldn't launch Map";
    //               // }
    //             },
    //             child: TextUtils(
    //               fontSize: 22,
    //               fontWeight: FontWeight.bold,
    //               text: 'Location'.tr,
    //               color: Colors.white,
    //               underLine: TextDecoration.none,
    //             ),
    //           ),
    //           const Padding(padding: EdgeInsets.all(15)),
    //         ],
    //       ),
    //     ),
    //     Padding(padding: EdgeInsets.all(15)),
    //     // Padding(padding: EdgeInsets.all(15)),
    //   ],
    // ));
  }
}
