// import 'package:app/models/state_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/service_state_model.dart';

class StateGridTile extends StatelessWidget {
  const StateGridTile({super.key, required this.model});
  final ServiceStateModel model;

  @override
  Widget build(BuildContext context) {
    var locale = Get.locale!.languageCode;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[400],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(children: [
          const FlutterLogo(
            size: 200,
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      locale == "ar" ? model.nameAr ?? "" : model.nameEn ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ))))
        ]),
      ),
    );
  }
}
