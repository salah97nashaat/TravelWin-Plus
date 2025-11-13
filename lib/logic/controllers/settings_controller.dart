import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingController extends GetxController {
  var swithchValue = false.obs;
  var storage = GetStorage();
  var langLocal = Get.locale.toString();
  var number = ''.obs;
  String capitalize(String profileName) {
    return profileName.split(" ").map((name) => name.capitalize).join(" ");
  }

  //Language

  @override
  void onInit() async {
    super.onInit();
    get_whatsapp_number();
    langLocal = await getLanguage;
  }

  void saveLanguage(String lang) async {
    await storage.write("lang", lang);
  }

  Future<String> get getLanguage async {
    return await storage.read("lang") ?? ene;
  }

  void changeLanguage(String typeLang) {
    saveLanguage(typeLang);
    if (langLocal == typeLang) {
      return;
    }
    if (typeLang == ara) {
      langLocal = ara;
      saveLanguage(ara);
    } else {
      langLocal = ene;
      saveLanguage(ene);
    }
    update();
  }

  void get_whatsapp_number() async {
    final GetStorage authBox = GetStorage();
    String token = authBox.read('token').toString();
    try {
      String apiurl =
          "https://travelwin1.com/api/api/get_whatsapp?type=notes"; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responsebody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('--------------------------------------------------------------');
        print(responsebody['numper']);
        print('--------------------------------------------------------------');

        number.value = responsebody['numper'];
        update();
        // if (responsebody['status'] == true) {
        //     return '+905526750481';
        //  return responsebody['numper'];
      } else {
        //   return '+905526750481';
        number.value = '963938685355';
        update();
      }
    } finally {}
  }
}
