import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/term_model.dart';
// import '../models/tripe_favorite_model.dart';
// import '../models/tripe_model.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<TermModels>?> fetchTerm() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client
        .get(Uri.parse('https://travelwin1.com/api/api/get_term'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      return termModelsFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
