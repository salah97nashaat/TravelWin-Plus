import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/NewHome.dart';
import '../../../models/banner_model.dart';
import '../../../logic/controllers/provider_controller.dart';
import '../../../utils/theme.dart';
import '../../screens/services/provider_details.dart';

class MyCarsoulSlider extends StatelessWidget {
  MyCarsoulSlider({Key? key, required this.items, required this.height})
      : super(key: key);

  final List<dynamic> items;
  final double height;
  final Rx<int> activeIndex = Rx(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: Get.height * height,
            onPageChanged: (index, reason) => activeIndex.value = index,
            enableInfiniteScroll: items.length > 1,
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            autoPlayAnimationDuration: const Duration(seconds: 2),
            autoPlay: true,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
          ),
          items: items.map<Widget>(_buildBanner).toList(),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => DotsIndicator(
            dotsCount: items.isEmpty ? 1 : items.length,
            position: activeIndex.value.toDouble(),
            decorator: DotsDecorator(
              color: Colors.grey.shade300,
              activeColor: mainColor,
              size: const Size(6.0, 6.0),
              activeSize: const Size(18.0, 6.0), // Attractive Pill Shape
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(dynamic item) {
    final imageUrl = _imageUrl(item);

    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () => _handleTap(item),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageUrl.isEmpty
                  ? _imageError()
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: Get.width,
                      placeholder: (_, __) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => _imageError(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  String _imageUrl(dynamic item) {
    if (item is BannerModel) return item.imageUrl.trim();
    if (item is Banners) return item.image?.trim() ?? '';
    return '';
  }

  Future<void> _handleTap(dynamic item) async {
    final actionType = _actionType(item);
    final actionValue = _actionValue(item);

    switch (actionType) {
      case 'external_url':
        await _openLink(actionValue);
        break;
      case 'whatsapp':
        await _openWhatsApp(actionValue);
        break;
      case 'internal_deep_link':
        await _openProvider(_targetId(item));
        break;
      case 'none':
      default:
        break;
    }
  }

  String _actionType(dynamic item) {
    if (item is BannerModel) return item.actionType;
    if (item is Banners) return item.actionType ?? 'none';
    return 'none';
  }

  String _actionValue(dynamic item) {
    if (item is BannerModel) return item.actionValue ?? '';
    if (item is Banners) return item.actionValue ?? '';
    return '';
  }

  int? _targetId(dynamic item) {
    if (item is BannerModel) return item.targetId;
    if (item is Banners) return item.targetId;
    return null;
  }

  Future<void> _openLink(String link) async {
    final uri = Uri.tryParse(link.trim());
    if (uri == null || !uri.hasScheme) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final phone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) return;
    await _openLink('https://wa.me/$phone');
  }

  Future<void> _openProvider(int? providerId) async {
    if (providerId == null) return;

    final controller = Get.isRegistered<ProviderController>()
        ? Get.find<ProviderController>()
        : Get.put(ProviderController());
    final provider = await controller.getProvider(providerId);
    if (provider != null) {
      Get.to(() => ProviderDetailsPage(provider: provider));
    }
  }

  Widget _imageError() => Container(
        color: Colors.grey.shade100,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      );
}
