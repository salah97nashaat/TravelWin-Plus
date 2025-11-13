// import 'package:app/core/constants.dart';
// import 'package:app/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';

import 'provider_avatar.dart';
import 'rating_badge.dart';
import 'rounded_rect_container.dart';

class ProviderDetailsCard extends StatelessWidget {
  const ProviderDetailsCard(
      {super.key, required this.provider, this.onComments});
  final ProviderModel provider;
  final VoidCallback? onComments;
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var isAr = Get.locale!.languageCode == "ar";
    var name = isAr ? provider.nameAr ?? "" : provider.nameEn ?? "";

    var rating = provider.rating ?? 5;
    var ratingColor = getRatingColor(rating);
    var minFee = provider.minFee ?? 10;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      ProviderAvatar(
                        rating: rating,
                        radius: 30.0,
                        imageUrl: provider.logoUrl,
                      ),
                      const SizedBox(height: 6.0)
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child:
                          RatingBadge(ratingColor: ratingColor, rating: rating),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: primaryTextStyle.copyWith(
                                fontSize: 16, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        RoundedRectContainer(
                          backgroundColor: Colors.grey[300],
                          child: Row(
                            children: [
                              const ImageIcon(
                                AssetImage("assets/eyes.png"),
                                size: 18,
                              ),
                              const Text(" "),
                              Text((provider.viewsCount ?? 0).toString()),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        if (provider.hasOffers)
                          RoundedRectContainer(
                              backgroundColor: Colors.grey[400],
                              child: const Text("Discounts")),
                        if (provider.recommended)
                          RoundedRectContainer(
                              backgroundColor: Colors.grey[300],
                              child: const Text("Recommended"))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "working_hours".tr,
                    style: secondaryTextStyle,
                  ),
                  Row(
                    children: [
                      Text(
                        provider.openTime ?? "09:00",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(" - ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        provider.closeTime ?? "17:45",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(width: 8.0),
              Column(
                children: [
                  Text(
                    "min_price".tr,
                    style: secondaryTextStyle,
                  ),
                  Text(
                    "$minFee TL",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr,
                  )
                ],
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: onComments,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorScheme.fromSeed(seedColor: mainColor3)
                          .primaryContainer),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("comments".tr),
                          Text(
                            (provider.comments.length).toString(),
                            style: primaryTextStyle.copyWith(
                                color:
                                    ColorScheme.fromSeed(seedColor: mainColor3)
                                        .onPrimaryContainer),
                          )
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )
            ],
          ),
          if (provider.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                ...provider.notes!.map((e) => RoundedRectContainer(
                      backgroundColor: _colorFromHex(e.color),
                      child: Text(isAr ? e.bodyAr : e.bodyEn),
                    ))
              ],
            )
          ]
        ]),
      ),
    );
  }
}
