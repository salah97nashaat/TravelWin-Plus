import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/NewHome.dart';
import 'package:travelwin/models/service_model.dart';
import 'package:travelwin/models/service_state_model.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/api_wrapper.dart';

import '../../view/screens/services/state_chooser.dart';
import 'service_state_controller.dart';
// import 'package:http/http.dart' as http;

class ServicesController extends GetxController {
  final _service = ServiceModel(id: 0).obs;
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  ServiceModel get service => _service.value;
  final services = <ServiceModel>[].obs;
  final banners = <Banners>[].obs;

  void setService(ServiceModel service) {
    _service.value = service;
  }

  Future getData() async {
    _isLoading(true);
    await getBanners();
    _isLoading(false);
  }

  @override
  onReady() {
    getData();
  }

  // var isLoading = false.obs;
  Future getServices() async {
    _isLoading(true);
    var box = GetStorage();
    var data = box.read("state");
    // var data = null;
    late ServiceStateModel state;
    // ServiceStateModel? state = null;
    if (data == null) {
      await Get.to(
          () => StateChooser(
                onStateChoosen: (e) {
                  state = e;
                  Get.back();
                },
              ),
          binding: BindingsBuilder.put(() => ServiceStateController()));
    } else {
      state = ServiceStateModel.fromJson(data);
    }
    // state = ServiceStateModel.fromJson(box.read("state"));
    print(state);
    var resp = await ApiWrapper.get("/services?stateid=${state.id}&nonempty=1");
    if (resp.statusCode == 200) {
      var respServices = jsonDecode(resp.body)['services'];
      services.clear();
      for (var service in respServices) {
        services.add(ServiceModel.fromJson(service));
      }
    } else {
      print(resp.body);
    }
    _isLoading(false);
  }

  Future<List<Banners>> getBanners() async {
    // Keep this in sync with Home. The previous ApiWrapper request used a
    // different token source and `/home/`, so service banners could be empty
    // even when Home displayed them.
    final home = await RemoteServices.fetchHome();
    final serviceBanners = (home?.data?.banners ?? <Banners>[])
        .where((banner) => banner.placement == 'services')
        .toList();
    banners.assignAll(serviceBanners);
    return serviceBanners;
  }
}
