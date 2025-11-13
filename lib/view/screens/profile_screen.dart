// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/setting/profile_widget.dart';
import '../../logic/controllers/auth_controller.dart';
import '../../logic/controllers/main_controller.dart';
// import '../../logic/controllers/profile_controller.dart';
// import '../../routes/routes.dart';
import '../../utils/my_string.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final authController = Get.find<AuthController>();
  // ignore: prefer_typing_uninitialized_variables
  // var username;
  // ignore: prefer_typing_uninitialized_variables
  // var lastname;
  // ignore: prefer_typing_uninitialized_variables
  // var email;
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        centerTitle: true,
        title: Text(
          "Profile".tr,
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
      // drawer: MyDrawer(),

      body: Center(
          child: Obx(() => profile.value.data == null
              ? CircularProgressIndicator()
              : ProfileWidget())),
    );
  }
}
