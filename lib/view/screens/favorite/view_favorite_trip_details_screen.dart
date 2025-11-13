import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/helper.dart';
import '../../../logic/controllers/tripe_favorite_details_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/text_utils.dart';

class ViewFavoriteTripsDetailsScreen extends StatefulWidget {
  @override
  State<ViewFavoriteTripsDetailsScreen> createState() =>
      _ViewFavoriteTripsDetailsScreenState();
}

class _ViewFavoriteTripsDetailsScreenState
    extends State<ViewFavoriteTripsDetailsScreen> {
  final TripFavoriteDetailsController tripFavoriteDetailsController =
      Get.put(TripFavoriteDetailsController());

  String urlTrip = 'https://travelwin1.com/trip/slider?id_post=';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
            elevation: 0,
            title: Center(child: Text('Trip Info'.tr)),
            actions: [
              IconButton(
                  onPressed: () {
                    tripFavoriteDetailsController.DeleteFavoriteTrip(
                        tripFavoriteDetailsController.favorites_id.value);
                    sleep(Duration(seconds: 1));
                    Get.back();
                    // Get.offAllNamed(Routes.mainScreen);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/remove-favorites.svg',
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
                tripFavoriteDetailsController.AddReqPoint(
                    tripFavoriteDetailsController.id.value.toString());

                Share.share('https://travelwin1.com/trip/slider?id_post=' +
                    tripFavoriteDetailsController.id.value.toString() +
                    '&id_user=' +
                    tripFavoriteDetailsController.displayUserId.value
                        .toString());
              },
              icon: Icon(Icons.share),
            )),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        body: ListView(
          children: [
            Obx(() {
              if (tripFavoriteDetailsController.isLoading.value)
                return Center(child: CircularProgressIndicator());
              else {
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
                        items:
                            tripFavoriteDetailsController.sliderList.map((i) {
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
                                      (tripFavoriteDetailsController.sliderList
                                                      .indexOf(i) +
                                                  1)
                                              .toString() +
                                          "/" +
                                          tripFavoriteDetailsController
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
                        "Flight information".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                  ),
                  Obx(() => ListTile(
                          title: Row(
                        children: [
                          Text('from'.tr),
                          Text(' : '),
                          Text(Get.locale.toString() == "en"
                              ? tripFavoriteDetailsController.from.toString()
                              : tripFavoriteDetailsController.from_ar
                                  .toString()),
                        ],
                      ))),
                  Obx(() => ListTile(
                          title: Row(
                        children: [
                          Text('To'.tr),
                          Text(' : '),
                          Text(Get.locale.toString() == "en"
                              ? tripFavoriteDetailsController.to.toString()
                              : tripFavoriteDetailsController.to_ar.toString()),
                        ],
                      ))),
                  Obx(() => ListTile(
                        title: Text('Date'.tr +
                            " : " +
                            tripFavoriteDetailsController.date.toString()),
                      )),
                  Obx(() => ListTile(
                        title: Text('duration'.tr +
                            " : " +
                            tripFavoriteDetailsController.duration.toString()),
                      )),
                  Obx(() => ListTile(
                          title: Row(
                        children: [
                          Text('Trip type'.tr),
                          Text(' : '),
                          Text(Get.locale.toString() == "en"
                              ? tripFavoriteDetailsController.type.toString()
                              : tripFavoriteDetailsController.type_ar
                                  .toString()),
                        ],
                      ))),
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
                    onPressed: () {
                      urlTrip = 'https://travelwin1.com/trip/slider?id_post=' +
                          tripFavoriteDetailsController.id.value.toString() +
                          '&id_user=' +
                          tripFavoriteDetailsController.displayUserId.value
                              .toString();
                      openwhatsapp();
                    },
                    child: TextUtils(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      text: 'Reservation'.tr,
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
  }

  openwhatsapp() async {
    final whatsapp = "+905526750481";
    final whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=مرحبا TRAVEL WIN أريد حجز هذه الرحلة .. هل يمكنك تقديم كافة معلومات الرحلة مع التكلفة " +
        urlTrip;

    openWhatsApp(whatsappURl_android, '');
  }
}
