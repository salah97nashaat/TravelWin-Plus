import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:travelwin/logic/controllers/tourguy_controller.dart';
// import 'package:travelwin/view/screens/messeges/widgets.dart';
import 'package:travelwin/view/screens/tour%20guidiens/widgets.dart';

// import '../../../logic/controllers/chat_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/my_string.dart';
import '../../../utils/theme.dart';
// import '../../widgets/auth/auth_text_from_field.dart';

class SearchForTourGuide extends StatefulWidget {
  SearchForTourGuide({Key? key}) : super(key: key);

  @override
  State<SearchForTourGuide> createState() => _SearchForTourGuideState();
}

class _SearchForTourGuideState extends State<SearchForTourGuide> {
  TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Find a Tour Guide'.tr,
            style: TextStyle(color: Colors.black),
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
          leading: Visibility(
            visible: token.value != 'null',
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.signUpAsGuide);
              },
              child: Padding(
                padding: Get.locale == Locale('ar')
                    ? EdgeInsets.only(right: 15.w, top: 5.h)
                    : EdgeInsets.only(left: 15.w, top: 5.h),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: mainColor2.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            'join as a guide'.tr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 8.sp),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ))),
                ),
              ),
            ),
          )),
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
              () => (guidence.value.guidances ?? []).isEmpty
                  ? Center(
                      child: Text(
                        'Nothing to show'.tr,
                        style: TextStyle(color: mainColor, fontSize: 24.sp),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 15.h),
                      itemBuilder: (context, index) => TourGuyWidget(
                            index: index,
                          ),
                      separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 25.w),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                      itemCount: guidence.value.guidances!.length),
            ),
          ),
        ],
      ),
    );
  }
}
