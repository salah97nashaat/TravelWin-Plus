import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/tripe_favorite_model.dart';
import '../models/tripe_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<Trip>?> fetchProducts() async {
    final GetStorage authBox = GetStorage();


    String user_id =authBox.read('userid').toString();
    String token =authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('https://travelwin1.com/api/api/get_alltripes_status_favorite/?user_id='+user_id),
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

  static Future<List<TripeFavoriteModel>?> FetchFavoritesTrip() async {
    final GetStorage authBox = GetStorage();
    String userid =authBox.read('userid').toString();
    String token =authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('https://travelwin1.com/api/api/get_tripes_favorites/?id='+userid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      return tripeFavoriteModelFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }


}
