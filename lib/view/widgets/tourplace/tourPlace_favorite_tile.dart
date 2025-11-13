import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/routes/routes.dart';

import '../../../models/tourPlace_favorite_model.dart';
import '../../../utils/theme.dart';

class TourPlacefavoriteTile extends StatelessWidget {
  final TourPlaceFavoriteModel tourPlace;
  const TourPlacefavoriteTile(this.tourPlace);

  @override
  Widget build(BuildContext context) {
    // return Card(
    //     child: ListTile(
    //         title: Text(Get.locale.toString()=="en" ? tourPlace.name :tourPlace.nameAr),
    //         trailing: CircleAvatar(backgroundImage: NetworkImage(tourPlace.file)),
    //         onTap: () {
    //           print("ViewTourPlaceFavoriteDetailsScreen.id     =   "+tourPlace.name.toString());
    //         //  Get.toNamed(Routes.ViewTripsDetailsScreen);
    //           Get.toNamed(Routes.ViewTourPlaceFavoriteDetailsScreen, arguments: [
    //             {
    //               "id": tourPlace.id.toString(),
    //               "name":tourPlace.name.toString(),
    //               "name_ar":tourPlace.nameAr.toString(),
    //               "notes":tourPlace.notes.toString(),
    //               "notes_ar":tourPlace.notesAr.toString(),
    //               "lat":tourPlace.lat.toString(),
    //               "longitude":tourPlace.longitude.toString(),
    //               "favorites_id":tourPlace.favoritesId.toString(),
    //             },
    //           ]);
    //         }));
    return Container(
      height: 100,
      child: Card(
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Center(
            child: ListTile(
                title: Text(
                    Get.locale.toString() == "en"
                        ? tourPlace.name
                        : tourPlace.nameAr,
                    style: TextStyle(
                      fontSize: 20,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr2,
                    )),
                // trailing:                    CircleAvatar(backgroundImage: NetworkImage(tourPlace.file)),

                trailing: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(tourPlace.file), fit: BoxFit.fill),
                  ),
                ),
                onTap: () {
                  Get.toNamed(Routes.ViewTourPlaceFavoriteDetailsScreen,
                      arguments: [
                        {
                          "id": tourPlace.id.toString(),
                          "name": tourPlace.name.toString(),
                          "name_ar": tourPlace.nameAr.toString(),
                          "notes": tourPlace.notes.toString(),
                          "notes_ar": tourPlace.notesAr.toString(),
                          "lat": tourPlace.lat.toString(),
                          "longitude": tourPlace.longitude.toString(),
                          "favorites_id": tourPlace.favoritesId.toString(),
                        },
                      ]);
                }),
          )),
    );
  }
}
