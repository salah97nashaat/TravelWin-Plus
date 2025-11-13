import 'package:get/state_manager.dart';
import '../../models/term_model.dart';
import '../../services/term_services.dart';

class TermController extends GetxController {
  var isLoading = true.obs;
  var termList = <TermModels>[].obs;


  @override
  void onInit() {
    fetchterms();

    super.onInit();
  }

  void fetchterms() async {
    try {
      isLoading(true);
      var terms = await RemoteServices.fetchTerm();
      if (terms != null) {
        termList.value = terms;
      }
    } finally {
      isLoading(false);
    }
  }

}
