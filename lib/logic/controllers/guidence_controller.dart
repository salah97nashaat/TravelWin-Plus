import 'package:dio/dio.dart';
import 'package:get/state_manager.dart';

// import '../../models/profile_models.dart';
import '../../services/profile_services.dart';
import '../../utils/my_string.dart';

class GuidenceController extends GetxController {
  @override
  void onInit() {
    fetchGuidence();
    super.onInit();
  }

  Future fetchGuidence() async {
    try {
      guidence.value = (await RemoteServices.fetchGuidences())!;
      update();
    } finally {}
  }

  Future<String> reserveGuidence(id, startDate, endDate) async {
    try {
      update();
      return (await RemoteServices.reserveGuidences(id, startDate, endDate));
    } finally {}
  }

  Future<Response> becameGuidence(
      placesAR,
      placesEN,
      languageAR,
      languageEN,
      bioAR,
      bioEN,
      salary,
      imageId,
      license,
      car,
      licenseImage,
      nationality) async {
    update();
    return await RemoteServices.becameGuidence(
        placesAR,
        placesEN,
        languageAR,
        languageEN,
        bioAR,
        bioEN,
        salary,
        imageId,
        license,
        car,
        licenseImage,
        nationality);
  }
}
