import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/auth/auth_button.dart';
import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';
import '../../../logic/controllers/drop_down_controller.dart';
import '../../../logic/controllers/edit_profile_controller.dart';
import '../../widgets/my_drop_down.dart';
import '../../widgets/setting/profile_widget.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<AuthController>();

  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  final fromKey = GlobalKey<FormState>();

  TextEditingController myController = TextEditingController()
    ..text = 'Your initial value';

  final TextEditingController nameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  String codeCountry = profile.value.data!.country_code;

  String dialcode = profile.value.data!.dialcode;
  Rx<XFile?> image = XFile('').obs;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    DropDownController dropDownController = DropDownController(
        value: Rx(editProfileController.genderController.text));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Edit account information".tr,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset('assets/images/back.svg')),
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
        body: Form(
          key: fromKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Divider(color: Colors.grey),
              ),
              SizedBox(height: 15.h),
              Center(
                child: Obx(
                  () => Stack(
                    children: [
                      image.value!.path == ''
                          ? profile.value.data!.image == ''
                              ? SvgPicture.asset('assets/images/person.svg')
                              : ClipRRect(
                                  child: InkWell(
                                  onTap: () {
                                    Get.to(() => FullImage(
                                          url: profile.value.data!.image,
                                          network: true,
                                        ));
                                  },
                                  child: Hero(
                                    tag: 'profile',
                                    child: CircleAvatar(
                                        radius: 50.h,
                                        backgroundImage: NetworkImage(
                                            profile.value.data!.image)),
                                  ),
                                ))
                          : ClipRRect(
                              child: InkWell(
                              onTap: () {
                                Get.to(() => FullImage(
                                      url: image.value!.path,
                                      network: false,
                                    ));
                              },
                              child: Hero(
                                tag: 'profile',
                                child: CircleAvatar(
                                    radius: 50.h,
                                    backgroundImage:
                                        FileImage(File(image.value!.path))),
                              ),
                            )),
                      Positioned(
                          bottom: 0,
                          child: InkWell(
                              onTap: () async {
                                image.value = await _picker.pickImage(
                                    source: ImageSource.gallery);
                              },
                              child: SvgPicture.asset(
                                  'assets/images/camera.svg'))),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    AuthTextFromField(
                      controller: editProfileController.nameController,
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
                    const SizedBox(
                      height: 10,
                    ),
                    AuthTextFromField(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1960),
                                lastDate: DateTime.now())
                            .then((value) {
                          editProfileController.ageController.text =
                              DateFormat('yyyy-MM-dd')
                                  .format(value!)
                                  .toString();
                        });
                      },
                      controller: editProfileController.ageController,
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
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: IntlPhoneField(
                        controller: editProfileController.mobileController,
                        initialCountryCode: profile.value.data!.country_code,
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
                          dialcode = country.dialCode;
                          print('Country changed to: ' + codeCountry);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthTextFromField(
                      controller: editProfileController.emailController,
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
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    // AuthTextFromField(
                    //   controller: editProfileController.locationController,
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Obx(
                      () => controller.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : GetBuilder<AuthController>(
                              builder: (_) {
                                return AuthButton(
                                  onPressed: () {
                                    controller.isLoading.value = true;
                                    editProfileController.genderController
                                        .text = dropDownController.value.value;
                                    if (fromKey.currentState!.validate()) {
                                      if (codeCountry == '') {
                                        codeCountry = controller
                                            .displayUserCountryCode.value
                                            .toString();
                                        dialcode = controller
                                            .displayUserCountryDialCode.value
                                            .toString();
                                      }
                                      String id = controller.displayUserId.value
                                          .toString();
                                      String name = editProfileController
                                          .nameController.text
                                          .trim();
                                      String age = editProfileController
                                          .ageController.text
                                          .trim();
                                      String mobile = editProfileController
                                          .mobileController.text
                                          .trim();
                                      String email = editProfileController
                                          .emailController.text
                                          .trim();
                                      String living_country = '';
                                      String gender = editProfileController
                                          .genderController.text
                                          .trim();

                                      controller.EditProfile(
                                          id: id,
                                          name: name,
                                          age: age,
                                          mobile: mobile,
                                          country_code: codeCountry,
                                          controller: controller,
                                          dialcode: dialcode,
                                          email: email,
                                          living_country: living_country,
                                          gender: gender,
                                          newImage: image.value!.path);
                                      // profileController.fetchProfile();

                                      //  Get.back();
                                    } else {
                                      controller.isLoading.value = false;
                                    }
                                  },
                                  text: "Save".tr,
                                );
                              },
                            ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
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
