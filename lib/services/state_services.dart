import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';

import '../models/state_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<StateModels>?> fetchstates() async {
    final GetStorage authBox = GetStorage();

    String token =authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('$baseUrlApi/get_state'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return stateModelsFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
