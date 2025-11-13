
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/view/widgets/ImageUi/imageAssetUi.dart';
import '../../utils/theme.dart';


class CardUi extends StatelessWidget {
   final VoidCallback? onTap;
   final String? image;
   final String? text;
   final TextStyle? textStyle;
   final Color? color;
   final double? width;
   final double? height;

   const CardUi({this.width ,this.height,this.color, this.text,this.textStyle ,this.image ,this.onTap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     SizedBox(
      width: width?? 1.sw ,
      height: height,
      child: Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          color: color?? (Get.isDarkMode ? darkGreyClr : mainColor ),
          child: InkWell(
              onTap:   onTap ,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  if (image!=null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ImageAssetUi(
                        image!,
                        width: 50.sp,
                        height: 50.sp,
                        color: Colors.white,
                  ),
                    ),
                  
                 if (text!=null) Text(
                    text!,
                    style: textStyle?? TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ))),
    );
  }
}
