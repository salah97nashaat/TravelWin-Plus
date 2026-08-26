import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:travelwin/models/activity_model.dart';

import '../../services/profile_services.dart';

class ActivitiesController extends GetxController {
  var isLoading = true.obs;
  var hasLoadError = false.obs;

  // Your 3 requested categories
  var activeActivities = <ActivityModel>[].obs; // status: open
  var commonActivities = <ActivityModel>[].obs; // status: soon
  var finishedActivities = <ActivityModel>[].obs; // status: closed

  @override
  void onInit() {
    getActivities();
    super.onInit();
  }

  void getActivities() async {
    try {
      isLoading(true);
      hasLoadError(false);
      final activities = await RemoteServices.fetchActivities();
      if (activities == null) {
        hasLoadError(true);
        return;
      }

      // The API has returned statuses with different casing in production.
      // Normalize them so valid activities are never omitted from every section.
      activeActivities.value =
          activities.where((activity) => activity.status == 'open').toList();
      commonActivities.value =
          activities.where((activity) => activity.status == 'soon').toList();
      finishedActivities.value =
          activities.where((activity) => activity.status == 'closed').toList();

      final categorizedCount = activeActivities.length +
          commonActivities.length +
          finishedActivities.length;
      if (categorizedCount != activities.length) {
        commonActivities.addAll(activities.where((activity) =>
            !activeActivities.contains(activity) &&
            !commonActivities.contains(activity) &&
            !finishedActivities.contains(activity)));
      }
    } catch (_) {
      hasLoadError(true);
    } finally {
      isLoading(false);
    }
  }
}
