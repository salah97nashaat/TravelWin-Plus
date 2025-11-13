// import 'package:app/controllers/provider_controller.dart';
// import 'package:app/core/constants.dart';
// import 'package:app/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:latlong2/latlong.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/service_model.dart';
import 'package:travelwin/utils/constants.dart';

class OnTheMapPage extends StatelessWidget {
  const OnTheMapPage({super.key, required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    ProviderController providersController = Get.find();
    var locale = Get.locale!.languageCode;
    var providers =
        providersController.providers.where((p) => p.serviceId == service.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: inversePrimaryColor,
        foregroundColor: primaryColor,
        title: Text(
          locale == 'ar' ? service.nameAr : service.nameEn,
        ),
        // elevation: 4,
        centerTitle: true,
      ),
      body: FlutterMap(
          options: providers.length == 1
              ? MapOptions(
                  initialCenter: LatLng(
                      providers.first.lat ?? 0, providers.first.long ?? 0),
                  initialZoom: 17,
                )
              : MapOptions(
                  initialCameraFit: CameraFit.coordinates(coordinates: [
                  ...providers
                      .map((element) =>
                          LatLng(element.lat ?? 0, element.long ?? 0))
                      .toList()
                ], padding: const EdgeInsets.all(24.0))),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: [
              ...providers
                  .map((element) => Marker(
                      point: LatLng(element.lat ?? 0, element.long ?? 0),
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.location_pin),
                        color: mainColor2,
                        onPressed: () {
                          Get.dialog(AlertDialog(
                            title: Text(element.nameEn ?? ""),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Ok".tr))
                            ],
                          ));
                        },
                      )))
                  .toList()
            ])
          ]),
    );
  }
}
