import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationCountController extends GetxController {
  var isLoading = true.obs;
  var notif = 0.obs;

  final GetStorage authBox = GetStorage();
  @override
  void onInit() {
    get_count_notification_status(authBox.read('userid').toString());
    super.onInit();
  }

  void get_count_notification_status(
    String id,
  ) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "https://travelwin1.com/api/api/get_notification_status/?id=" +
              id; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {
        authBox.write('count_not', responsebody['count']);
        notif.value = responsebody['count'];
        update();
      } else {}
    } finally {}
  }
}
