import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'bookmark_widget.dart';

class PlacesWidget extends StatelessWidget {
  const PlacesWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.rate,
      required this.space});
  final String image;
  final String name;
  final String space;
  final String rate;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 167.w,
      height: 200.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 0),
              spreadRadius: 1,
              blurRadius: 2,
            )
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Stack(
            children: [
              Container(
                width: 147.w,
                height: 120.h,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
              Positioned(left: 5, top: 5, child: BookMarkWidget()),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            name,
            style: TextStyle(
              color: Colors.black54,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.h,
          ),
          SmoothStarRating(
            allowHalfRating: true,
            defaultIconData: Icons.star_border_rounded,
            filledIconData: Icons.star_rate_rounded,
            halfFilledIconData: Icons.star_half_rounded,
            starCount: 5,
            rating: rate.toString() != 'null' ? double.parse(rate) : 0,
            size: 25.0,
            color: Color(0xffFABF35),
            borderColor: Color(0xffFABF35),
          ),
        ],
      ),
    );
  }
}
