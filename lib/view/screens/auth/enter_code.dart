import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/auth/auth_button.dart';
import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';

class EnterCodeScreen extends StatelessWidget {
  EnterCodeScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController code = TextEditingController();
  final TextEditingController newPass = TextEditingController();

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Forgot Password'.tr,
            style: TextStyle(
              color: Get.isDarkMode ? pinkClr : mainColor,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'enter the 6 digits you got on your email and the new password below'
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  AuthTextFromField(
                    controller: code,
                    obscureText: false,
                    validator: (value) {},
                    suffixIcon: const Text(""),
                    hintText: 'Verification Code'.tr,
                    keyboardtypeText: 'number',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  AuthTextFromField(
                    controller: newPass,
                    obscureText: true,
                    validator: (value) {},
                    suffixIcon: const Text(""),
                    hintText: 'New Password'.tr,
                    keyboardtypeText: 'text',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GetBuilder<AuthController>(builder: (_) {
                    return AuthButton(
                      onPressed: () {
                        if (code.text.trim().isNotEmpty ||
                            newPass.text.isNotEmpty) {
                          if (code.text.trim().length > 6 ||
                              code.text.trim().length < 6) {
                            showSnackBar(
                                context, 'The code must be 6 digits'.tr);
                          } else if (newPass.text.length > 20 ||
                              newPass.text.length < 8) {
                            showSnackBar(context,
                                'The password must be 8 to 20 character'.tr);
                          } else {
                            showLoaderDialog();
                            controller.newPass(
                                email: email!,
                                code: code.text.trim(),
                                pass: newPass.text);
                          } //   controller.resetPassword(email);
                        }
                      },
                      text: "SEND".tr,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
