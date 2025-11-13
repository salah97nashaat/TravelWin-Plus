import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';
// import 'package:travelwin/view/widgets/upperContainerUi.dart';
// import '../../../helpers/adv/admob_banner.dart';
import '../../../logic/controllers/tripe_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
// import '../../widgets/trip.dart/search_text_form.dart';
// import '../../widgets/trip.dart/trip_tile.dart';

class TripFavorite extends StatelessWidget {
  final TripeController tripeController = Get.put(TripeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favorite Trips'.tr,
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
      //backgroundColor: Get.isDarkMode ? Theme.of(context).colorScheme.surface : litmain,
      // drawer: MyDrawer(),
      // const ApplovinBannerUi(),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(
              color: Colors.grey.withOpacity(0.35),
              thickness: 1,
            ),
          ),
          Expanded(
            child: Obx(
              () => favoriteModel.value.data!.trips!.isEmpty
                  ? Center(
                      child: Text(
                        'Nothing to show'.tr,
                        style: TextStyle(color: mainColor, fontSize: 24.sp),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              trip.value =
                                  favoriteModel.value.data!.trips![index];
                              Get.toNamed(Routes.ViewTripsDetailsScreen);
                            },
                            child: TripWidget(
                                image: favoriteModel.value.data!.trips![index]
                                    .images![0].image!,
                                name: Get.locale == Locale('ar')
                                    ? favoriteModel
                                        .value.data!.trips![index].nameAr!
                                    : favoriteModel
                                        .value.data!.trips![index].nameEn!),
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10.h,
                          ),
                      itemCount: favoriteModel.value.data!.trips!.length),
            ),
          )
        ],
      ),
    );
  }
}

class TripWidget extends StatelessWidget {
  const TripWidget({super.key, required this.image, required this.name});
  final String name;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160.h,
        width: Get.width - 40,
        decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(20),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 30.h,
            width: 180.w,
            decoration: BoxDecoration(
              color: Color(0xB2E3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(name,
                  style: TextStyle(color: mainColor, fontSize: 15.sp),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}
