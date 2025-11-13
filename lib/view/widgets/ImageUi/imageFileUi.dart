import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageFileUi extends StatelessWidget {
  final File image;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageFileUi(this.image,
      {this.fit, this.color, this.width, this.height, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image.path.endsWith('.svg')
        ? SvgPicture.file(
            image,
            width: width,
            height: height,
            colorFilter: color == null
                ? null
                : ColorFilter.mode(color!, BlendMode.srcIn),
            // color: color,
            fit: fit ?? BoxFit.contain,
          )
        : Image.file(
            image,
            width: width,
            height: height,
            color: color,
            fit: fit ?? BoxFit.contain,
          );
  }
}
