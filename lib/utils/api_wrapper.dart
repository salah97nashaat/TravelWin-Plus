import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:travelwin/utils/my_string.dart';
// import 'package:http/http.dart';

class ApiWrapper {
  // static const String baseUrl = "http://10.0.2.2:8080/api";
  // static const String baseUrl = "http://192.168.43.75:8000/api";
  // static const String baseUrl = "http://localhost:8000/api";
  // static const String baseUrl =
  //     "https://travelwin1.com/new-travelwin/public/api";
  static String? _token = token.value;
  // static String? token = "1|kJKhVj6xACpm8eMHrDfPJNgfbbGkcr3Y5ALmXakFe030c756";
  // static String? token = "4|gJlGC98HXOpkbKOejINQzn4GpDbCUuLtVEPOlAUFbbe24607";
  static Future get(String url) async {
    var headers = {
      if (_token != null) ...{'Authorization': 'Bearer $_token'},
      "Accept": "application/json"
    };
    return await http.get(Uri.parse(baseUrl + url), headers: headers);
  }

  static Future<http.Response> post(
      String url, Map<String, dynamic> body) async {
    var headers = {
      if (_token != null) ...{'Authorization': 'Bearer $_token'},
      "Accept": "application/json"
    };

    return await http.post(Uri.parse(baseUrl + url),
        headers: headers, body: body);
  }

  static Future<http.StreamedResponse> postFiles(String url,
      Map<String, String> body, List<http.MultipartFile> files) async {
    var headers = {
      if (_token != null) ...{'Authorization': 'Bearer $_token'},
      "Content-type": "multipart/form-data",
      "Accept": "application/json"
    };
    var req = http.MultipartRequest("post", Uri.parse(baseUrl + url));
    req.fields.addAll(body);
    req.files.addAll(files);
    req.headers.addAll(headers);
    return await req.send();
    // return await http.post(Uri.parse(baseUrl + url),
    //     headers: headers, body: body);
  }

  static http.MultipartFile fileFromPath(String field, String path) {
    var file = File(path);
    // var data = await File(path).readAsBytes();
    var name = file.path.split('/').last;
    return http.MultipartFile(
        field, file.readAsBytes().asStream(), file.lengthSync(),
        filename: name);
  }
}
