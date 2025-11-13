import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';

class TourProgramsScreen extends StatelessWidget {
  TourProgramsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          elevation: 0,
          title: Center(child: Text('Tour Programs'.tr)),
          actions: [
            IconButton(
              onPressed: () {
                Get.offAllNamed(Routes.mainScreen);
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //   drawer: MyDrawer(),
        //    bottomNavigationBar:
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Get.isDarkMode ? darkGreyClr : mainColor,
              child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.ChooseState);
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      SizedBox(
                          height: 50.0,
                          width: 50.0, // fixed width and height
                          child: Image.asset(
                            'assets/images/holiday.png',
                            color: Colors.white,
                          )),
                      SizedBox(height: 10),
                      Text(
                        'Tourist areas'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            ),
          ],
        )));
  }
}
