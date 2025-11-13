import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';
// import '../../../routes/routes.dart';
// import '../../../utils/theme.dart';
import '../../logic/controllers/term_controller.dart';
import '../widgets/term/term_title.dart';

class ViewTermScreen extends StatelessWidget {
  final TermController termController = Get.put(TermController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        elevation: 0,
        title: Text(
          'Ticket collection conditions'.tr,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset('assets/images/back.svg'))),
          SizedBox(
            width: 25.w,
          ),
        ],
        centerTitle: true,
        leadingWidth: 65.w,
        // leading: InkWell(
        //   onTap: (){
        //     Get.toNamed(Routes.FortuneWheelScreen);
        //   },
        //   child: Padding(
        //     padding: Get.locale == Locale('ar')
        //         ? EdgeInsets.only(right: 15.w, top: 5.h)
        //         : EdgeInsets.only(left: 15.w, top: 5.h),
        //     child: Container(
        //       height: 45,
        //       decoration: BoxDecoration(
        //         color: mainColor2.withOpacity(0.2),
        //         borderRadius: BorderRadius.circular(17.5),
        //       ),
        //       child: Center(
        //           child: Padding(
        //               padding: EdgeInsets.symmetric(horizontal: 6.w),
        //               child: Text(
        //                 'wheel of luck'.tr,
        //                 style: TextStyle(color: Colors.black, fontSize: 12.w),
        //                 textAlign: TextAlign.center,
        //               ))),
        //     ),
        //   ),
        // )
      ),

      backgroundColor: Colors.white,
      // drawer: MyDrawer(),
      // bottomNavigationBar:
      // const AdmobBannerUi(),
      // const ApplovinBannerUi(),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (ticketsTerm.value.terms == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: ticketsTerm.value.terms!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TermTile(ticketsTerm.value.terms![index]);
                    });
              }
            }),
          )
        ],
      ),
    );
  }
}
