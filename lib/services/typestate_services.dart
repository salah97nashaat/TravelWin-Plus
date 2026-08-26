import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';
// import '../models/slider_model.dart';
import '../models/type_state_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<TypeState>?> getTypeState(String id) async {
    final GetStorage authBox = GetStorage();
    print("id=       " + id);
    String token = authBox.read('token').toString();
    // var response = await http
    //     .get(Uri.parse('http://host233.aya.sy/mobtech/get_sliders.php'));
    var response = await http.get(
        Uri.parse('$baseUrlApi/get_type_state/?id=' + id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = response.body;
      return typeStateFromJson(jsonData);
    } else {
      return throw Exception("Failed to load product");
    }
  }
}
