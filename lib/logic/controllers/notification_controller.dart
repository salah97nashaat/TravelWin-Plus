import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/utils/my_string.dart';

import '../../models/notification_model.dart';

import '../../services/notification_services.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var notificationlist = <NotificationModels>[].obs;
  final GetStorage authBox = GetStorage();
   @override
  void onInit() {

    fetchNotifications(authBox.read('userid').toString());
    super.onInit();
  }

  void fetchNotifications(String id) async {
    try {
      isLoading(true);
       notification.value = (await RemoteServices.fetchNotifications(id))!;
      // if (notifications != null) {
      //   notificationlist.value = notifications;
      // }
    } finally {
      isLoading(false);
    }
  }
}
