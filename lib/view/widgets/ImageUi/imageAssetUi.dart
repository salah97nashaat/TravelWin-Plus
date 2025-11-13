import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageAssetUi extends StatelessWidget {
  final String image;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageAssetUi(this.image,
      {this.fit, this.color, this.width, this.height, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.endsWith('.svg')
        ? SvgPicture.asset(
            image,
            width: width,
            height: height,
            // colorFilter: color==null? null:  ColorFilter.mode(color!, BlendMode.color)  ,
            // color: color,
            colorFilter: color == null
                ? null
                : ColorFilter.mode(color!, BlendMode.srcIn),
            fit: fit ?? BoxFit.contain,
          )
        : Image.asset(
            image,
            width: width,
            height: height,
            color: color,
            fit: fit ?? BoxFit.contain,
          );
  }
}
