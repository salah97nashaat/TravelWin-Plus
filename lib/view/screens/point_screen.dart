// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/view/widgets/normalButton.dart';
import '../../helpers/adv/admob_banner.dart';
import '../../helpers/adv/admob_manager.dart';
import '../../helpers/helper.dart';
import '../../routes/routes.dart';
import '../../utils/theme.dart';

class PointScreen extends StatelessWidget {
  PointScreen({Key? key}) : super(key: key) {
    // adManager.addAds(false, false, true);
  }

  final AdmobManager adManager = Get.put(AdmobManager());

  //final adManager = AdManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'points and profits'.tr,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leadingWidth: 65.w,
          // leading: InkWell(
          //   onTap: (){
          //     Get.toNamed(Routes.FortuneWheelScreen);
          //   },
          //   child: Padding(
          //     padding: Get.locale == Locale('ar')
          //         ? EdgeInsets.only(right: 15.w, top: 5.h)
          //         : EdgeInsets.only(left: 15.w, top: 5.h),
          //     child: Container(
          //       height: 45,
          //       decoration: BoxDecoration(
          //         color: mainColor2.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(17.5),
          //       ),
          //       child: Center(
          //           child: Padding(
          //               padding: EdgeInsets.symmetric(horizontal: 6.w),
          //               child: Text(
          //                 'wheel of luck'.tr,
          //                 style: TextStyle(color: Colors.black, fontSize: 12.w),
          //                 textAlign: TextAlign.center,
          //               ))),
          //     ),
          //   ),
          // )
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        //  drawer: MyDrawer(),
        bottomNavigationBar: const AdmobBannerUi(),
        body: Column(
          children: [
            Container(
                height: 258.h,
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                ),
                margin: EdgeInsets.fromLTRB(10.sp, 20.sp, 10.sp, 20.sp),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  children: [
                    // Padding(padding: EdgeInsets.all(15)),
                    Image.asset(
                      'assets/images/points.png',
                    ),
                    // SizedBox(height: 20.h,),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 50.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //Center Column contents vertically,
                          children: [
                            Text(
                              "${'Get points'.tr} ${'by watching you'.tr}' ${'For ads .. click to start'.tr}",
                              style: TextStyle(fontSize: 18.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            NormalButton(
                                color: mainColor,
                                fontColor: Colors.white,
                                name: 'start'.tr,
                                onTap: () async {
                                  if (adManager.isLoadingRewardAd.value == true)
                                    return;
                                  p('aa-------------a');
                                  await adManager.loadRewardedAd(context);
                                  // await adManager.showRewardedAd(context);
                                }),
                            // Container(
                            //   width: 120.w,
                            //   child:
                            //
                            //    ElevatedButton(
                            //
                            //       onPressed: () async{
                            //
                            //        if (adManager.isLoadingRewardAd.value==true) return;
                            //             p('aa-------------a');
                            //        await adManager.loadRewardedAd(context);
                            //        // await adManager.showRewardedAd(context);
                            //
                            //
                            //       },
                            //       child:
                            //
                            //      Obx(() {
                            //       if (    adManager.isLoadingRewardAd.value)
                            //       return Center(child: SizedBox(
                            //           width: 20.sp,
                            //           height: 20.sp,
                            //           child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)));
                            //       else {
                            //         return Text(
                            //         'start'.tr,
                            //         style: TextStyle(fontSize: 20.sp ,color: Colors.black),
                            //       );
                            //       }
                            //       })
                            //     ),
                            //
                            //
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(padding: EdgeInsets.all(10)),
                  ],
                )),

            // Obx(() =>
            // Text(adManager.credit.toString())
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   //Center Row contents horizontally,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   //Center Row contents vertically,
            //   children: [
            //     Icon(
            //       Icons.star_border,
            //       color: Colors.yellowAccent,
            //       size: 100.0,
            //     ),
            //     Icon(
            //       Icons.star_border,
            //       color: Colors.yellowAccent,
            //       size: 100.0,
            //     ),
            //     Icon(
            //       Icons.star_border,
            //       color: Colors.yellowAccent,
            //       size: 100.0,
            //     ),
            //   ],
            // ),

            Column(
              children: [
                Text(
                  'Points earned:'.tr,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Obx(
                  () => Text(
                    points.value.data == null
                        ? '0'
                        : points.value.data!.total.toString(),
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
                height: 40.h,
                width: 1.sw,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: NormalButton(
                      color: Colors.white,
                      fontColor: mainColor,
                      name: 'your tickets'.tr,
                      onTap: () {
                        if (token.value != 'null') {
                          Get.toNamed(Routes.ViewTicketScreen);
                        } else {
                          showSnackBar(context, 'Login is required'.tr);
                        }
                      }),
                )),
            SizedBox(
              height: 15.h,
            ),
            SizedBox(
                height: 40.h,
                width: 1.sw,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: NormalButton(
                      color: Colors.white,
                      fontColor: mainColor,
                      name: 'Extra prizes'.tr,
                      onTap: () {
                        Get.toNamed(Routes.ExtraPrizesScreen);
                      }),
                )),
            SizedBox(
              height: 15.h,
            ),
            SizedBox(
                height: 40.h,
                width: 1.sw,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: NormalButton(
                      color: Colors.white,
                      fontColor: mainColor,
                      name: 'Ticket collection conditions'.tr,
                      onTap: () {
                        if (token.value != 'null') {
                          Get.toNamed(Routes.ViewTermScreen);
                        } else {
                          showSnackBar(context, 'Login is required'.tr);
                        }
                      }),
                )),
            //
            // Obx(() {
            //   if (adManager.isLoading.value)
            //     return Center(child: CircularProgressIndicator());
            //   else {
            //     return SizedBox(
            //       // margin: const EdgeInsets.fromLTRB(0,20, 0, 0),
            //       child:
            //       Column(children: [
            //         Padding(padding: EdgeInsets.all(15.sp)),
            //         CarouselSlider(
            //           options: CarouselOptions(
            //               autoPlay: true,
            //               enlargeCenterPage: true,
            //               aspectRatio: 2.0,
            //               onPageChanged: (index, reason) {}),
            //           items: adManager.slideradvertisementList.map((i) {
            //             return Builder(
            //               builder: (BuildContext context) {
            //                 return GestureDetector(
            //                   onTap: () {
            //
            //                   },
            //                   child: Container(
            //                       width: MediaQuery
            //                           .of(context)
            //                           .size
            //                           .width,
            //                       //  margin: EdgeInsets.symmetric(horizontal: 5.0),
            //                       //   decoration: BoxDecoration(
            //                       //     // color:
            //                       //     //     Get.isDarkMode ? darkGreyClr : litmain
            //                       //   ),
            //
            //
            //                       // child: Text(
            //                       //   (adManager.slideradvertisementList
            //                       //       .indexOf(i)+1)
            //                       //       .toString()+"-"+adManager.slideradvertisementList.length.toString(),
            //                       //   style: TextStyle(fontSize: 18.0,color: Colors.orange),
            //                       // ),
            //                       decoration: BoxDecoration(
            //                           image: DecorationImage(
            //                               image: NetworkImage('$i',),
            //                               fit: BoxFit.contain)
            //                       )
            //
            //
            //                   ),
            //                 );
            //               },
            //             );
            //           }).toList(),
            //         ),
            //
            //       ],)
            //       ,
            //     );
            //   }
            //
            //   //-----------------------------
            // }),
            Padding(padding: EdgeInsets.all(5)),
            //         Obx(
            //           () => adManager.type.value == 'text'
            //               ? Container(
            //                   margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            //                   child: Card(
            //                     color: Get.isDarkMode ? darkGreyClr : litmain,
            //                     child: Column(children: [
            //                       Padding(padding: EdgeInsets.all(5)),
            //                       Text('The date of the withdrawal'.tr),
            //                       Text('of'.tr),
            //                       Text('the golden lira'.tr),
            //                       Obx(
            //                         () =>
            //                             Text(adManager.Withdrawaldate.value.toString()),
            //                       ),
            //                       Padding(padding: EdgeInsets.all(5)),
            //                     ]),
            //                   ),
            //                 )
            //               : adManager.type.value == 'image'
            //           ? Container(
            //                   margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            //                   child: Image.network(
            //                       'https://travelwin1.com/imges/win/win.png'))
            //           :Container(
            //         margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            //   height: 200,
            //   child: GetBuilder<PlayVideoController>(
            //       init: PlayVideoController(),
            //       builder: (controller) =>
            //           Container(
            //           child: controller.chewieController != null &&
            //               controller.chewieController!.videoPlayerController
            //                   .value.isInitialized
            //               ? Chewie(controller: controller.chewieController!)
            //               : Column(
            //             // mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               CircularProgressIndicator(),
            //               // SizedBox(height: 10,),
            //               Text('Loding')
            //             ],
            //           ))),
            // ),
            //         ),
          ],
        ));
  }
}
