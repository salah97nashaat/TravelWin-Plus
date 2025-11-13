import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/TourPlace_model.dart';
// import '../models/slider_model.dart';
import '../models/tourPlace_favorite_model.dart';
// import '../models/type_state_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<TourPlace>?> getTourPlace(
      String stateid, String typeid) async {
    final GetStorage authBox = GetStorage();
    String user_id = authBox.read('userid').toString();
    String token = authBox.read('token').toString();
    var response = await http.get(
        Uri.parse('https://travelwin1.com/api/api/get_tourplace?stateid=' +
            stateid +
            '&typeid=' +
            typeid +
            '&user_id=' +
            user_id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = response.body;
      return tourPlaceFromJson(jsonData);
    } else {
      return throw Exception("Failed to load product");
    }
  }

  static Future<List<TourPlaceFavoriteModel>?> GetTourPlaceFavorite() async {
    final GetStorage authBox = GetStorage();
    String token = authBox.read('token').toString();
    String userid = authBox.read('userid').toString();
    var response = await http.get(
        Uri.parse('https://travelwin1.com/api/api/get_tourplace_favorite/?id=' +
            userid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = response.body;
      return tourPlaceFavoriteModelFromJson(jsonData);
    } else {
      return throw Exception("Failed to load product");
    }
  }
}
