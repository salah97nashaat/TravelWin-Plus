import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helpers/adv/admob_banner.dart';
import '../../widgets/services/win_pass_hero_card.dart';

// class ProviderDetailsPage extends StatefulWidget {
//   const ProviderDetailsPage({super.key, required this.provider});
//   final ProviderModel provider;

//   @override
//   State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
// }

// class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
//   ProviderController providerController = Get.find();
//   bool isLoading = false;
//   getData() async {
//     setState(() {
//       isLoading = true;
//     });
//     await providerController.getProvider(widget.provider.id);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var isAr = Get.locale!.languageCode == "ar";
//     var name =
//         isAr ? widget.provider.nameAr ?? "" : widget.provider.nameEn ?? "";

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mainColor3,
//         surfaceTintColor: mainColor3,
//         foregroundColor: colorScheme2.onPrimary,
//         title: Text(name),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.grey[200],
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(children: [
//               Container(
//                 height: 80,
//                 color: mainColor3,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: GetBuilder<ProviderController>(
//                       builder: (controller) {
//                         return ProviderDetailsCard(
//                           provider: widget.provider,
//                           onComments: () {
//                             Get.to(
//                                 () => CommentsPage(provider: widget.provider));
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 3.0),
//                   Expanded(
//                       child: ListView(children: [
//                     CarouselSlider(
//                       items: widget.provider.imagesUrl
//                           ?.map((e) => CarouselCard(
//                                 imageUrl: e,
//                               ))
//                           .toList(),
//                       options:
//                           CarouselOptions(height: 150, viewportFraction: 1.0),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         color: Colors.white,
//                         child: FractionallySizedBox(
//                           widthFactor: 1,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "details".tr,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(isAr
//                                       ? widget.provider.detailsAr ?? ""
//                                       : widget.provider.detailsEn ?? ""),
//                                 ]),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             SocialButton(
//                               icon: Icons.phone,
//                               color: Colors.blue,
//                               onTap: () async {
//                                 if (await canLaunchUrl(Uri.parse(
//                                     "tel:${widget.provider.phoneNumber}"))) {
//                                   launchUrl(Uri.parse(
//                                       "tel:${widget.provider.phoneNumber}"));
//                                 }
//                               },
//                             ),
//                             SocialButton(
//                               icon: FontAwesomeIcons.whatsapp.data,
//                               color: Colors.green,
//                               onTap: () async {
//                                 if (await canLaunchUrl(Uri.parse(
//                                     "https://wa.me/${widget.provider.whatsapp}"))) {
//                                   launchUrl(Uri.parse(
//                                       "https://wa.me/${widget.provider.whatsapp}"));
//                                 }
//                               },
//                             ),
//                             SocialButton(
//                               icon: FontAwesomeIcons.facebookF.data,
//                               color: Colors.blue,
//                               onTap: () async {
//                                 if (await canLaunchUrl(
//                                     Uri.parse("${widget.provider.facebook}"))) {
//                                   launchUrl(
//                                       Uri.parse("${widget.provider.facebook}"));
//                                 }
//                               },
//                             ),
//                             SocialButton(
//                               icon: FontAwesomeIcons.instagram.data,
//                               color: Colors.red,
//                               onTap: () async {
//                                 if (await canLaunchUrl(Uri.parse(
//                                     "${widget.provider.instagram}"))) {
//                                   launchUrl(Uri.parse(
//                                       "${widget.provider.instagram}"));
//                                 }
//                               },
//                             ),
//                             SocialButton(
//                               icon: FontAwesomeIcons.tiktok.data,
//                               color: Colors.black,
//                               onTap: () async {
//                                 if (await canLaunchUrl(
//                                     Uri.parse("${widget.provider.tiktok}"))) {
//                                   launchUrl(
//                                       Uri.parse("${widget.provider.tiktok}"));
//                                 }
//                               },
//                             ),
//                             SocialButton(
//                               icon: FontAwesomeIcons.globe.data,
//                               color: Colors.blue,
//                               onTap: () async {
//                                 if (await canLaunchUrl(
//                                     Uri.parse("${widget.provider.website}"))) {
//                                   launchUrl(
//                                       Uri.parse("${widget.provider.website}"));
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: FractionallySizedBox(
//                         widthFactor: 1.0,
//                         child: Container(
//                           padding: const EdgeInsets.all(16.0),
//                           color: Colors.white,
//                           child: Row(children: [
//                             const Icon(Icons.location_on_rounded),
//                             const SizedBox(width: 8.0),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("address".tr, style: primaryTextStyle),
//                                   Text(
//                                     isAr
//                                         ? widget.provider.addressAr ?? ""
//                                         : widget.provider.addressEn ?? "",
//                                     // maxLines: 3,
//                                     // overflow: TextOverflow.ellipsis,
//                                   )
//                                 ],
//                               ),
//                             )
//                           ]),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SizedBox(
//                         height: 300,
//                         child: FlutterMap(
//                           options: MapOptions(
//                             initialCenter: LatLng(widget.provider.lat ?? 0,
//                                 widget.provider.long ?? 0),
//                             initialZoom: 17,
//                           ),
//                           children: [
//                             TileLayer(
//                               urlTemplate:
//                                   'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                               userAgentPackageName: 'com.example.app',
//                             ),
//                             MarkerLayer(markers: [
//                               Marker(
//                                   point: LatLng(widget.provider.lat ?? 0,
//                                       widget.provider.long ?? 0),
//                                   width: 50,
//                                   height: 50,
//                                   child: Icon(
//                                     Icons.location_pin,
//                                     size: 50,
//                                     color: primaryColor,
//                                   ))
//                             ])
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16.0),
//                   ])),
//                 ],
//               ),
//             ]),
//     );
//   }
// }
class ProviderDetailsPage extends StatefulWidget {
  final ProviderModel provider;
  const ProviderDetailsPage({super.key, required this.provider});

  @override
  State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  late ProviderModel provider;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    _refreshProvider();
  }

  Future<void> _refreshProvider() async {
    final updatedProvider = await Get.find<ProviderController>().getProvider(
      provider.id,
      previousViewsCount: provider.viewsCount,
    );
    if (mounted && updatedProvider != null) {
      setState(() => provider = updatedProvider);
    }
  }

  Future<void> _openLocation(ProviderModel provider) async {
    final double? lat = provider.lat;
    final double? long = provider.long;
    final bool hasCoords =
        lat != null && long != null && (lat != 0 || long != 0);

    final bool isAr = Get.locale?.languageCode == 'ar';
    final String address =
        (isAr ? provider.addressAr : provider.addressEn) ??
        provider.addressEn ??
        provider.addressAr ??
        '';

    String mapUrl = '';
    if (hasCoords) {
      mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    } else if (address.trim().isNotEmpty) {
      mapUrl =
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    }

    if (mapUrl.isNotEmpty) {
      final uri = Uri.parse(mapUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error'.tr,
          'Could not open map'.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Notice'.tr,
        'Location is not available'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == "ar";
    var name = isAr ? provider.nameAr ?? "" : provider.nameEn ?? "";
    final bool hasMapCoords = provider.lat != null &&
        provider.long != null &&
        (provider.lat != 0 || provider.long != 0);

    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Home Page Background Image over white base
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/Group.png',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // 2. Scrollable Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
            // 1. Premium Hero Header
            SliverAppBar(
              expandedHeight: 250.h,
              pinned: true,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: EdgeInsets.all(8.w),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black, size: 18),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: (provider.imagesUrl != null &&
                        provider.imagesUrl!.isNotEmpty)
                    ? CarouselSlider(
                        items: provider.imagesUrl
                            ?.map((e) => CachedNetworkImage(
                                  imageUrl: e,
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(Icons.image_not_supported,
                                        size: 40.sp, color: Colors.grey),
                                  ),
                                ))
                            .toList() ??
                            [],
                        options: CarouselOptions(
                            height: 300.h,
                            viewportFraction: 1.0,
                            autoPlay: true),
                      )
                    : (provider.logoUrl != null &&
                            provider.logoUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: provider.logoUrl!,
                            fit: BoxFit.cover,
                            width: Get.width,
                          )
                        : Image.asset(
                            'assets/images/Group.png',
                            fit: BoxFit.cover,
                            width: Get.width,
                          ),
              ),
            ),

            // 2. Floating Info Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(name,
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                        _buildFavoriteButton(),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    _buildQuickInfoBar(provider),

                    // Win Pass Hero Card
                    WinPassHeroCard(
                      providerId: provider.id,
                      providerName: name,
                    ),

                    // Social Row
                    _buildSocialActionRow(provider),

                    Divider(height: 40.h),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("details".tr,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.h),
                          Text(
                            isAr
                                ? provider.detailsAr ?? ""
                                : provider.detailsEn ?? "",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                                height: 1.6),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                    _buildLocationSection(isAr, provider),
                  ],
                ),
              ),
            ),

            // 3. Map Section
            if (hasMapCoords)
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => _openLocation(provider),
                  child: Container(
                    height: 200.h,
                    margin: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          _buildMap(provider),
                          Positioned(
                            top: 10.h,
                            right: isAr ? null : 10.w,
                            left: isAr ? 10.w : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new,
                                      size: 14.sp, color: mainColor2),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Open Map".tr,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: mainColor2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: 30.h),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildFavoriteButton() {
    return GetBuilder<ProviderController>(
      builder: (controller) {
        // Assuming you have a logic to check if this provider is favorite
        final List favs = controller.getFav() ?? [];
        bool isFav = favs.contains(provider.id);

        return GestureDetector(
          onTap: () => controller.toggleFav(provider),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey,
              size: 24.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialActionRow(ProviderModel provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          if (provider.phoneNumber != null &&
              provider.phoneNumber!.trim().isNotEmpty)
            _buildCircleSocial(
                Icons.phone, Colors.blue, "tel:${provider.phoneNumber}"),
          if (provider.whatsapp != null &&
              provider.whatsapp!.trim().isNotEmpty)
            _buildCircleSocial(FontAwesomeIcons.whatsapp.data, Colors.green,
                "https://wa.me/${provider.whatsapp}"),
          if (provider.facebook != null &&
              provider.facebook!.trim().isNotEmpty)
            _buildCircleSocial(FontAwesomeIcons.facebookF.data,
                const Color(0xFF1877F2), provider.facebook!),
          if (provider.instagram != null &&
              provider.instagram!.trim().isNotEmpty)
            _buildCircleSocial(FontAwesomeIcons.instagram.data,
                const Color(0xFFE4405F), provider.instagram!),
          if (provider.tiktok != null &&
              provider.tiktok!.trim().isNotEmpty)
            _buildCircleSocial(
                FontAwesomeIcons.tiktok.data, Colors.black, provider.tiktok!),
          if (provider.website != null &&
              provider.website!.trim().isNotEmpty)
            _buildCircleSocial(
                Icons.language, Colors.blueGrey, provider.website!),
        ],
      ),
    );
  }

  Widget _buildCircleSocial(IconData icon, Color color, String url) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: InkWell(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          height: 45.w,
          width: 45.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Center(
            child: icon is IconData
                ? Icon(icon, color: color, size: 20.sp)
                : FaIcon(icon as FaIconData?, color: color, size: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(bool isAr, ProviderModel provider) {
    final String addressText =
        (isAr ? provider.addressAr : provider.addressEn) ??
        provider.addressEn ??
        provider.addressAr ??
        "";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openLocation(provider),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: mainColor2.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_rounded,
                    color: mainColor2, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "address".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                    if (addressText.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        addressText,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black54,
                            height: 1.4),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: mainColor2.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions,
                  color: mainColor2,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap(ProviderModel provider) {
    double lat = provider.lat ?? 0;
    double long = provider.long ?? 0;

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(lat, long),
        initialZoom: 15,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.travelwin.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(lat, long),
              width: 80.w,
              height: 80.w,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Icon(Icons.location_pin,
                        color: mainColor2, size: 35.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoBar(ProviderModel provider) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        // Ensures vertical dividers match text height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Rating
            _infoItem(
              icon: Icons.star_rounded,
              color: Colors.orange,
              label: provider.rating?.toString() ?? "5.0",
              subLabel: "Rating".tr,
            ),
            _verticalDivider(),

            // 2. Price (Min Fee)
            _infoItem(
              icon: Icons.payments_outlined,
              color: Colors.green,
              label: "${provider.minFee ?? '10'} TL",
              subLabel: "Min Price".tr,
            ),
            _verticalDivider(),

            // 3. Views
            _infoItem(
              icon: Icons.visibility_outlined,
              color: Colors.blue,
              label: provider.viewsCount?.toString() ??
                  "0", // Ensure 'views' exists in your model
              subLabel: "Views".tr,
            ),
            _verticalDivider(),

            // 4. Time
            _infoItem(
              icon: Icons.access_time,
              color: Colors.redAccent,
              label: "${provider.openTime ?? '09:00'}",
              subLabel: provider.closeTime ?? "18:00",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
      {required IconData icon,
      required Color color,
      required String label,
      required String subLabel}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Colors.black87),
          ),
          Text(
            subLabel,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return VerticalDivider(
        color: Colors.grey.shade300, thickness: 1, indent: 5, endIndent: 5);
  }
}
