import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.ratingColor,
    required this.rating,
  });

  final Color? ratingColor;
  final num rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ratingColor, borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              size: 12,
              color: Colors.white,
            ),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
