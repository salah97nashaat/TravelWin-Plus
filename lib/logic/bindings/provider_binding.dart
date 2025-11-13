import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';

class ProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProviderController());
  }
}
