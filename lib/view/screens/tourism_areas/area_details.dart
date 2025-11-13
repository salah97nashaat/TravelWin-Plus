// import 'dart:ffi';

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
// import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/view/widgets/tourism_place.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
import '../../../routes/routes.dart';
import '../../../utils/my_string.dart';
// import '../../widgets/bookmark_widget.dart';
// import '../../widgets/normalButton.dart';
import '../../widgets/place_text.dart';
import '../../widgets/places_widget.dart';

class AreaDetails extends StatefulWidget {
  AreaDetails({Key? key}) : super(key: key);

  @override
  State<AreaDetails> createState() => _AreaDetailsState();
}

class _AreaDetailsState extends State<AreaDetails> {
  AreaDetailsController areaDetailsController = AreaDetailsController(
      selected: Get.locale == Locale('ar')
          ? Rx(statePlacesForState.value!.placesType!.first.nameAr!)
          : Rx(statePlacesForState.value!.placesType!.first.nameEn!));
  bool isLoading = false;
  int pageCount = 1;
  StatesPlaces? s;
  late ScrollController _scrollController;
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

  void addItemIntoLisT(var pageCount) {
    print(statesPlaces.value.statePlaces!.data!.length);
    isLoading = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        leading: Container(),
        title: Text(
          Get.locale == Locale('ar')
              ? home.value!.data!.states![stateId.value].nameAr!
              : home.value!.data!.states![stateId.value].nameEn!,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: Get.locale == Locale('ar')
                ? EdgeInsets.only(left: 25.w, top: 5.h)
                : EdgeInsets.only(right: 25.w, top: 5.h),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset(
                    'assets/images/back.svg',
                    height: 30,
                  ),
                )),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(
              () => Container(
                width: 359,
                height: 186,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(stateImage.value),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
                height: 25.h,
                child: Center(
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Center(
                            child: InkWell(
                                onTap: () async {
                                  statesPlaces.value = (await RemoteServices
                                      .fetchStateAreaPlaces(
                                          home.value!.data!
                                              .states![stateId.value].id,
                                          statePlacesForState
                                              .value!.placesType![index].id,
                                          1))!;
                                  areaDetailsController.changeTheType(
                                      Get.locale == Locale('ar')
                                          ? statePlacesForState
                                              .value!.placesType![index].nameAr!
                                          : statePlacesForState.value!
                                              .placesType![index].nameEn!,
                                      index);
                                },
                                child: Obx(() => PlacesText(
                                    name: Get.locale == Locale('ar')
                                        ? statePlacesForState
                                            .value!.placesType![index].nameAr!
                                        : statePlacesForState
                                            .value!.placesType![index].nameEn!,
                                    status: Get.locale == Locale('ar')
                                        ? areaDetailsController.selected ==
                                            statePlacesForState.value!
                                                .placesType![index].nameAr!
                                        : areaDetailsController.selected ==
                                            statePlacesForState.value!
                                                .placesType![index].nameEn!))),
                          ),
                      separatorBuilder: (context, index) => VerticalDivider(
                            color: Colors.grey,
                            thickness: 1.2,
                          ),
                      itemCount: statePlacesForState.value!.placesType!.length),
                )),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Divider(
                color: Colors.grey.withOpacity(0.35),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: statesPlaces.value.statePlaces!.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.73,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      statePlaces.value =
                          statesPlaces.value.statePlaces!.data![index];
                      print(statePlaces.value.rate);
                      Get.toNamed(Routes.placeDetails);
                    },
                    child: Obx(
                      () => statesPlaces
                              .value.statePlaces!.data![index].images!.isEmpty
                          ? Container()
                          : PlacesWidget(
                              image: statesPlaces.value.statePlaces!
                                      .data![index].images![0].url ??
                                  '',
                              name: Get.locale == Locale('ar')
                                  ? statesPlaces
                                      .value.statePlaces!.data![index].nameAr!
                                  : statesPlaces
                                      .value.statePlaces!.data![index].nameEn!,
                              space: '41 Km',
                              rate: statesPlaces.value.statePlaces!.data![index]
                                          .rate ==
                                      null
                                  ? '0'
                                  : statesPlaces
                                      .value.statePlaces!.data![index].rate!
                                      .toString(),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
