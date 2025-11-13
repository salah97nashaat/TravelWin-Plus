import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/models/Notification.dart';
import 'package:travelwin/utils/my_string.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<Notification?> fetchNotifications(String id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse(baseUrl + '/notifications'), headers: {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print('/////////////////////////////////////');
      var jsonString = response.body;
      return Notification.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }
}
