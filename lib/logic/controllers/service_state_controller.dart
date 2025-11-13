import 'dart:convert';

// import 'package:app/models/state_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/service_state_model.dart';
import 'package:travelwin/utils/api_wrapper.dart';

class ServiceStateController extends GetxController {
  var _isLoading = false.obs;
  final states = <ServiceStateModel>[].obs;
  late ServiceStateModel _state;

  bool get isLoading => _isLoading.value;

  Future setState(ServiceStateModel s) async {
    _state = s;
    var box = GetStorage();
    await box.write("state", _state.toJson());
    // box.save();
  }

  @override
  void onReady() async {
    _isLoading(true);
    await getStates();
    _isLoading(false);
  }

  ServiceStateModel getState() {
    return _state;
  }

  ServiceStateModel getStateFromStorage() {
    var box = GetStorage();
    _state = ServiceStateModel.fromJson(box.read("state"));

    return _state;
  }

  Future<List<ServiceStateModel>> getStates() async {
    var result = <ServiceStateModel>[];
    var resp = await ApiWrapper.get("/home/states");
    if (resp.statusCode == 200) {
      var states = jsonDecode(resp.body)['data'];
      for (var state in states) {
        result.add(ServiceStateModel.fromJson(state));
      }
      this.states.assignAll(result);
      // print(result);
      return result;
    }

    return [];
  }
}
