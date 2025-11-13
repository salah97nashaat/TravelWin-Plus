import 'package:flutter/material.dart';

class ProviderAvatar extends StatelessWidget {
  const ProviderAvatar(
      {super.key, required this.rating, this.radius, this.imageUrl});

  final num rating;
  final double? radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var isFramed = rating >= 4;

    return Stack(
      children: [
        SizedBox(
          width: radius! * 2,
          height: radius! * 2,
          child: isFramed
              ? Image.asset(
                  rating == 5
                      ? "assets/gold_frame.png"
                      : "assets/silver_frame.png",
                  fit: BoxFit.contain,
                )
              : null,
        ),
        Padding(
          padding: EdgeInsets.all(radius! * 0.25),
          child: CircleAvatar(
            radius: radius! * 0.75,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          ),
        ),
      ],
    );
  }
}
