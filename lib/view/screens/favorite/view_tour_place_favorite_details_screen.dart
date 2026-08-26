import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get/instance_manager.dart';
import 'package:share_plus/share_plus.dart';

import '../../../logic/controllers/TourPlace_details_favorite_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/text_utils.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:map_launcher/map_launcher.dart';

class ViewTourPlaceFavoriteDetailsScreen extends StatelessWidget {
  final TourPlaceDetailsFavoriteController tourPlaceDetailsFavoriteController =
      Get.put(TourPlaceDetailsFavoriteController());
  // final Uri _url = Uri.parse('https://flutter.dev');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
            elevation: 0,
            title: Center(child: Text('Details Tour Place'.tr)),
            actions: [
              IconButton(
                  onPressed: () {
                    tourPlaceDetailsFavoriteController.DeleteFavoriteTrip(
                        tourPlaceDetailsFavoriteController.favorites_id.value);
                    // Get.offAllNamed(Routes.mainScreen);
                    Get.back();
                  },
                  icon: SvgPicture.asset(
                    'assets/images/remove-favorites.svg',
                    // color: Colors.red,
                    colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  )),
              IconButton(
                onPressed: () {
                  Get.offAllNamed(Routes.mainScreen);
                },
                icon: Icon(Icons.home),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                tourPlaceDetailsFavoriteController.AddReqPoint(
                    tourPlaceDetailsFavoriteController.id.value.toString());

                Share.share('https://travelwin1.com/place/share?id_post=' +
                    tourPlaceDetailsFavoriteController.id.value.toString() +
                    '&id_user=' +
                    tourPlaceDetailsFavoriteController.displayUserId.value
                        .toString());
              },
              icon: Icon(Icons.share),
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            Obx(() {
              if (tourPlaceDetailsFavoriteController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
                //   return Container(
                //     color:
                //         Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
                // //    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                //     child: CarouselSlider(
                //       options: CarouselOptions(height: 250.0),
                //       items:
                //           tourPlaceDetailsFavoriteController.sliderList.map((i) {
                //         return Builder(
                //           builder: (BuildContext context) {
                //             return GestureDetector(
                //               onTap: () {
                //                 print("Container clicked");
                //               },
                //               // child: Container(
                //               //   width: MediaQuery.of(context).size.width,
                //               //   margin: EdgeInsets.symmetric(horizontal: 5.0),
                //               //   decoration: BoxDecoration(
                //               //       color:
                //               //           Get.isDarkMode ? darkGreyClr : litmain),
                //               //   child:
                //               //       // PhotoView(
                //               //       //   imageProvider: NetworkImage('$i'),
                //               //       //   backgroundDecoration: BoxDecoration(color: Colors.white),
                //               //       // ),
                //               //       Image.network('$i'),
                //               //
                //               //   //Text('text $i' , style: TextStyle(fontSize: 16.0),)
                //               // ),
                //               child: Container(
                //                   width: MediaQuery
                //                       .of(context)
                //                       .size
                //                       .width,
                //                   child: Text(
                //                     (tourPlaceDetailsFavoriteController.sliderList
                //                         .indexOf(i)+1)
                //                         .toString()+"/"+tourPlaceDetailsFavoriteController.sliderList.length.toString(),
                //                     style: TextStyle(fontSize: 18.0,color: Colors.orange),
                //                   ),
                //                   decoration: BoxDecoration(
                //                       image: DecorationImage(
                //                           image: NetworkImage('$i',),
                //                           fit: BoxFit.contain)
                //                   )
                //
                //
                //               ),
                //             );
                //           },
                //         );
                //       }).toList(),
                //     ),
                //   );
                return Container(
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
                        items: tourPlaceDetailsFavoriteController.sliderList
                            .map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  print("Container clicked");
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    //  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    //   decoration: BoxDecoration(
                                    //     // color:
                                    //     //     Get.isDarkMode ? darkGreyClr : litmain
                                    //   ),

                                    child: Text(
                                      (tourPlaceDetailsFavoriteController
                                                      .sliderList
                                                      .indexOf(i) +
                                                  1)
                                              .toString() +
                                          "/" +
                                          tourPlaceDetailsFavoriteController
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
                              ? tourPlaceDetailsFavoriteController.name
                                  .toString()
                              : tourPlaceDetailsFavoriteController.name_ar
                                  .toString()),
                        ],
                      ))),
                  Text('Tourist area Details'.tr),
                  Obx(() => Container(
                        width: (MediaQuery.of(context).size.width) - 100,
                        child: Text(Get.locale.toString() == "en"
                            ? tourPlaceDetailsFavoriteController.notes
                                .toString()
                            : tourPlaceDetailsFavoriteController.notes_ar
                                .toString()),
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
                      // MapLauncher.showMarker(
                      //     mapType: MapType.google,
                      //     coords: Coords(
                      //         double.parse(tourPlaceDetailsFavoriteController
                      //             .lat.value
                      //             .toString()),
                      //         double.parse(tourPlaceDetailsFavoriteController
                      //             .longitude.value
                      //             .toString())),
                      //     title: tourPlaceDetailsFavoriteController
                      //         .name_ar.value
                      //         .toString());

                      // String lat = tourPlaceDetailsFavoriteController.lat.value
                      //     .toString();
                      // String lng = tourPlaceDetailsFavoriteController
                      //     .longitude.value
                      //     .toString();
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
            // Padding(padding: EdgeInsets.all(15)),
          ],
        ));
  }

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }
}
