import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BookMarkWidget extends StatelessWidget {
  const BookMarkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset('assets/images/bookmark.svg',
            colorFilter:
                ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),
            height: 28.h),
        Positioned(
            top: 7,
            right: 8,
            child: SvgPicture.asset(
              'assets/images/save-instagram 1.svg',
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 15.h,
            )),
      ],
    );
  }
}
