import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:travelwin/logic/controllers/medicalTourismController.dart';
// import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/tourism_place.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../const.dart';
import '../../../models/NewHome.dart';
import '../../../utils/my_string.dart';
// import '../../widgets/normalButton.dart';

class TourismAreas extends StatelessWidget {
  TourismAreas({Key? key}) : super(key: key);
  final MedicalTourismController medicalTourismController =
      MedicalTourismController();
  final Rx<bool> search = Rx(false);
  final Rx<List<States>> searchList = Rx([]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        title: Text(
          "Tourism Areas".tr,
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
            SizedBox(
              height: 35.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: TextFormField(
                    onChanged: (value) {
                      if (value.isEmpty) {
                      } else {
                        searchList.value = [];
                        search.value = true;
                        String value1 = '';
                        if (value.contains('ا')) {
                          value1 = value.replaceAll('ا', "أ");
                        } else if (value.contains('أ')) {
                          value1 = value.replaceAll('أ', "ا");
                        } else {}
                        print(value);
                        home.value!.data!.states!.forEach((element) {
                          if ((value1 == ''
                                  ? false
                                  : element.nameAr!.contains(value1)) ||
                              element.nameAr!.contains(value) ||
                              element.nameEn!
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            searchList.value.add(element);
                          }
                        });
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Color(0xfffbfbfb),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Color(0xffEBEBEB), width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Color(0xffEBEBEB), width: 2)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Color(0xffebebeb), width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Color(0xffEBEBEB), width: 2)),
                        hintText: 'Search'.tr,
                        hintStyle: TextStyle(color: Color(0xff999999)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff999999),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.h))),
              ),
            ),
            Obx(
              () => search.value
                  ? ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20.h),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => TourismPlace(
                        states: searchList.value[index],
                        index: index,
                      ),
                      itemCount: searchList.value.length,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20.h),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => TourismPlace(
                        states: home.value!.data!.states![index],
                        index: index,
                      ),
                      itemCount: home.value!.data!.states!.length,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
