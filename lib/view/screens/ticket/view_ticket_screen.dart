import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/normalButton.dart';
import '../../../helpers/helper.dart';
import '../../../logic/controllers/ticket_controller.dart';
import '../../../helpers/adv/admob_banner.dart';
// import '../../../routes/routes.dart';
import '../../../utils/theme.dart';

class ViewTicketScreen extends StatelessWidget {
  final TicketController ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Ticket".tr,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Transform.flip(
                  flipX: Get.locale == Locale('ar') ? false : true,
                  child: SvgPicture.asset('assets/images/back.svg'))),
          SizedBox(
            width: 25.w,
          ),
        ],
        // leading: IconButton(
        //   onPressed: () { Get.offAllNamed(Routes.mainScreen);           },
        //   icon: Icon(Icons.home),
        // ),
      ),
      backgroundColor:
          Get.isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
      // drawer: MyDrawer(),
      bottomNavigationBar: const AdmobBannerUi(),
      body: Column(
        children: [
          Obx(() => tickets.value.tickets == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemCount: 10,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10.h,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        height: 50,
                        child: Container(
                            decoration: BoxDecoration(
                                color: index >= tickets.value.tickets!.length
                                    ? mainColor.withOpacity(0.2)
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            // color: Get.isDarkMode ? darkGreyClr : Colors.white,

                            child: Center(
                              child: index >= tickets.value.tickets!.length
                                  ? Text(
                                      'Empty'.tr,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : darkGreyClr2,
                                      ),
                                    )
                                  : Text(
                                      'Ticket Number'.tr +
                                          ' : ' +
                                          tickets.value.tickets![index]
                                              .ticketNumber
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.white,
                                      ),
                                    ),
                            ))
                        //     ListTile(
                        //   title:
                        //   index >= ticketController.ticketList.length
                        //       ? Text(
                        //           'Ticket Number'.tr +
                        //               " " +
                        //               (index + 1).toString() +
                        //               ' :' +
                        //               'فارغ',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             color: Get.isDarkMode
                        //                 ? Colors.white
                        //                 : darkGreyClr2,
                        //           ),
                        //         )
                        //       : Text(
                        //           'Ticket Number'.tr +
                        //               " " +
                        //               (index + 1).toString() +
                        //               ' :' +
                        //               ticketController
                        //                   .ticketList[index].code
                        //                   .toString(),
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             color: Get.isDarkMode
                        //                 ? Colors.white
                        //                 : darkGreyClr2,
                        //           ),
                        //         ),
                        //   // subtitle:
                        //   //     index >= ticketController.ticketList.length
                        //   //         ? Text(
                        //   //             '',
                        //   //             style: TextStyle(
                        //   //               fontSize: 18,
                        //   //               color: Get.isDarkMode
                        //   //                   ? Colors.white
                        //   //                   : darkGreyClr2,
                        //   //             ),
                        //   //           )
                        //   //         : Text(
                        //   //             'Date'.tr +
                        //   //                 " :" +
                        //   //                 '${ticketController.ticketList[index].createdAt.day}-${ticketController.ticketList[index].createdAt.month}-${ticketController.ticketList[index].createdAt.year} ${ticketController.ticketList[index].createdAt.hour}:${ticketController.ticketList[index].createdAt.minute}:${ticketController.ticketList[index].createdAt.second}',
                        //   //             style: TextStyle(
                        //   //               fontSize: 18,
                        //   //               color: Get.isDarkMode
                        //   //                   ? Colors.white
                        //   //                   : darkGreyClr2,
                        //   //             ),
                        //   //           ),
                        // ))),

                        );

                    // return TicketTile(
                    //     index  >= ticketController.ticketList.length
                    //         ? ticketController.ticketList[0]
                    //         : ticketController.ticketList[index],
                    //     index,
                    //     ticketController.ticketList.length);
                  })),
          SizedBox(
            height: 20.h,
          ),
          Obx(
            () => tickets.value.tickets!.length < 10
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Container(
                      //margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      height: 50,
                      width: Get.width,
                      child: NormalButton(
                        color: Colors.white,
                        fontColor: mainColor,
                        onTap: () {
                          if (showLoginScreenIfNotLogin) {
                            return;
                          }
                          Get.defaultDialog(
                            title: "Buying a Ticket".tr,
                            titleStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            middleText: 'Do you want to buy a ticket'.tr,
                            middleTextStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white,
                            radius: 10,
                            textCancel: "No".tr,
                            cancelTextColor: mainColor,
                            textConfirm: "Yes".tr,
                            confirmTextColor: Colors.white,
                            onCancel: () {
                              // Navigator.pop(context);
                            },
                            onConfirm: () async {
                              await RemoteServices.addTicket()
                                  .then((value) async {
                                if (value == 'Added successfully') {
                                  showSnackBar(
                                      context, 'Added successfully'.tr);
                                  tickets.value =
                                      (await RemoteServices.fetchTickets())!;
                                  Navigator.pop(context);
                                } else {
                                  showSnackBar(context, value.toString().tr);
                                  Navigator.pop(context);
                                }
                              });
                            },
                            buttonColor: Get.isDarkMode ? pinkClr : mainColor,
                          );
                        },
                        name: 'Buying a ticket'.tr,
                      ),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //       backgroundColor: MaterialStatePropertyAll<Color>(
                      //           Get.isDarkMode ? darkGreyClr : mainColor),
                      //       shape:
                      //       MaterialStateProperty.all<RoundedRectangleBorder>(
                      //           RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(18.0),
                      //             // side: BorderSide(color: Colors.red)
                      //           ))),
                      //   onPressed: ()async{
                      //
                      //     // ticketController.FetchTicket();
                      //   },
                      //   child: Text(),
                      // ),
                    ),
                  )
                : Text(''),
          ),
        ],
      ),
    );
  }
}
