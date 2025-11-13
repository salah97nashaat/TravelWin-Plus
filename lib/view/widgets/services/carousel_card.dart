import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({super.key, this.imageUrl, this.link});
  final String? imageUrl, link;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), color: Colors.white),
      child: imageUrl != null
          ? InkWell(
              child: Image.network(imageUrl!),
              onTap: () {
                if (link != null) {}
              },
            )
          : null,
    );
  }
}
