import 'package:get/instance_manager.dart';
// import 'package:travelwin/logic/controllers/service_controller.dart';
import 'package:travelwin/logic/controllers/service_state_controller.dart';
import 'package:travelwin/logic/controllers/settings_controller.dart';

import '../controllers/main_controller.dart';
import '../controllers/profile_controller.dart';

class MainBininding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(SettingController());
    Get.put(ProfileController(), permanent: true);
    Get.put(ServiceStateController());
    // Get.put(ServicesController());
  }
}
