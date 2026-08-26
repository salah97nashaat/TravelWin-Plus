import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/service_state_controller.dart';
import 'package:travelwin/models/service_state_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/constants.dart';
// import 'package:travelwin/view/screens/services/service_chooser.dart';
import 'package:travelwin/view/widgets/services/state_grid_tile.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';

class StateChooser extends GetView<ServiceStateController> {
  const StateChooser({super.key, this.onStateChoosen});
  final Function(ServiceStateModel state)? onStateChoosen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Modern soft background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(
          "choose_state".tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showInfoDialog(),
            icon: const Icon(Icons.info_outline_rounded),
          )
        ],
      ),
      body: Obx(() => controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // Taller cards look more premium
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.w,
              ),
              itemCount: controller.states.length,
              itemBuilder: (context, index) {
                var state = controller.states[index];
                return GestureDetector(
                  onTap: () async {
                    await controller.setState(state);
                    if (onStateChoosen != null) {
                      onStateChoosen?.call(state);
                    } else {
                      Get.toNamed(Routes.serviceChooser);
                    }
                  },
                  child: PremiumStateCard(model: state),
                );
              },
            )),
    );
  }

  void _showInfoDialog() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: mainColor2),
          SizedBox(width: 10.w),
          Text("Note".tr),
        ],
      ),
      content: Text(
        "You can change state later".tr,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Ok".tr))
      ],
    ));
  }
}
class PremiumStateCard extends StatelessWidget {
  const PremiumStateCard({super.key, required this.model});
  final ServiceStateModel model;

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == 'ar';
    String? name = isAr ? model.nameAr : model.nameEn;
    
    // Check if we have a valid URL
    bool hasUrl = model.imageUrl != null && model.imageUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // 1. Image Logic: Try URL -> Try Asset -> Try Color
            Positioned.fill(
              child: hasUrl 
                ? CachedNetworkImage(
                    imageUrl: model.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey.shade200),
                    // If the URL fails to load, use the local default asset
                    errorWidget: (context, url, error) => _buildDefaultImage(),
                  )
                : _buildDefaultImage(),
            ),
            
            // 2. Premium Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Text Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: mainColor2, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "Explore".tr,
                        style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback image helper
  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/Group.png', // Using your existing background as default
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: mainColor2.withOpacity(0.1),
        child: Center(
          child: Icon(Icons.landscape, color: mainColor2, size: 40.sp),
        ),
      ),
    );
  }
}