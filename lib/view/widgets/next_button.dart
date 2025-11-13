import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextButton extends StatelessWidget {
  NextButton(
      {super.key,
      required this.color,
      required this.fontColor,
      required this.name,
      required this.onTap,
      required this.type});
  final Function() onTap;
  final Color color;
  final Color fontColor;
  final String name;
  final String type;
  @override
  Widget build(BuildContext context) {
    return type == "back"
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: fontColor, width: 1.5))),
            onPressed: onTap,
            child: Text(name,
                style: TextStyle(
                  color: fontColor,
                )))
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            onPressed: onTap,
            child: Text(name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: fontColor,
                )));
  }
}
