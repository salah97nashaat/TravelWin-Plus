import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../const.dart';
import '../../../models/NewHome.dart';
import '../../../utils/theme.dart';

class MyCarsoulSlider extends StatelessWidget {
  MyCarsoulSlider({Key? key, required this.items, required this.height})
      : super(key: key);
  final List<Banners> items;

  final Rx<int> activeIndex = Rx(0);
  final double height;

  setActiveDot(index) {
    activeIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: Get.height * height,
            onPageChanged: (index, reason) {
              setActiveDot(index);
            },
            enableInfiniteScroll: false,
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            autoPlayAnimationDuration: const Duration(seconds: 2),
            autoPlay: true,
            viewportFraction: 1.0,
          ),
          items: items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (item.type == 'banner2') {
                      } else if (item.type == 'link') {
                        launchUrl(Uri.parse(item.link));
                      } else if (item.type == 'tripReservation') {
                        launchWhatsapp(
                            Get.locale == Locale('ar')
                                ? 'مرحبا أود الاستفسار عن ${item.titleAr}'
                                : 'hi i want to ask about ${item.titleEn}',
                            '963999189637');
                      }
                    },
                    child: Container(
                      width: Get.width,
                      height: Get.height * height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(item.image!),
                              fit: BoxFit.fill)),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Obx(
          () => DotsIndicator(
            dotsCount: items.length,
            position: activeIndex.value,
            decorator: DotsDecorator(
                color: Colors.grey.shade400,
                size: Size(Get.width * 0.035, Get.height * 0.012),
                activeSize: Size(
                    Get.width * 0.035, Get.height * 0.012), // Inactive color
                activeColor: mainColor,
                // activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

                spacing: EdgeInsets.symmetric(horizontal: Get.width * 0.002)),
          ),
        )
      ],
    );
  }
}

class ActiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: Get.width * 0.08,
        height: Get.height * 0.015,
        decoration: BoxDecoration(
            color: mainColor,
            //borderRadius: BorderRadius.circular(5),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class InactiveDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          //color: Colors.grey,
          //borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey,
            width: 1.5,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
