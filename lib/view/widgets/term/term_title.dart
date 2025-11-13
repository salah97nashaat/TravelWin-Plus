import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/TicketTerm.dart';

import '../../../utils/theme.dart';

class TermTile extends StatelessWidget {
  final Terms term;
  TermTile(this.term);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      child: Card(
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          shape: Border.all(
            color: mainColor,
          ),
          child: Center(
            child: ListTile(
                title: Text(
                  Get.locale.toString() == "en" ? term.titleEn! : term.titleAr!,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : mainColor,
                  ),
                ),
                subtitle: Text(
                  Get.locale.toString() == "en" ? term.bodyEn! : term.bodyAr!,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : mainColor,
                  ),
                ),
                //CircleAvatar(backgroundImage: NetworkImage(trip.file),),
                onTap: () {
                  //  Get.toNamed(Routes.ViewTripsDetailsScreen);
                }),
          )),
    );
  }
}
