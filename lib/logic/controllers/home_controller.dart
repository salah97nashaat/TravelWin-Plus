import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/models/Chats.dart';
import 'package:travelwin/models/FavoriteModel.dart';
// import 'package:travelwin/logic/controllers/profile_controller.dart';
import 'package:travelwin/models/NewHome.dart';
import 'package:travelwin/models/Points.dart';
import 'package:travelwin/models/Ticket.dart';
import 'package:travelwin/models/profile_models.dart';
import 'package:travelwin/services/profile_services.dart';
// import 'package:travelwin/view/screens/home_screen.dart';
import 'dart:convert';

import '../../helpers/helper.dart';
import '../../utils/my_string.dart';

class HomeController extends GetxController {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  var dalyDate = ''.obs;
  var not = ''.obs;
  var number = ''.obs;
  final GetStorage authBox = GetStorage();
  Rx<List<Banners>> homeBanner = Rx([]);
  Rx<List<Banners>> otherBanner = Rx([]);
  final isHomeLoading = true.obs;
  final homeLoadError = false.obs;
  // Obtain shared preferences.

// Save an integer value to 'counter' key.

  @override
  void onInit() async {
    get_whatsapp_number();

    try {
      // Keep the screen safe while the first network response is in flight.
      // On a cold release build this response commonly arrives after HomeScreen
      // has already been built.
      final fetchedHome = await RemoteServices.fetchHome();
      if (fetchedHome != null) {
        home.value = fetchedHome;
        final banners = fetchedHome.data?.banners ?? <Banners>[];
        homeBanner.value = banners
            .where((banner) => banner.placement?.toLowerCase() == 'home')
            .toList();
      } else {
        homeLoadError.value = true;
      }
    } catch (_) {
      homeLoadError.value = true;
    } finally {
      isHomeLoading.value = false;
    }

    // Real-estate banners used the legacy `type: banner2` field. The dynamic
    // banner API now has only `home` and `services` placements.
    otherBanner.value = [];
    RemoteServices.dailyPoint().then((value) {
      BuildContext context = MultiChildRenderObjectElement(Column());
      if (value == 'Added successfully') {
        showSnackBar(
          context,
          'youve earned point'.tr +
              '\n' +
              'Congratulations, youve earned '.tr +
              'the daily'.tr +
              ' points... Try again in 24 hours'.tr,
        );
      }
    });
    medicalTrips.value = (await RemoteServices.fetchMedicalTrips());
    tripModel.value = (await RemoteServices.fetchTrips());
    profile.value = (await RemoteServices.fetchProfile()) ?? Profile();
    favoriteModel.value =
        (await RemoteServices.fetchFavorite()) ?? FavoriteModel();
    properties.value = (await RemoteServices.fetchProperties())!;
    chats.value = (await RemoteServices.fetchChats()) ?? Chats();
    points.value = (await RemoteServices.fetchPoint()) ?? Points();
    whatappnumbers = (await RemoteServices.fetchWhatsApp())!;
    about.value = (await RemoteServices.fetchAbout())!;
    tickets.value = (await RemoteServices.fetchTickets()) ?? Ticket();
    ticketsTerm.value = (await RemoteServices.fetchTicketsTerms())!;
    String formattedDate = formatter.format(now);

    String dalyDate_controller = authBox.read('dalyDate').toString();
    if (dalyDate_controller == formattedDate) {
      p('----------------8888888-----------');
      p(formattedDate);
      p('----------------8888888-----------');
    } else {
      // check_login_day();
      p('--------------------------------------------------------------555555-----------');
      p(dalyDate_controller + '    ' + formattedDate);
      p('----------------555555-----------');
    }
    super.onInit();
  }
  // void check_login_day() async {
  //   final GetStorage authBox = GetStorage();
  //
  //   String user_id = authBox.read('userid').toString();
  //   String token = authBox.read('token').toString();
  //   try {
  //     String apiurl = "$baseUrlApi/check_login_day?user_id="+ user_id; //api url
  //     var response = await http.get(Uri.parse(apiurl), headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //     String formattedDate = formatter.format(now);
  //     authBox.write("dalyDate",formattedDate );
  //     update();
  //     var responsebody = jsonDecode(response.body);
  //     print(responsebody);
  //     if (responsebody['status'] == true) {
  //
  //       Get.snackbar(
  //
  //         'youve earned point'.tr,
  //         'Congratulations, youve earned '.tr+responsebody['message'].toString()+' points... Try again in 24 hours'.tr,
  //
  //         // responsebody['message'],
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     } else {
  //
  //       // Get.snackbar(
  //       //   'failed'.tr,
  //       //   responsebody['message'],
  //       //   snackPosition: SnackPosition.BOTTOM,
  //       //   backgroundColor: Colors.green,
  //       //   colorText: Colors.white,
  //       // );
  //     }
  //   } finally {
  //   }
  // }

  void get_whatsapp_number() async {
    final GetStorage authBox = GetStorage();
    String token = authBox.read('token').toString();
    try {
      String apiurl = "$baseUrlApi/get_whatsapp?type=reservation"; //api url
      var response = await http.get(Uri.parse(apiurl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responsebody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        p('--------------------------------------------------------------');
        p(responsebody['numper']);
        p('--------------------------------------------------------------');

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
