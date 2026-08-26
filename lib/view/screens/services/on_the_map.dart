// import 'package:app/controllers/provider_controller.dart';
// import 'package:app/core/constants.dart';
// import 'package:app/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    
    // Convert to list to avoid repeated filtering
    var providers = providersController.providers
        .where((p) => p.serviceId == service.id)
        .toList();

    // Calculate center: Use the first provider's location as the starting view
    // If list is empty, default to a safe coordinate (e.g., 0,0 or a city center)
    LatLng initialCenter = providers.isNotEmpty
        ? LatLng(providers.first.lat ?? 0, providers.first.long ?? 0)
        : const LatLng(41.0082, 28.9784); // Default to Istanbul

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          locale == 'ar' ? service.nameAr : service.nameEn,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 13, // Slightly zoomed out to see more markers
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.travelwin1.travelwin',
          ),
          MarkerLayer(
            markers: providers.map((p) {
              return Marker(
                point: LatLng(p.lat ?? 0, p.long ?? 0),
                width: 60.w,
                height: 60.w,
                child: GestureDetector(
                  onTap: () {
                    // Show a quick info snackbar or navigate to details
                    Get.snackbar(
                      locale == 'ar' ? p.nameAr! : p.nameEn!,
                      locale == 'ar' ? p.addressAr! : p.addressEn!,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      margin: EdgeInsets.all(20.w),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: mainColor2, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.location_pin, 
                          color: mainColor2, 
                          size: 30.sp
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}