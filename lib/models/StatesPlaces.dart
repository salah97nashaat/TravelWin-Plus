import 'Images.dart';

class Data {
  Data({
    this.id,
    this.nameAr,
    this.nameEn,
    this.bodyAr,
    this.bodyEn,
    this.long,
    this.lat,
    this.rate,
    this.images,
    this.isFavorite,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    bodyAr = json['body_ar'];
    bodyEn = json['body_en'];
    long = json['long'];
    lat = json['lat'];
    rate = json['rate'].toString()=='null'?'0':json['rate'].toString();
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    isFavorite = json['is_favorite'];
  }
  int? id;
  String? nameAr;
  String? nameEn;
  String? bodyAr;
  String? bodyEn;
  String? long;
  String? lat;
  String? rate;
  List<Images>? images;
  bool? isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['body_ar'] = bodyAr;
    map['body_en'] = bodyEn;
    map['long'] = long;
    map['lat'] = lat;
    map['rate'] = rate;
    if (images != null) {
      map['images'] = images!.map((v) => v.toJson()).toList();
    }
    map['is_favorite'] = isFavorite;
    return map;
  }

}

class StatePlaces {
  StatePlaces({
    this.data,
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,});

  StatePlaces.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    total = json['total'];
    count = json['count'];
    perPage = json['perPage'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }
  List<Data>? data;
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['count'] = count;
    map['perPage'] = perPage;
    map['currentPage'] = currentPage;
    map['totalPages'] = totalPages;
    return map;
  }

}
class StatesPlaces {
  StatesPlaces({
      this.status, 
      this.statePlaces,});

  StatesPlaces.fromJson(dynamic json) {
    status = json['status'];
    statePlaces = json['state_places'] != null ? StatePlaces.fromJson(json['state_places']) : null;
  }
  bool? status;
  StatePlaces? statePlaces;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (statePlaces != null) {
      map['state_places'] = statePlaces!.toJson();
    }
    return map;
  }

}