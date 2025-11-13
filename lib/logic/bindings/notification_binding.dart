import 'package:get/instance_manager.dart';
import '../controllers/notification_controller.dart';

class NotificationBininding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
