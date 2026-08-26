import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';

import '../models/tripe_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<Trip>?> fetchProducts() async {
    final GetStorage authBox = GetStorage();

    String token =authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('$baseUrlApi/get_alltripes'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      return tripFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<Trip>?> FetchFavoritesTrip() async {
    final GetStorage authBox = GetStorage();
    String userid =authBox.read('userid').toString();
    String token =authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('$baseUrlApi/get_tripes_favorites/?id='+userid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      return tripFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }


}
