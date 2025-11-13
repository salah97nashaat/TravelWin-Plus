
import 'Images.dart';

class IstanbulTurkey {
  IstanbulTurkey({
    this.id,
    this.locationAr,
    this.locationEn,
    this.squareSize,
    this.descriptionAr,
    this.descriptionEn,
    this.costs,
    this.rooms,
    this.bathrooms,
    this.price,
    this.floor,
    this.paymentType,
    this.propertyType,
    this.classification,
    this.status,
    this.age,
    this.rate,
    this.images,
    this.isFavorite,});

  IstanbulTurkey.fromJson(dynamic json) {
    id = json['id'];
    locationAr = json['location_ar'];
    locationEn = json['location_en'];
    squareSize = json['square_size'];
    furniture=json['furniture'];
    currency=json['currency'];
    property_advertiser=json['property_advertiser'];
    descriptionAr = json['description_ar'];
    descriptionEn = json['description_en'];
    costs = json['costs'];
    rooms = json['rooms'];
    bathrooms = json['bathrooms'];
    price = double.parse(json['price'].toString());
    floor = json['floor'];
    paymentType = json['payment_type'];
    propertyType = json['property_type'];
    classification = json['classification'];
    status = json['status'];
    age = json['age'];
    rate = json['rate'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    isFavorite = json['is_favorite'];
  }
  int? id;
  String? locationAr;
  String? locationEn;
  String? squareSize;
  bool? furniture;
  String? descriptionAr;
  String? currency;
  String? property_advertiser;
  String? descriptionEn;
  String? costs;
  int? rooms;
  int? bathrooms;
  double? price;
  String? floor;
  String? paymentType;
  String? propertyType;
  String? classification;
  String? status;
  int? age;
  int? rate;
  List<Images>? images;
  bool? isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['location_ar'] = locationAr;
    map['location_en'] = locationEn;
    map['square_size'] = squareSize;
    map['description_ar'] = descriptionAr;
    map['description_en'] = descriptionEn;
    map['costs'] = costs;
    map['rooms'] = rooms;
    map['bathrooms'] = bathrooms;
    map['price'] = price;
    map['floor'] = floor;
    map['payment_type'] = paymentType;
    map['property_type'] = propertyType;
    map['classification'] = classification;
    map['status'] = status;
    map['age'] = age;
    map['rate'] = rate;
    if (images != null) {
      map['images'] = images!.map((v) => v.toJson()).toList();
    }
    map['is_favorite'] = isFavorite;
    return map;
  }

}
class Properties {
  Properties({
    this.lands,
    this.istanbulTurkey,});

  Properties.fromJson(dynamic json) {
    if (json['market'] != null) {
      market = [];
      json['market'].forEach((v) {
        market!.add(IstanbulTurkey.fromJson(v));
      });
    }else{
      market=[];
    }
    if (json['istanbul_turkey'] != null) {
      istanbulTurkey = [];
      json['istanbul_turkey'].forEach((v) {
        istanbulTurkey!.add(IstanbulTurkey.fromJson(v));
      });
    }else{
      istanbulTurkey=[];
    }
    if (json['european_istanbul'] != null) {
      europeanIstanbul = [];
      json['european_istanbul'].forEach((v) {
        europeanIstanbul!.add(IstanbulTurkey.fromJson(v));
      });
    }else{
      europeanIstanbul=[];
    }
    if (json['lands'] != null) {
      lands = [];
      json['lands'].forEach((v) {
        lands!.add(IstanbulTurkey.fromJson(v));
      });
    }else{
      lands=[];
    }
    if (json['trabzon'] != null) {
      trabzon = [];
      json['trabzon'].forEach((v) {
        trabzon!.add(IstanbulTurkey.fromJson(v));
      });
    }
    else{
      trabzon=[];
    }
    if (json['yalwa'] != null) {
      yalwa = [];
      json['yalwa'].forEach((v) {
        yalwa!.add(IstanbulTurkey.fromJson(v));
      });
    }else{
      yalwa=[];
    }
  }
  List<IstanbulTurkey>? lands;
  List<IstanbulTurkey>? istanbulTurkey;
  List<IstanbulTurkey>? europeanIstanbul;
  List<IstanbulTurkey>? market;
  List<IstanbulTurkey>? yalwa;
  List<IstanbulTurkey>? trabzon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (lands != null) {
      map['lands'] = lands!.map((v) => v.toJson()).toList();
    }
    if (istanbulTurkey != null) {
      map['istanbul_turkey'] = istanbulTurkey!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
class PropertiesModel {
  PropertiesModel({
      this.status, 
      this.properties,});

  PropertiesModel.fromJson(dynamic json) {
    status = json['status'];
    properties = json['properties'] != null ? Properties.fromJson(json['properties']) : null;
  }
  bool? status;
  Properties? properties;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (properties != null) {
      map['properties'] = properties!.toJson();
    }
    return map;
  }

}