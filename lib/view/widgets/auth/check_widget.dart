import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/text_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckWidget extends StatelessWidget {
  CheckWidget({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              controller.checkBox();
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: controller.isCheckBox
                  ? Get.isDarkMode
                      ? const Icon(
                          Icons.done,
                          color: pinkClr,
                        )
                      : Image.asset('assets/images/check.png')
                  : Container(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                text: "I accept".tr,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                underLine: TextDecoration.none,
              ),
              SizedBox(
                width: 5.0,
              ),
              // TextUtils(
              //   fontSize: 16,
              //   fontWeight: FontWeight.normal,
              //   text: "terms & conditions".tr,
              //   color: Get.isDarkMode ? Colors.white : Colors.black,
              //   underLine: TextDecoration.underline,
              // ),
              GestureDetector(
                onTap: () {
                  openwhatsapp();
                  //  Get.toNamed(Routes.PrivacyScreen);
                  // get the text of TextWidget here
                },
                child: new Text(
                  "terms & conditions".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ],
      );
    });
  }

  openwhatsapp() async {
    final Uri _url = Uri.parse(
        'https://www.termsfeed.com/live/d80a022e-68be-4d68-8365-43d24e80f41c');
    var whatsappURl_android =
        "https://www.termsfeed.com/live/d80a022e-68be-4d68-8365-43d24e80f41c";
    var whatappURL_ios =
        "${Uri.parse("https://www.termsfeed.com/live/d80a022e-68be-4d68-8365-43d24e80f41c")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatappURL_ios))) {
        await launchUrl(Uri.parse(whatappURL_ios),
            mode: LaunchMode.externalApplication);
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
        await launchUrl(_url);
      }
    }
  }
}
