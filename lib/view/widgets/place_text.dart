import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/theme.dart';

class PlacesText extends StatelessWidget {
  const PlacesText({
    super.key,
    required this.name,
    required this.status
  });
  final String name;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        name,
        style: TextStyle(
            color:status? mainColor:Colors.grey,
            fontSize: 18.w
        ),
      ),
    );
  }
}
