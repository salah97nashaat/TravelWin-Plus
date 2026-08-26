import 'dart:convert';
// import 'dart:math';

// import 'package:app/controllers/service_controller.dart';
// import 'package:app/core/api_wrapper.dart';
// import 'package:app/models/comments_model.dart';
// import 'package:app/models/provider_model.dart';
// import 'package:app/models/state_model.dart';
// import 'package:app/models/service_model.dart';
// import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/comments_model.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/api_wrapper.dart';

import '../../models/service_model.dart';
import 'service_controller.dart';

class ProviderController extends GetxController {
  final RxList<ProviderModel> providers = RxList<ProviderModel>([]);
  var _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  // Future getProvidersByService(ServiceModel service) async {
  //   isLoading(true);
  //   await Future.delayed(const Duration(seconds: 3));
  //   providers.clear();
  //   providers.addAll(List.generate(
  //     5,
  //     (index) => ProviderModel(
  //         id: index + service.id * 10,
  //         serviceId: service.id,
  //         stateId: 0,
  //         nameEn: "${service.nameEn}_provider$index",
  //         nameAr: "${service.nameAr}_provider$index",
  //         long: 28.8 + Random().nextDouble() * (29.2 - 28.8),
  //         lat: 40.9 + Random().nextDouble() * (41.2 - 40.9),
  //         rating: 5 - index),
  //   ));
  //   isLoading(false);
  // }
  @override
  void onReady() {
    super.onReady();
    // A banner can open a provider directly from Home, where the services
    // controller is not necessarily registered.
    if (Get.isRegistered<ServicesController>()) {
      getProviders(Get.find<ServicesController>().service);
    }
  }

  Future<ProviderModel?> getProvider(int id, {int? previousViewsCount}) async {
    var resp = await ApiWrapper.get("/serviceProviders/$id");
    if (resp.statusCode == 200) {
      var provider = jsonDecode(resp.body)['provider'];
      var pp = ProviderModel.fromJson(provider);
      // The detail endpoint records the view, but can return the provider
      // before that increment is reflected in its response.
      if (previousViewsCount != null &&
          (pp.viewsCount == null || pp.viewsCount! <= previousViewsCount)) {
        pp.viewsCount = previousViewsCount + 1;
      }
      final index = providers.indexWhere((item) => item.id == id);
      if (index != -1) {
        pp.isfav = providers[index].isfav;
        providers[index] = pp;
        providers.refresh();
      }
      update();
      return pp;
    }
    return null;
  }

  Future getProviders(ServiceModel service) async {
    _isLoading(true);
    var box = GetStorage();
    var favs = box.read("fav_providers") ?? [];
    // var sc = Get.find<ServicesController>();
    var state = box.read("state");
    providers.clear();
    var resp = await ApiWrapper.get('/serviceProviders?nopaginate=1');
    if (resp.statusCode == 200) {
      // List data;
      // if (jsonDecode(resp.body)['data'] is Map) {
      //   data = jsonDecode(resp.body)['data']['data'];
      // } else {
      //   data = jsonDecode(resp.body)['data'];
      // }
      var data = jsonDecode(resp.body)['data'];
      for (var provider in data) {
        var pp = ProviderModel.fromJson(provider);
        if (pp.stateId == state['id']) {
          providers.add(pp..isfav = favs.contains(provider['id']));
        }
      }
      providers.sort((a, b) => b.rating!.compareTo(a.rating!));
      // print(result);
      // return result;
    }
    _isLoading(false);
    // isLoading(true);
    // ServicesController controller = Get.find();
    // await Future.delayed(const Duration(seconds: 3));
    // var box = GetStorage();
    // var favs = box.read("fav_providers") ?? [];
    // providers.clear();
    // for (ServiceModel service in controller.services) {
    //   providers.addAll(List.generate(
    //     5,
    //     (index) {
    //       var id = index + service.id * 10;
    //       var isFav = favs.contains(id);
    //       var rnd = Random().nextDouble();
    //       return ProviderModel(
    //           id: id,
    //           serviceId: service.id,
    //           stateId: 0,
    //           isfav: isFav,
    //           nameEn: "${service.nameEn}_${"provider".tr}$index",
    //           nameAr: "${service.nameAr}_${"provider".tr}$index",
    //           long: 28.8 + rnd * (29.2 - 28.8),
    //           lat: 40.9 + rnd * (41.2 - 40.9),
    //           rating: 5 - index);
    //     },
    //   ));
  }

  void toggleFav(ProviderModel provider) {
    List<int> currentFavs = getFav();

    // 1. Toggle ID in the list
    if (currentFavs.contains(provider.id)) {
      currentFavs.remove(provider.id);
      provider.isfav = false;
    } else {
      currentFavs.add(provider.id);
      provider.isfav = true;
    }

    // 2. Save to Storage
    GetStorage().write("fav_providers", currentFavs);

    // 3. Update the item inside the RxList to trigger Obx
    int index = providers.indexWhere((p) => p.id == provider.id);
    if (index != -1) {
      providers[index] = provider; // This triggers Rx rebuilds
    }

    // 4. Force global refresh
    providers.refresh();
    update();
  }

  List<int> getFav() {
    var box = GetStorage();
    var rawData = box.read("fav_providers");

    if (rawData == null) return [];

    // Use List<int>.from to safely convert the dynamic list to an integer list
    return List<int>.from(rawData);
  }

  Future addProvider(
      ProviderModel providerModel, String? logoPath, List<String> imgs) async {
    var resp = await ApiWrapper.postFiles(
        '/serviceProviders', providerModel.toJson(), [
      if (logoPath != null) ApiWrapper.fileFromPath("profile", logoPath),
      ...imgs.map((e) => ApiWrapper.fileFromPath("images[]", e))
    ]);

    return resp;
  }

  Future addProviderComment(ProviderModel providerModel, String comment) async {
    var resp = await ApiWrapper.post(
        "/serviceProviders/${providerModel.id}?_method=put",
        {'comment': comment});
    print(resp.body);
    if (resp.statusCode == 200) {
      providerModel.comments.add(CommentModel(body: comment));
    }

    update();
    return resp;
  }

  Future<List<CommentModel>> getProviderComments(
      ProviderModel providerModel) async {
    var resp = await ApiWrapper.get("/serviceProviders/${providerModel.id}");
    var comments = jsonDecode(resp.body)['provider']['comments'];
    return [...comments.map((e) => CommentModel.fromJson(e))];
  }
}
