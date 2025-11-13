import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalButton extends StatelessWidget {
  NormalButton(
      {Key? key,
      required this.color,
      required this.fontColor,
      required this.name,
      required this.onTap})
      : super(key: key);
  final Function() onTap;
  final String name;
  final Color color;
  final Color fontColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32.h,
        width: 120.w,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: fontColor)),
        child: Center(
            child: Text(
          name,
          style: TextStyle(
              color: fontColor, fontSize: 12.w, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
