import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/routes/routes.dart';

import 'package:travelwin/utils/my_string.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/auth/auth_button.dart';
import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';
// import 'package:travelwin/view/widgets/auth/check_widget.dart';
import 'package:travelwin/view/widgets/text_utils.dart';

// import '../../../helpers/helper.dart';
import '../../../logic/controllers/drop_down_controller.dart';
import '../../widgets/my_drop_down.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fromKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final controller = Get.find<AuthController>();

  String codeCountry = '';

  String countryDialCode = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    DropDownController dropDownController =
        DropDownController(value: Rx('male'.tr));

    // Future<bool> showExitPopup() async {
    //   return await showDialog(
    //         //show confirm dialogue
    //         //the return value will be from "Yes" or "No" options
    //         context: context,
    //         builder: (context) => AlertDialog(
    //           title: Text('Exit App'.tr),
    //           content: Text('Do you want to exit an App?'.tr),
    //           actions: [
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
    //                 //  minimumSize: const Size(360, 50),
    //               ),
    //               // color: Get.isDarkMode ? darkGreyClr : mainColor,
    //               onPressed: () => Navigator.of(context).pop(false),
    //               //return false when click on "NO"
    //               child: Text("No".tr),
    //             ),
    //             ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: Get.isDarkMode ? pinkClr : mainColor,
    //                 //  minimumSize: const Size(360, 50),
    //               ),
    //               onPressed: () => Navigator.of(context).pop(true),
    //               //return true when click on "Yes"
    //               child: Text('Yes'.tr),
    //             ),
    //           ],
    //         ),
    //       ) ??
    //       false; //if showDialouge had returned null, then return false
    // }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Form(
        key: fromKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView(
            children: [
              Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/icon/logo.png',
                    height: 200.h,
                  )),
              SizedBox(
                height: 40.h,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                //Center Row contents vertically,
                children: [
                  TextUtils(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.normal,
                    text: "SIGN".tr,
                    color: mainColor,
                    underLine: TextDecoration.none,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  TextUtils(
                    fontSize: 23.sp,
                    fontWeight: FontWeight.normal,
                    text: "UP".tr,
                    color: mainColor,
                    underLine: TextDecoration.none,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              AuthTextFromField(
                controller: nameController,
                obscureText: false,
                validator: (value) {
                  if (value.toString().length <= 2 ||
                      !RegExp(validationName).hasMatch(value)) {
                    return 'Enter valid name'.tr;
                  } else {
                    return null;
                  }
                },
                suffixIcon: const Text(""),
                hintText: 'User Name'.tr,
                keyboardtypeText: 'text',
              ),

              SizedBox(
                height: 18.h,
              ),
              AuthTextFromField(
                controller: emailController,
                obscureText: false,
                validator: (value) {
                  if (!RegExp(validationEmail).hasMatch(value)) {
                    return 'Invalid email'.tr;
                  } else {
                    return null;
                  }
                },
                suffixIcon: const Text(""),
                hintText: 'Email'.tr,
                keyboardtypeText: 'text',
              ),
              SizedBox(
                height: 18.h,
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
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now())
                      .then((value) {
                    ageController.text =
                        DateFormat('yyyy-MM-dd').format(value!).toString();
                  });
                },
                suffixIcon: const Text(""),
                hintText: 'User age'.tr,
                keyboardtypeText: 'number',
              ),
              SizedBox(
                height: 18.h,
              ),

              const SizedBox(
                height: 18,
              ),
              // AuthTextFromField(
              //   controller: locationController,
              //   obscureText: false,
              //   validator: (value) {
              //     if (value==null) {
              //       return 'Location can not be empty'.tr;
              //     } else {
              //       return null;
              //     }
              //   },
              //   suffixIcon: const Text(""),
              //   hintText: 'Location'.tr,
              //   keyboardtypeText: 'text',
              // ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: IntlPhoneField(
                  controller: mobileController,
                  initialCountryCode: 'TR',
                  decoration: InputDecoration(
                    labelText: 'Phone Number'.tr,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    codeCountry = country.code;
                    countryDialCode = country.dialCode;
                    print('Country changed to: ' + codeCountry);
                  },
                ),
              ),
              SizedBox(height: 18.sp),
              GetBuilder<AuthController>(
                builder: (_) {
                  return AuthTextFromField(
                    controller: passwordController,
                    obscureText: controller.isVisibilty ? false : true,
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
              SizedBox(
                height: 20.h,
              ),
              GetBuilder<AuthController>(
                builder: (_) {
                  return AuthButton(
                    loading: loading,
                    onPressed: () async {
                      if (loading) return;
                      if (fromKey.currentState!.validate()) {
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
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
                          countryDialCode = '90';
                        }
                        setState(() {
                          loading = true;
                        });
                        await controller.startsignUp(
                            name: name,
                            email: email,
                            password: password,
                            living: '',
                            gender: dropDownController.value.value,
                            age: age,
                            mobile: mobile,
                            countrydialcode: countryDialCode,
                            country_code: codeCountry);
                        controller.isCheckBox = true;
                      }
                      if (context.mounted) {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    text: "Sign up".tr,
                  );
                },
              ),
              SizedBox(
                height: 18.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(color: Colors.black, thickness: 0.5)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextUtils(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                          text: 'OR'.tr,
                          color: Colors.black,
                          underLine: TextDecoration.none),
                    ),
                    Expanded(
                        child: Divider(color: Colors.black, thickness: 0.5)),
                  ],
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              GetBuilder<AuthController>(builder: (_) {
                return InkWell(
                  onTap: () {
                    controller.googleSinUpApp();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: mainColor),
                        borderRadius: BorderRadius.circular(25.r)),
                    width: 600,
                    height: 35.h,
                    child: Row(
                      //Center Row contents horizontally,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //Center Row contents vertically,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/images/Google Logo.png",
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Center(
                            child: Text(
                          'Sign up using Google'.tr,
                          style: TextStyle(color: mainColor),
                        )),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                  height: 15.h,
                ),
                if (Platform.isIOS)
                GetBuilder<AuthController>(builder: (_) {
                  return InkWell(
                    onTap: () {
                      controller.appleSignUpApp();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: mainColor),
                          borderRadius: BorderRadius.circular(25.r)),
                      width: 600,
                      height: 35.h,
                      child: Row(
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, //Center Row contents vertically,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 30.w,
                            height: 30.h,
                            child: Image.asset(
                              "assets/images/apple.png",
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Center(
                              child: Text(
                            'Sign up using Apple'.tr,
                            style: TextStyle(color: mainColor),
                          )),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 15.h,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     controller.faceBookSignUpApp();
                  //   },
                  //   child: Image.asset(
                  //     "assets/images/facebook.png",
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextUtils(
                    fontSize: 17.sp,
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
                      color: Get.isDarkMode ? darkGreyClr : mainColor,
                      fontSize: 17.sp,
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
    );
  }
}
