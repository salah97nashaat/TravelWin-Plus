import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:travelwin/logic/controllers/medicalTourismController.dart';
// import 'package:travelwin/utils/theme.dart';
import 'package:travelwin/view/widgets/tourism_place.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../../helpers/adv/admob_native.dart';
import '../../../models/NewHome.dart';
import '../../../utils/my_string.dart';
// import '../../widgets/normalButton.dart';

class TourismAreas extends StatelessWidget {
  TourismAreas({Key? key}) : super(key: key);
  final MedicalTourismController medicalTourismController =
      MedicalTourismController();
  final Rx<bool> search = Rx(false);
  final Rx<List<States>> searchList = Rx([]);
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Tourism Areas".tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), onPressed: () => Get.back()),
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      body: Column(
        children: [
          // Modern Search Bar
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
              ),
              child: TextFormField(
                onChanged: (val) => _runSearch(val),
                decoration: InputDecoration(
                  hintText: 'Search destinations...'.tr,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h)
                ),
              ),
            ),
          ),

          const AdmobNativeUi(),
          
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: search.value ? searchList.value.length : home.value!.data!.states!.length,
              itemBuilder: (context, index) {
                var state = search.value ? searchList.value[index] : home.value!.data!.states![index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: TourismPlace(states: state, index: index), // Updated TourismPlace from previous step
                );
              },
            )),
          )
        ],
      ),
    );
  }
  void _runSearch(String value) {
  if (value.isEmpty) {
    search.value = false;
    searchList.value = [];
  } else {
    search.value = true;
    String query = value.toLowerCase();
    
    // Arabic Normalization (Handling Alif variations)
    String altQuery = query;
    if (query.contains('ا')) altQuery = query.replaceAll('ا', "أ");
    if (query.contains('أ')) altQuery = query.replaceAll('أ', "ا");

    searchList.value = home.value!.data!.states!.where((element) {
      String nameAr = element.nameAr!;
      String nameEn = element.nameEn!.toLowerCase();
      
      return nameAr.contains(query) || 
             nameAr.contains(altQuery) || 
             nameEn.contains(query);
    }).toList();
  }
}
}