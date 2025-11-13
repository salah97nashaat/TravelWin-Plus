import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:travelwin/view/widgets/services/carousel_card.dart';
import 'package:travelwin/view/widgets/services/provider_details_card.dart';
import 'package:travelwin/view/widgets/services/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments_page.dart';

class ProviderDetailsPage extends StatefulWidget {
  const ProviderDetailsPage({super.key, required this.provider});
  final ProviderModel provider;

  @override
  State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  ProviderController providerController = Get.find();
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    await providerController.getProvider(widget.provider.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == "ar";
    var name =
        isAr ? widget.provider.nameAr ?? "" : widget.provider.nameEn ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor3,
        surfaceTintColor: mainColor3,
        foregroundColor: colorScheme2.onPrimary,
        title: Text(name),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              Container(
                height: 80,
                color: mainColor3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GetBuilder<ProviderController>(
                      builder: (controller) {
                        return ProviderDetailsCard(
                          provider: widget.provider,
                          onComments: () {
                            Get.to(
                                () => CommentsPage(provider: widget.provider));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Expanded(
                      child: ListView(children: [
                    CarouselSlider(
                      items: widget.provider.imagesUrl
                          ?.map((e) => CarouselCard(
                                imageUrl: e,
                              ))
                          .toList(),
                      options:
                          CarouselOptions(height: 150, viewportFraction: 1.0),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        color: Colors.white,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "details".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(isAr
                                      ? widget.provider.detailsAr ?? ""
                                      : widget.provider.detailsEn ?? ""),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SocialButton(
                              icon: Icons.phone,
                              color: Colors.blue,
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    "tel:${widget.provider.phoneNumber}"))) {
                                  launchUrl(Uri.parse(
                                      "tel:${widget.provider.phoneNumber}"));
                                }
                              },
                            ),
                            SocialButton(
                              icon: FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    "https://wa.me/${widget.provider.whatsapp}"))) {
                                  launchUrl(Uri.parse(
                                      "https://wa.me/${widget.provider.whatsapp}"));
                                }
                              },
                            ),
                            SocialButton(
                              icon: FontAwesomeIcons.facebookF,
                              color: Colors.blue,
                              onTap: () async {
                                if (await canLaunchUrl(
                                    Uri.parse("${widget.provider.facebook}"))) {
                                  launchUrl(
                                      Uri.parse("${widget.provider.facebook}"));
                                }
                              },
                            ),
                            SocialButton(
                              icon: FontAwesomeIcons.instagram,
                              color: Colors.red,
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    "${widget.provider.instagram}"))) {
                                  launchUrl(Uri.parse(
                                      "${widget.provider.instagram}"));
                                }
                              },
                            ),
                            SocialButton(
                              icon: FontAwesomeIcons.tiktok,
                              color: Colors.black,
                              onTap: () async {
                                if (await canLaunchUrl(
                                    Uri.parse("${widget.provider.tiktok}"))) {
                                  launchUrl(
                                      Uri.parse("${widget.provider.tiktok}"));
                                }
                              },
                            ),
                            SocialButton(
                              icon: FontAwesomeIcons.globe,
                              color: Colors.blue,
                              onTap: () async {
                                if (await canLaunchUrl(
                                    Uri.parse("${widget.provider.website}"))) {
                                  launchUrl(
                                      Uri.parse("${widget.provider.website}"));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.white,
                          child: Row(children: [
                            const Icon(Icons.location_on_rounded),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("address".tr, style: primaryTextStyle),
                                  Text(
                                    isAr
                                        ? widget.provider.addressAr ?? ""
                                        : widget.provider.addressEn ?? "",
                                    // maxLines: 3,
                                    // overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 300,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(widget.provider.lat ?? 0,
                                widget.provider.long ?? 0),
                            initialZoom: 17,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(markers: [
                              Marker(
                                  point: LatLng(widget.provider.lat ?? 0,
                                      widget.provider.long ?? 0),
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 50,
                                    color: primaryColor,
                                  ))
                            ])
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ])),
                ],
              ),
            ]),
    );
  }
}
