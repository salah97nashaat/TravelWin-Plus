import 'package:get/state_manager.dart';
import 'package:travelwin/models/profile_models.dart';

import '../../services/profile_services.dart';
import '../../utils/my_string.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var displayUserName = ''.obs;
  var displayUserEmail = ''.obs;
  var displayUserMobile = ''.obs;
  var displayUserAge = ''.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    try {
      isLoading(true);
      profile.value = (await RemoteServices.fetchProfile()) ?? Profile();
      update();
    } finally {
      isLoading(false);
    }
  }
}
