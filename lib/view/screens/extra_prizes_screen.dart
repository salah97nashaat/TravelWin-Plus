import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import '../../routes/routes.dart';
// import '../../utils/theme.dart';

class ExtraPrizesScreen extends StatelessWidget {
  ExtraPrizesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Extra prizes".tr,
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
        //   drawer: MyDrawer(),
        // bottomNavigationBar:  const AdmobBannerUi(),
        body: Image.asset('assets/images/extraPrizes.png',
            height: 1.sh,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill));
  }
}
