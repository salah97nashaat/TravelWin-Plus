import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/notification_model.dart';
import 'dart:convert';

class NotificationDetailsController extends GetxController {
  var isLoading = true.obs;
  var notificationlist = <NotificationModels>[].obs;
  final GetStorage authBox = GetStorage();
  var title = ''.obs;
  var body = ''.obs;
  var title_ar = ''.obs;
  var body_ar = ''.obs;
  var createdAt = ''.obs;
  var notif = 0.obs;
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    notif.value = authBox.read('count_not') - 1;
    authBox.write('count_not', notif.value);
    title.value = argumentData[0]['title'];
    title_ar.value = argumentData[0]['title_ar'];
    body.value = argumentData[0]['body'];
    body_ar.value = argumentData[0]['body_ar'];
    createdAt.value = argumentData[0]['createdAt'];
    update_notification_status(argumentData[0]['id']);
    super.onInit();
  }

  void update_notification_status(
    String id,
  ) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "https://travelwin1.com/api/api/update_notification_status/?id=" +
              id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {
      } else {}
    } finally {}
  }
}
