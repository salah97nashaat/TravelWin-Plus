class Images {
  Images({
    this.id,
    this.image,});

  Images.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
  }
  int? id;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    return map;
  }

}
class Trips {
  Trips({
    this.id,
    this.nameAr,
    this.nameEn,
    this.fromEn,
    this.toEn,
    this.fromAr,
    this.toAr,
    this.duration,
    this.date,
    this.type,
    this.images,});

  Trips.fromJson(dynamic json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    fromEn = json['from_en'];
    toEn = json['to_en'];
    fromAr = json['from_ar'];
    toAr = json['to_ar'];
    duration = json['duration'];
    date = json['date'];
    type = json['type'];
    is_favorite=json['is_favorite'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }
  int? id;
  String? nameAr;
  String? nameEn;
  String? fromEn;
  String? toEn;
  String? fromAr;
  String? toAr;
  int? duration;
  String? date;
  String? type;
  bool? is_favorite;
  List<Images>? images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['from_en'] = fromEn;
    map['to_en'] = toEn;
    map['from_ar'] = fromAr;
    map['to_ar'] = toAr;
    map['duration'] = duration;
    map['date'] = date;
    map['type'] = type;
    if (images != null) {
      map['images'] = images!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
class TripModel {
  TripModel({
      this.status, 
      this.trips,});

  TripModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['trips'] != null) {
      trips = [];
      json['trips'].forEach((v) {
        trips!.add(Trips.fromJson(v));
      });
    }
  }
  bool? status;
  List<Trips>? trips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (trips != null) {
      map['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}