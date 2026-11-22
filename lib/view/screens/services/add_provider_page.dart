import 'dart:io';

// import 'package:app/views/pages/service_chooser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/logic/controllers/service_controller.dart';
import 'package:travelwin/logic/controllers/service_state_controller.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/models/service_state_model.dart';
import 'package:travelwin/utils/constants.dart';
import '../../../helpers/adv/admob_banner.dart';

class AddProviderPage extends StatefulWidget {
  const AddProviderPage({super.key});

  @override
  State<AddProviderPage> createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  ProviderModel provider = ProviderModel(id: 0, serviceId: 1, stateId: 1);
  // ImageProvider? profileImage;
  ServicesController servicesController = Get.find();
  ServiceStateController statesController = Get.find();
  List<ServiceStateModel> states = [];
  List<XFile> imgs = [];
  int? imgIndex;
  PageController imgsController = PageController();
  XFile? profileImageFile;
  GlobalKey<FormState> formState = GlobalKey();
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    states = await statesController.getStates();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    bool isAr = Get.locale!.languageCode == "ar";
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        title: Text("add_service".tr),
        backgroundColor: inversePrimaryColor,
        foregroundColor: primaryColor,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      Text(
                        "logo".tr,
                        style:
                            TextStyle(fontSize: 16, color: inversePrimaryColor),
                      ),
                      const SizedBox(height: 4.0),
                      GestureDetector(
                        onTap: () async {
                          profileImageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {});
                        },
                        child: CircleAvatar(
                          backgroundImage: profileImageFile != null
                              ? FileImage(File(profileImageFile?.path ?? ""))
                              : null,
                          radius: 50,
                          child: profileImageFile != null
                              ? null
                              : const Icon(Icons.add_a_photo_outlined),
                        ),
                      ),
                      // TextFormField(
                      //   initialValue: stateController.getStateFromStorage().nameEn,
                      //   decoration: InputDecoration(
                      //       labelText: "الولاية",
                      //       labelStyle: TextStyle(color: inversePrimaryColor)),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "يرجى ملئ الحقل";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // TextFormField(
                      //   decoration: InputDecoration(
                      //       labelText: "فئة العمل او النشاط",
                      //       labelStyle: TextStyle(color: inversePrimaryColor)),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "يرجى ملئ الحقل";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "state".tr,
                              style: TextStyle(
                                  color: inversePrimaryColor, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              items: [
                                ...states.map((element) => DropdownMenuItem(
                                      value: element.id,
                                      child: Text(isAr
                                          ? element.nameAr!
                                          : element.nameEn!),
                                    ))
                              ],
                              value: provider.stateId,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  provider.stateId = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "provider_service".tr,
                              style: TextStyle(
                                  color: inversePrimaryColor, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                              items: [
                                ...servicesController.services
                                    .map((element) => DropdownMenuItem(
                                          value: element.id,
                                          child: Text(isAr
                                              ? element.nameAr
                                              : element.nameEn),
                                        ))
                              ],
                              value: servicesController.services[0].id,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  provider.serviceId = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "provider_name_ar".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.nameAr = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "provider_name_en".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.nameEn = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            "working_hours".tr,
                            style: TextStyle(
                              color: inversePrimaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            // style: ButtonStyle(
                            //     padding: MaterialStatePropertyAll(
                            //         EdgeInsets.symmetric(horizontal: 4))),
                            onPressed: () {
                              Get.dialog(const TimePickerDialog(
                                initialTime: TimeOfDay(hour: 9, minute: 0),
                                initialEntryMode: TimePickerEntryMode.input,
                              )).then((value) {
                                if (value != null) {
                                  final time = value as TimeOfDay;
                                  provider.openTime =
                                      "${intToFixedString(time.hour, 2)}:${intToFixedString(time.minute, 2)}";
                                  setState(() {});
                                }
                              });
                            },
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'from'.tr),
                                if (provider.openTime != null)
                                  TextSpan(text: "\n${provider.openTime}")
                              ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              Get.dialog(const TimePickerDialog(
                                initialTime: TimeOfDay(hour: 17, minute: 0),
                                initialEntryMode: TimePickerEntryMode.input,
                              )).then((value) {
                                if (value != null) {
                                  final time = value as TimeOfDay;
                                  provider.closeTime =
                                      "${intToFixedString(time.hour, 2)}:${intToFixedString(time.minute, 2)}";
                                  setState(() {});
                                }
                              });
                            },
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'to'.tr),
                                if (provider.closeTime != null)
                                  TextSpan(text: "\n${provider.closeTime}")
                              ]),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "min_price".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) =>
                            provider.minFee = num.parse(value.toString()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          if (num.tryParse(value) == null) {
                            return "number_field".tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "details_ar".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.detailsAr = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "details_ar".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.detailsEn = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "offers_sales_coupons_ar".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "offers_sales_coupons_en".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "address_ar".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.addressAr = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "address_en".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.addressEn = value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required_field".tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "photos".tr,
                            style: TextStyle(
                                fontSize: 16, color: inversePrimaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              child: PhotoViewGallery.builder(
                                pageController: imgsController,
                                backgroundDecoration:
                                    const BoxDecoration(color: Colors.white),
                                itemCount: imgs.length,
                                builder: (context, index) {
                                  return PhotoViewGalleryPageOptions(
                                      imageProvider:
                                          FileImage(File(imgs[index].path)));
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (imgs.isNotEmpty)
                                    IconButton(
                                      color: mainColor2,
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        // print();
                                        setState(() {
                                          imgs.removeAt(
                                              imgsController.page!.toInt());
                                        });
                                      },
                                    ),
                                  IconButton(
                                    color: inversePrimaryColor,
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      var files =
                                          await ImagePicker().pickMultiImage();
                                      if (files.isNotEmpty) {
                                        setState(() {
                                          imgs.addAll(files);
                                          imgsController.animateToPage(
                                              imgs.length - 1,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.bounceInOut);
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "phone_number".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.phoneNumber = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "whatsapp".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.whatsapp = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "facebook".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.facebook = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "instagram".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.instagram = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "tiktok".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.tiktok = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "website".tr,
                            labelStyle: TextStyle(color: inversePrimaryColor)),
                        onChanged: (value) => provider.website = value,
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                          onPressed: () async {
                            if (profileImageFile == null) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Icon(Icons.error),
                                  content: Text("set_logo".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // Get.back();
                                          Get.back();
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ),
                              );
                              return;
                            }
                            if (imgs.isEmpty || imgs.length < 3) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Icon(Icons.error),
                                  content: Text("invalid_img_count".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // Get.back();
                                          Get.back();
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ),
                              );
                              return;
                            }
                            List<int> filesizes =
                                await Future.wait(imgs.map((e) => e.length()));

                            if (!filesizes.every(
                                (element) => element < 2 * 1024 * 1024)) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Icon(Icons.error),
                                  content: Text("invalid_img_size".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // Get.back();
                                          Get.back();
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ),
                              );
                              return;
                            }

                            // if()
                            if (!formState.currentState!.validate()) {
                              Get.dialog(
                                AlertDialog(
                                  title: const Icon(Icons.error),
                                  content: Text("check_inputs".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // Get.back();
                                          Get.back();
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ),
                              );
                              return;
                            }
                            if (formState.currentState!.validate()) {
                              formState.currentState!.save();
                              ProviderController providerController =
                                  Get.find();
                              // var s = statesController.getStateFromStorage();
                              // provider.stateId = s.id;
                              setState(() {
                                isLoading = true;
                              });
                              StreamedResponse resp =
                                  await providerController.addProvider(
                                provider,
                                profileImageFile?.path,
                                imgs.map((e) => e.path).toList(),
                              );
                              var body = await resp.stream.bytesToString();
                              print(body);
                              setState(() {
                                isLoading = false;
                              });
                              if (resp.statusCode == 200) {
                                Get.dialog(AlertDialog(
                                  title: const Icon(Icons.info_outline),
                                  content: Text("request_process_48".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                          Get.back();
                                          // Get.offAll(() => const ServiceChooser());
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ));
                              } else {
                                Get.dialog(AlertDialog(
                                  title: const Icon(Icons.error),
                                  content: Text("connection_error".tr),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          // Get.back();
                                          Get.back();
                                        },
                                        child: Text("ok".tr))
                                  ],
                                ));
                              }
                            }
                          },
                          child: Text("add".tr)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
