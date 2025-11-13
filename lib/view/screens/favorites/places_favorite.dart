import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../widgets/places_widget.dart';

class PlacesFavorite extends StatelessWidget {
  const PlacesFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favorite Tourism Areas'.tr,
          style: TextStyle(color: Colors.black, fontSize: 18.w),
        ),
        centerTitle: true,
        leadingWidth: 65.w,
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
      ),
      body: SingleChildScrollView(
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
              height: 20.h,
            ),
            Obx(
              () => favoriteModel.value.data == null ||
                      favoriteModel.value.data!.places!.isEmpty
                  ? Center(
                      child: Text(
                        'Nothing to show'.tr,
                        style: TextStyle(color: mainColor, fontSize: 24.sp),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: favoriteModel.value.data!.places!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.73,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 15),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            statePlaces.value = favoriteModel
                                .value.data!.places![index].statePlaces!;
                            Get.toNamed(Routes.placeDetails);
                          },
                          child: Obx(
                            () => favoriteModel.value.data!.places![index]
                                    .statePlaces!.images!.isEmpty
                                ? Container()
                                : PlacesWidget(
                                    image: favoriteModel
                                            .value
                                            .data!
                                            .places![index]
                                            .statePlaces!
                                            .images![0]
                                            .url ??
                                        '',
                                    name: Get.locale == Locale('ar')
                                        ? favoriteModel.value.data!
                                            .places![index].statePlaces!.nameAr!
                                        : favoriteModel
                                            .value
                                            .data!
                                            .places![index]
                                            .statePlaces!
                                            .nameEn!,
                                    rate: favoriteModel.value.data!
                                            .places![index].statePlaces!.rate ??
                                        '0',
                                    space: '41 Km',
                                  ),
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
