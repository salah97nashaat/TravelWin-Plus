// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import '../../logic/controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';

class TicketScreen extends StatelessWidget {
  TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
        elevation: 0,
        title: Center(child: Text('your tickets'.tr)),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.mainScreen);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      //   drawer: MyDrawer(),

      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                      Get.isDarkMode ? darkGreyClr : mainColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    // side: BorderSide(color: Colors.red)
                  ))),
              onPressed: () {
                Get.toNamed(Routes.ViewTicketScreen);
              },
              child: Text('Buying a ticket'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
