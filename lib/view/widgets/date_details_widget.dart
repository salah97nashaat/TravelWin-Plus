
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/theme.dart';

class DateDetailsWidget extends StatelessWidget {
  const DateDetailsWidget({
    super.key,
    required this.from,
    required this.name,
    required this.width
  });

  final String from;
  final String name;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: mainColor,
              fontSize: 15.w,
              fontWeight: FontWeight.w500,
            ),
          ),
          //SizedBox(width: 45.w,),
          Column(

            children: [
              Text(from),
              SizedBox(
                width: width,
                child: Divider(
                  color: Colors.grey.withOpacity(0.35),
                  thickness: 1,
                ),
              ),
            ],
          ),
        ],),
    );
  }
}