import 'package:get/get.dart';
// import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/logic/controllers/service_controller.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicesController());
  }
}
