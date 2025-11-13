import 'package:get/state_manager.dart';

import '../../models/takit_model.dart';

import '../../services/ticket_services.dart';

class TicketController extends GetxController {
  var isLoading = true.obs;
  var ticketList = <TicketModels>[].obs;

  @override
  void onInit() {
    FetchTicket();

    super.onInit();
  }

  void FetchTicket() async {
    try {
      isLoading(true);
      var ticket = await RemoteServices.fetchTicket();
      if (ticket != null) {
        ticketList.value = ticket;
      }
    } finally {
      isLoading(false);
    }
  }

  void AddTicket() async {
    try {
      isLoading(true);
      var ticket = await RemoteServices.AddTicket();
      if (ticket != null) {
        ticketList.value = ticket;
        update();
      }
    } finally {
      isLoading(false);
      FetchTicket();
    }
  }
}
