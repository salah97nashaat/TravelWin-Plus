import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/routes/routes.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/auth/auth_button.dart';
import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';
import 'package:travelwin/view/widgets/auth/check_widget.dart';
import 'package:travelwin/view/widgets/text_utils.dart';

import '../../../logic/controllers/complete_signup_controller.dart';

///
class SignUpEmailScreen extends StatefulWidget {
  SignUpEmailScreen({Key? key}) : super(key: key);

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  final CompleteSingupController completeSingupController =
      Get.put(CompleteSingupController());

  final fromKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final controller = Get.find<AuthController>();

  String codeCountry = '';

  String countrydialcode = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.3,
                child: Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 40),
                  child: Form(
                    key: fromKey,
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            TextUtils(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              text: "Complete account information".tr,
                              color: Get.isDarkMode ? pinkClr : mainColor,
                              underLine: TextDecoration.none,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        AuthTextFromField(
                          controller: ageController,
                          obscureText: false,
                          validator: (value) {
                            if (value.length < 1) {
                              return 'Enter valid age'.tr;
                            } else {
                              return null;
                            }
                          },
                          suffixIcon: const Text(""),
                          hintText: 'User age'.tr,
                          keyboardtypeText: 'number',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // AuthTextFromField(
                        //
                        //   controller: mobileController,
                        //   obscureText: false,
                        //   validator: (value) {
                        //     if (value.length<9) {
                        //       return 'Enter valid mobile'.tr;
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   prefixIcon: Get.isDarkMode
                        //       ? const Icon(
                        //     Icons.mobile_friendly,
                        //     color: pinkClr,
                        //     size: 30,
                        //   )
                        //       : Image.asset('assets/images/user.png'),
                        //   suffixIcon: const Text(""),
                        //   hintText: 'Mobile Number'.tr,
                        //   keyboardtypeText:'number',
                        // ),
                        IntlPhoneField(
                          controller: mobileController,
                          initialCountryCode: 'TR',
                          decoration: InputDecoration(
                            labelText: 'Phone Number'.tr,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (phone) {
                            print("email=       =====" +
                                completeSingupController.email.toString());
                          },
                          onCountryChanged: (country) {
                            codeCountry = country.code;
                            countrydialcode = country.dialCode;
                            print('Country changed to: ' + codeCountry);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetBuilder<AuthController>(
                          builder: (_) {
                            return AuthTextFromField(
                              controller: passwordController,
                              obscureText:
                                  controller.isVisibilty ? false : true,
                              validator: (value) {
                                if (value.toString().length < 8) {
                                  return 'Password should be longer or equal to 8 characters'
                                      .tr;
                                } else {
                                  return null;
                                }
                              },
                              hintText: 'Password'.tr,
                              keyboardtypeText: 'text',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.visibility();
                                },
                                icon: controller.isVisibilty
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        CheckWidget(),
                        const SizedBox(
                          height: 50,
                        ),
                        GetBuilder<AuthController>(
                          builder: (_) {
                            return AuthButton(
                              loading: loading,
                              onPressed: () async {
                                if (controller.isCheckBox == false) {
                                  Get.snackbar(
                                    "",
                                    "Please, Accept terms & conditions".tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  //}else
                                  // if(!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(mobileController.text.trim()))
                                  //
                                  // {
                                  //   Get.snackbar(
                                  //     "",
                                  //     "Verify the mobile number".tr,
                                  //     snackPosition: SnackPosition.BOTTOM,
                                  //     backgroundColor: Colors.green,
                                  //     colorText: Colors.white,
                                  //   );
                                } else if (fromKey.currentState!.validate()) {
                                  // String name = nameController.text.trim();
                                  // String email = emailController.text.trim();
                                  String password = passwordController.text;
                                  String age = ageController.text.trim();
                                  String mobile = mobileController.text.trim();
                                  // controller.signUpUsingFirebase(
                                  //   name: name,
                                  //   email: email,
                                  //   password: password,
                                  // );
                                  if (codeCountry == '') {
                                    // Get.snackbar(
                                    //   "mobile code",
                                    //   "Please, select conutry in mobile".tr,
                                    //   snackPosition: SnackPosition.BOTTOM,
                                    //   backgroundColor: Colors.green,
                                    //   colorText: Colors.white,
                                    // );
                                    codeCountry = 'TR';
                                    countrydialcode = '90';
                                  }
                                  setState(() {
                                    loading = true;
                                  });
                                  await controller.startsignUp(
                                    name: completeSingupController.name.value,
                                    email: completeSingupController.email.value,
                                    password: password,
                                    age: age,
                                    mobile: mobile,
                                    living: 'turkey',
                                    gender: 'male',
                                    country_code: codeCountry,
                                    countrydialcode: countrydialcode,
                                  );
                                  if (context.mounted) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                  controller.isCheckBox = true;
                                }
                              },
                              text: "Sign up".tr,
                            );
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextUtils(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              text: 'Already have an Account?'.tr,
                              color: darkGreyClr,
                              underLine: TextDecoration.none,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offNamed(Routes.loginScreen);
                              },
                              child: TextUtils(
                                text: "LOG IN".tr,
                                color: darkGreyClr,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                underLine: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        // ContainerUnder(
                        //   text: 'Already have an Account?'.tr,
                        //   textType: "LOG IN".tr,
                        //   onPressed: () {
                        //     Get.offNamed(Routes.loginScreen);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
