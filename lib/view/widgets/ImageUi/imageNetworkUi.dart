
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageNetworkUi extends StatelessWidget {
  final String image;
  final double? width ;
  final double? height ;
  final BoxFit? fit ;
  final String? imgLoading;
  const ImageNetworkUi(this.image,{this.imgLoading,this.fit,this.width,this.height,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

    image.endsWith('.svg') ?
    SvgPicture.network(
      image,
      width: width,
      height: height,
      // colorFilter: color==null? null:  ColorFilter.mode(color!, BlendMode.color)  ,
      fit: fit?? BoxFit.contain,
      placeholderBuilder:
          (BuildContext context) => Image.asset(imgLoading??  "assets/images/empty.png",fit: BoxFit.contain,),
    ):

    FadeInImage(
      fadeInDuration:const Duration(milliseconds: 200),
      fadeOutDuration:const Duration(milliseconds: 200),

      placeholder:

      const AssetImage("assets/images/empty.png") ,
      key: ValueKey( Random().nextInt(1000)),
      fit: fit?? BoxFit.contain,
      image:
      NetworkImage(image),
      height: height,
      width: width,
      imageErrorBuilder: (context, error, stackTrace){
        return   Image.asset(imgLoading??"assets/images/empty.png",fit: BoxFit.contain,);
      },

    );
  }
}
