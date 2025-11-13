class PlacesType {
  PlacesType({
    this.id,
    this.nameAr,
    this.nameEn,});

  PlacesType.fromJson(dynamic json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }
  int? id;
  String? nameAr;
  String? nameEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    return map;
  }

}
class StatePlaces {
  StatePlaces({
      this.status, 
      this.placesType,});

  StatePlaces.fromJson(dynamic json) {
    status = json['status'];
    if (json['places_type'] != null) {
      placesType = [];
      json['places_type'].forEach((v) {
        placesType!.add(PlacesType.fromJson(v));
      });
    }
  }
  bool? status;
  List<PlacesType>? placesType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (placesType != null) {
      map['places_type'] = placesType!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}