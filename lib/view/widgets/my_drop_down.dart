
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';

import '../../logic/controllers/drop_down_controller.dart';

class MyDropDown extends StatelessWidget {
  const MyDropDown({
    super.key,
    required this.dropDownController,
    required this.publisher,
    this.inRow,
    required List<String> locations,
  }) : _locations = locations;

  final DropDownController dropDownController;
  final List<String> _locations;
  final bool publisher;
  final bool? inRow;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width:inRow!=null?Get.width/2.4: Get.width,
        height: 45.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mainColor)
        ),
        padding:const  EdgeInsets.symmetric(horizontal: 10),
        child: Obx(
              ()=> DropdownButton<String>(

            style: TextStyle(color: mainColor),
            icon: Icon(Icons.keyboard_arrow_down,color: mainColor,),
            underline: Container(),
            iconSize: 29,
            value: dropDownController.value.value,
            onChanged: (String? newValue) {
              dropDownController.changValue(newValue!);
            },
            items: _locations.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: SizedBox(
                    width:inRow !=null?95: !publisher? Get.width-110:Get.width-80,
                    child: Text(location,style: TextStyle(fontSize: 16.sp,color: Colors.grey),)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}