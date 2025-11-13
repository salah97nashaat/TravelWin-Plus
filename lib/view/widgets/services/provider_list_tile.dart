// import 'package:app/controllers/provider_controller.dart';
// import 'package:app/core/constants.dart';
// import 'package:app/models/provider_model.dart';
// import 'package:app/views/widgets/provider_avatar.dart';
// import 'package:app/views/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';
// import 'package:get_storage/get_storage.dart';
import 'provider_avatar.dart';
import 'rating_badge.dart';
import 'rounded_rect_container.dart';

class ProviderListTile extends StatelessWidget {
  const ProviderListTile({super.key, required this.provider});
  final ProviderModel provider;
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    ProviderController controller = Get.find();
    var isAr = Get.locale!.languageCode == "ar";
    var name = isAr ? provider.nameAr! : provider.nameEn!;
    var rating = provider.rating ?? 5;
    var ratingColor = getRatingColor(rating);

    var minFee = provider.minFee ?? 10;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                  spreadRadius: 0.6, color: Colors.grey, offset: Offset(0, 0.6))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ProviderAvatar(
                rating: rating,
                radius: 28,
                imageUrl: provider.logoUrl,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RatingBadge(ratingColor: ratingColor, rating: rating),
                        const Text(" "),
                        Text(name),
                        // Expanded(child: Container()),
                        // SizedBox.expand(),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Min $minFee TL", style: secondaryTextStyle),
                        Text(" . ", style: secondaryTextStyle),
                        Icon(Icons.access_time_filled,
                            size: 16, color: secondaryTextStyle.color),
                        Text(" ", style: secondaryTextStyle),
                        Text(provider.openTime ?? "09:00",
                            style: secondaryTextStyle),
                        Text(" - ", style: secondaryTextStyle),
                        Text(provider.closeTime ?? "17:45",
                            style: secondaryTextStyle)
                      ],
                    )
                  ],
                ),
              ),
              IconButton(
                  color: mainColor2,
                  onPressed: () {
                    controller.toggleFav(provider);
                  },
                  icon: provider.isfav
                      ? Icon(
                          Icons.favorite_rounded,
                          color: mainColor2,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ))
            ]),
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
          ],
        ),
      ),
    );
  }
}
