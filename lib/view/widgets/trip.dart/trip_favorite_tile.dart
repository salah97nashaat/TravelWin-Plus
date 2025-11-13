import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/routes/routes.dart';

import '../../../models/tripe_favorite_model.dart';
import '../../../utils/theme.dart';

class TripFavoriteTile extends StatelessWidget {
  final TripeFavoriteModel trip;
  const TripFavoriteTile(this.trip);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Center(
            child: ListTile(
                title: Text(Get.locale.toString()=="en" ? trip.to :trip.toAr,
                  style: TextStyle(fontSize: 20,   color: Get.isDarkMode
                      ? Colors.white
                      : darkGreyClr2,),),
                trailing: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(trip.file), fit: BoxFit.fill),
                  ),
                ),
                onTap: () {
                //  Get.toNamed(Routes.ViewTripsDetailsScreen);
                  Get.toNamed(Routes.ViewFavoriteTripsDetailsScreen, arguments: [
                    {
                      "id": trip.id.toString(),
                      "to":trip.to.toString(),
                      "from":trip.from.toString(),
                      "type":trip.type.toString(),
                      "to_ar":trip.toAr.toString(),
                      "from_ar":trip.fromAr.toString(),
                      "type_ar":trip.typeAr.toString(),
                      "favorites_id":trip.favoritesId.toString(),

             //         Get.locale.toString()=="en" ? trip.to.toString() :trip.to_ar.toString()
                      "date":
                      '${trip.date.day}-${trip.date.month}-${trip.date.year}',

                      //trip.date.toString(),
                      "duration":trip.duration.toString(),
                    },
                  ]);
print(Get.locale);
                }),
          )),
    );
  }
}
