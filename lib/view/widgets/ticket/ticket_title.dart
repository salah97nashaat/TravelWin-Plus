import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/takit_model.dart';
import '../../../utils/theme.dart';

class TicketTile extends StatelessWidget {
  final TicketModels ticket;
  final int counter;

  final int max;

  TicketTile(this.ticket, this.counter, this.max);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Center(
            child: ListTile(
                title: counter >= max
                    ? Text(
                        'Ticket Number'.tr +
                            " " +
                            (counter + 1).toString() +
                            ' :' +
                            (Get.locale?.languageCode == 'ar' ? 'فارغ' : ' Empty'),
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr2,
                        ),
                      )
                    : Text(
                        'Ticket Number'.tr +
                            " " +
                            (counter + 1).toString() +
                            ' :' +
                            ticket.id.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr2,
                        ),
                      ),
                subtitle: counter >= max
                    ? Text(
                        '',
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr2,
                        ),
                      )
                    : Text(
                        'Date'.tr +
                            " :" +
                            '${ticket.createdAt.day}-${ticket.createdAt.month}-${ticket.createdAt.year} ${ticket.createdAt.hour}:${ticket.createdAt.minute}:${ticket.createdAt.second}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr2,
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
