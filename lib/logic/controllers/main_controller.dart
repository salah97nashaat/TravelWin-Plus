import 'package:get/get.dart';
import 'package:travelwin/view/screens/activities/activities_Screen.dart';

import 'package:travelwin/view/screens/home_screen.dart';
import 'package:travelwin/view/screens/messeges/messeges.dart';
import 'package:travelwin/view/screens/real%20state/real_state.dart';
import 'package:travelwin/view/screens/services/service_chooser.dart';
import 'package:travelwin/view/screens/twa/twa_screen.dart';

import 'service_controller.dart';

// import '../../view/screens/point_screen.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;
  final ServicesController servicesController = Get.put(ServicesController());
  var tabs = [
    HomeScreen(),
    // StateChooser(),
    ServiceChooser(),
    TWAScreen(),
    // ActivitiesScreen(),
    // RealState(),
    Messeges(),
  ].obs;

  var title = [
    "Travel Win",
    "Notifications".tr,
    'Favorite'.tr,
    'Other Services'.tr,
    "Settings".tr,
  ].obs;
}
