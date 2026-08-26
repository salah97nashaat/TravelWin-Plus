import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';

class AboutController extends GetxController {
  var isLoading = true.obs;
  var displayBody = ''.obs;
  var displayBodyAr = ''.obs;
  var PrivacyBody = ''.obs;
  var PrivacyBodyAr = ''.obs;
  var OtherServicesBody = ''.obs;
  var OtherServicesBodyAr = ''.obs;
  var test = ''.obs;
  @override
  Future<void> onInit() async {
    test.value = "testtt";

    about.value = (await RemoteServices.fetchAbout())!;
    super.onInit();
  }

  fetchAbout() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    String apiurl = baseUrl + '/about'; //api url
    var response = await http.get(Uri.parse(apiurl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      displayBody.value = responsebody['body'].toString();
      displayBodyAr.value = responsebody['body_ar'].toString();
    }
  }

  fetchPrivacy() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    String apiurl = "$baseUrlApi/get_privacy"; //api url
    var response = await http.get(Uri.parse(apiurl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      PrivacyBody.value = responsebody['body'].toString();
      PrivacyBodyAr.value = responsebody['body_ar'].toString();
    }
  }

  fetchOtherServices() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    String apiurl =
        "$baseUrlApi/get_other_services"; //api url
    var response = await http.get(Uri.parse(apiurl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      OtherServicesBody.value = responsebody['body'].toString();
      OtherServicesBodyAr.value = responsebody['body_ar'].toString();
    }
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.

  //   test.value = "hhhh";
  //   print("Handling a background message: ${message.notification?.title}");
  // }
}
