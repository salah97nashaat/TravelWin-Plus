// import 'package:app/core/constants.dart';
// import 'package:app/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/service_model.dart';

class ServiceListTile extends StatelessWidget {
  const ServiceListTile(
      {super.key, required this.service, this.selected = false});
  final ServiceModel service;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var appBarForeColor1 = const Color(0xFFCD2032);
    var appBarForeColor2 = Colors.black;
    var isAr = Get.locale!.languageCode == "ar";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
            color: selected ? appBarForeColor1 : null,
            border: Border.all(
              color: appBarForeColor1,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          isAr ? service.nameAr : service.nameEn,
          style: TextStyle(color: selected ? Colors.white : appBarForeColor2),
        ),
      ),
    );
  }
}
