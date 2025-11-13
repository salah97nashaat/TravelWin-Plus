import 'package:travelwin/models/PropertiesModel.dart';
import 'Guidence.dart';
import 'StatesPlaces.dart' as s;
import 'Images.dart' as i;
import 'TripModel.dart';

class PlaceType {
  PlaceType({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  PlaceType.fromJson(dynamic json) {
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

class State {
  State({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  State.fromJson(dynamic json) {
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

class Places {
  Places({this.state, this.placeType, this.statePlaces});

  Places.fromJson(dynamic json) {
    List<i.Images> images = [];
    json['images'].forEach((v) {
      print(v);
      images.add(i.Images.fromJson(v));
    });
    statePlaces = s.Data(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      bodyAr: json['body_ar'],
      bodyEn: json['body_en'],
      long: json['long'],
      lat: json['lat'],
      isFavorite: json['is_favorite'],
      images: images,
    );
    state = json['state'] != null ? State.fromJson(json['state']) : null;
    placeType = json['placeType'] != null
        ? PlaceType.fromJson(json['placeType'])
        : null;
  }
  s.Data? statePlaces;
  State? state;
  PlaceType? placeType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (state != null) {
      map['state'] = state!.toJson();
    }
    if (placeType != null) {
      map['placeType'] = placeType!.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.dialcode,
    this.countryCode,
    this.mobile,
    this.age,
    this.image,
    this.tripsCount,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dialcode = json['dialcode'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    age = json['age'];
    image = json['image'];
    tripsCount = json['trips_count'];
  }
  int? id;
  String? name;
  String? email;
  String? dialcode;
  String? countryCode;
  String? mobile;
  int? age;
  String? image;
  int? tripsCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['dialcode'] = dialcode;
    map['country_code'] = countryCode;
    map['mobile'] = mobile;
    map['age'] = age;
    map['image'] = image;
    map['trips_count'] = tripsCount;
    return map;
  }
}

// class Trips {
//   Trips({
//     this.id,
//     this.nameAr,
//     this.nameEn,
//     this.fromEn,
//     this.toEn,
//     this.fromAr,
//     this.toAr,
//     this.duration,
//     this.date,
//     this.type,
//     this.images,
//     this.isFavorite,});
//
//   Trips.fromJson(dynamic json) {
//     id = json['id'];
//     nameAr = json['name_ar'];
//     nameEn = json['name_en'];
//     fromEn = json['from_en'];
//     toEn = json['to_en'];
//     fromAr = json['from_ar'];
//     toAr = json['to_ar'];
//     duration = json['duration'];
//     date = json['date'];
//     type = json['type'];
//     if (json['images'] != null) {
//       images = [];
//       json['images'].forEach((v) {
//         images!.add(Images.fromJson(v));
//       });
//     }
//     isFavorite = json['is_favorite'];
//   }
//   int? id;
//   String? nameAr;
//   String? nameEn;
//   String? fromEn;
//   String? toEn;
//   String? fromAr;
//   String? toAr;
//   int? duration;
//   String? date;
//   String? type;
//   List<Images>? images;
//   bool? isFavorite;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name_ar'] = nameAr;
//     map['name_en'] = nameEn;
//     map['from_en'] = fromEn;
//     map['to_en'] = toEn;
//     map['from_ar'] = fromAr;
//     map['to_ar'] = toAr;
//     map['duration'] = duration;
//     map['date'] = date;
//     map['type'] = type;
//     if (images != null) {
//       map['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     map['is_favorite'] = isFavorite;
//     return map;
//   }
//
// }
class Data {
  Data({
    this.trips,
    this.guidances,
    this.places,
  });

  Data.fromJson(dynamic json) {
    if (json['trips'] != null) {
      trips = [];
      json['trips'].forEach((v) {
        trips!.add(Trips.fromJson(v));
      });
    }
    if (json['guidances'] != null) {
      guidances = [];
      json['guidances'].forEach((v) {
        guidances!.add(Guidances.fromJson(v));
      });
    }
    if (json['properties'] != null) {
      properties = [];
      json['properties'].forEach((v) {
        properties!.add(IstanbulTurkey.fromJson(v));
      });
    }

    if (json['places'] != null) {
      places = [];
      json['places'].forEach((v) {
        places!.add(Places.fromJson(v));
      });
    }
  }
  List<Trips>? trips;
  List<Guidances>? guidances;
  List<Places>? places;
  List<IstanbulTurkey>? properties;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (trips != null) {
      map['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    if (guidances != null) {
      map['guidances'] = guidances!.map((v) => v.toJson()).toList();
    }
    if (places != null) {
      map['places'] = places!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FavoriteModel {
  FavoriteModel({
    this.status,
    this.data,
  });

  FavoriteModel.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}
