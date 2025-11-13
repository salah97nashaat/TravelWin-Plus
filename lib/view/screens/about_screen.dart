import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';
// import '../../../routes/routes.dart';
import '../../../utils/theme.dart';
import '../../logic/controllers/about_controller.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);
  final AboutController aboutController = Get.put(AboutController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "About App".tr,
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
        // leading: IconButton(
        //   onPressed: () { Get.offAllNamed(Routes.mainScreen);           },
        //   icon: Icon(Icons.home),
        // ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(
        () => about.value.about!.isEmpty
            ? CircularProgressIndicator(
                color: mainColor,
              )
            : ListView(children: [
                // ListTile(
                //   title: Text(
                //     "Share".tr,
                //     style: TextStyle(
                //         color: Get.isDarkMode ? pinkClr : mainColor, fontSize: 18),
                //   ),
                //   leading: Icon(
                //     Icons.share,
                //     color: Get.isDarkMode ? pinkClr : mainColor,
                //     size: 25,
                //   ),
                //   onTap: () async {
                //     Share.share('https://travelwin1.com/');
                //   },
                // ),

                const Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Divider(color: Colors.grey),
                ),
                //    Obx(() => Text(aboutController.displayBody.value)),
                ListView.separated(
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            Get.locale == Locale('en')
                                ? about.value.about![index].bodyEn!
                                : about.value.about![index].bodyAr!,
                            style: TextStyle(color: mainColor, fontSize: 15.sp),
                          ))
                    ],
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20.h,
                  ),
                  itemCount: about.value.about!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              ]),
      ),
    ));
  }
}
