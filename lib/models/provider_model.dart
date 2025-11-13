// import 'package:latlong2/latlong.dart';

// import 'package:flutter/material.dart';

import 'comments_model.dart';
import 'provider_note_model.dart';

class ProviderModel {
  int id, serviceId, stateId;
  String? nameEn,
      nameAr,
      openTime,
      closeTime,
      note,
      detailsEn,
      detailsAr,
      addressEn,
      addressAr,
      phoneNumber,
      whatsapp,
      facebook,
      instagram,
      tiktok,
      logoUrl,
      website;
  int? commentsCount, viewsCount;
  List<String>? imagesUrl;
  List<CommentModel> comments;
  List<ProviderNoteModel>? notes;
  num? minFee, rating;
  bool recommended, hasOffers, isfav;
  double? long, lat;

  ProviderModel(
      {required this.id,
      required this.serviceId,
      required this.stateId,
      this.nameEn,
      this.nameAr,
      this.rating,
      this.minFee,
      this.openTime,
      this.closeTime,
      this.note,
      this.detailsEn,
      this.detailsAr,
      this.addressEn,
      this.addressAr,
      this.phoneNumber,
      this.whatsapp,
      this.facebook,
      this.instagram,
      this.tiktok,
      this.website,
      this.commentsCount,
      this.viewsCount,
      this.long,
      this.lat,
      this.logoUrl,
      this.imagesUrl,
      this.notes,
      this.comments = const [],
      this.recommended = false,
      this.isfav = false,
      this.hasOffers = false});
  Map<String, String> toJson() {
    return {
      'name_en': nameEn!,
      'name_ar': nameAr!,
      'open_time': openTime.toString(),
      'close_time': closeTime.toString(),
      'details_en': detailsEn!,
      'details_ar': detailsAr!,
      'address_en': addressEn!,
      'address_ar': addressAr!,
      'min_price': minFee.toString(),
      'service_provider_state_id': stateId.toString(),
      'service_id': serviceId.toString(),
      'phone_number': phoneNumber.toString(),
      'whatsapp': whatsapp.toString(),
      'facebook': facebook.toString(),
      'instagram': instagram.toString(),
      'tiktok': tiktok.toString(),
      'website': website.toString(),

      // 'comments_count':commentsCount,
      // 'view_count':viewsCount,
      // 'offers':hasOffers,
      // 'recommended':recommended,
    };
  }

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    var images = <String>[
      ...json["images"].map((e) => e["image_path"].toString())
    ];
    var notes = <ProviderNoteModel>[
      ...json['notes'].map((e) => ProviderNoteModel.fromJson(e))
    ];
    return ProviderModel(
        id: json['id'],
        serviceId: json['service_id'],
        stateId: json['service_provider_state_id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        openTime: json['open_time'],
        closeTime: json['close_time'],
        minFee: json['min_price'],
        logoUrl: json['logo'],
        imagesUrl: images,
        addressAr: json['address_ar'],
        addressEn: json['address_en'],
        detailsAr: json['details_ar'],
        detailsEn: json['details_en'],
        phoneNumber: json['phone_number'],
        whatsapp: json['whatsapp'],
        facebook: json['facebook'],
        instagram: json['instagram'],
        tiktok: json['tiktok'],
        website: json['website'],
        notes: notes,
        rating: json['rating'],
        lat: json['lat'].toDouble(),
        long: json['long'].toDouble(),
        viewsCount: json['view_count'],
        comments: [...json['comments'].map((e) => CommentModel.fromJson(e))]);
  }
}
