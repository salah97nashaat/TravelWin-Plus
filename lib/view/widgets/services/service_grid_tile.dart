// import 'package:app/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/service_model.dart';

class ServiceGridTile extends StatelessWidget {
  const ServiceGridTile({super.key, required this.model});
  final ServiceModel model;

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == 'ar';
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(blurRadius: 2, color: Colors.grey)
                  ]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: model.imageUrl == null
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/loading.png'),
                      )
                      : Image.network(model.imageUrl!))),
        ),
        Text(
          (isAr ? model.nameAr : model.nameEn) + "\n",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        )
      ],
    );
  }
}
