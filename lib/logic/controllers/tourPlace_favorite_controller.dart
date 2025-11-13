import 'package:get/get.dart';

// import '../../models/TourPlace_model.dart';
import '../../models/tourPlace_favorite_model.dart';
import '../../services/tourPlace_services.dart';

class TourPlaceFavoriteController extends GetxController {
  var isLoading = true.obs;
  var tourPlaceList = <TourPlaceFavoriteModel>[].obs;
  var id = <String>[].obs;
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    //id.value  =argumentData[0]['id'];stateid, String typeid
    fetchTourPlaceFavorite();
    super.onInit();
  }

  void fetchTourPlaceFavorite() async {
    try {
      isLoading(true);
      var tourPlace = await RemoteServices.GetTourPlaceFavorite();
      if (tourPlace != null) {
        tourPlaceList.value = tourPlace;
        update();
      }
    } finally {
      isLoading(false);
    }
  }
}
