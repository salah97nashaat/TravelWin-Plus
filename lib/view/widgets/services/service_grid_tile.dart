// import 'package:app/models/service_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/service_model.dart';

class ServiceGridTile extends StatelessWidget {
  const ServiceGridTile({super.key, required this.model});
  final ServiceModel model;

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == 'ar';
    return Column(
      children: [
        // 1. Circular Icon Container
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipOval(
            child: model.imageUrl == null
                ? Image.asset('assets/images/loading.png', fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: model.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(strokeWidth: 1),
                  ),
          ),
        ),
        SizedBox(height: 8.h),
        // 2. Text
        Text(
          (isAr ? model.nameAr : model.nameEn),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis, // <--- Fixed
          maxLines: 2, // <--- Fixed
          style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              height: 1.1 // Tighter line height for 2 lines
              ),
        )
      ],
    );
  }
}
