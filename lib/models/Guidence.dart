
class Guidence {
  Guidence({
      this.status, 
      this.guidances,});

  Guidence.fromJson(dynamic json) {
   // print(json);
    status = json['status'];
    if (json['guidances'] != null) {
      guidances = [];
      json['guidances'].forEach((v) {
        guidances!.add(Guidances.fromJson(v));
      });
    }
  }
  bool? status;
  List<Guidances>? guidances;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (guidances != null) {
      map['guidances'] = guidances!.map((v) => v.toJson()).toList();
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
    this.image,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dialcode = json['dialcode'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    age = json['birth_date'];
    image = json['image'];
  }
  int? id;
  String? name;
  String? email;
  String? dialcode;
  String? countryCode;
  String? mobile;
  String? age;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['dialcode'] = dialcode;
    map['country_code'] = countryCode;
    map['mobile'] = mobile;
    map['birth_date'] = age;
    map['image'] = image;
    return map;
  }

}

class Guidances {
  Guidances({
    this.id,
    this.salary,
    this.car,
    this.license,
    this.licenseImage,
    this.idImage,
    this.nationality,
    this.trips_count,
    this.rate,
    this.user,});

  Guidances.fromJson(dynamic json) {
    id = json['id'];
    placesAR = json['places_ar']??'';
    placesEn = json['places_en']??'';
    languagesAR = json['languages_ar'] != null ? json['languages_ar'].cast<String>() : [''];
    languagesEn = json['languages_en'] != null ? json['languages_en'].cast<String>() : [''];
    bioAR = json['bio_ar']??'';
    bioEN = json['bio_en']??'';
    salary = json['salary'];
    trips_count=json['user']['trips_count'];
    car = json['car'];
    license = json['license'];
    licenseImage = json['licenseImage'];
    idImage = json['ID'];
    nationality = json['nationality'];
    rate = json['rate'];
    is_favorite=json['is_favorite'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  int? id;
  String? placesAR;
  String? placesEn;
  List<String>? languagesAR;
  List<String>? languagesEn;
  String? bioAR;
  String? bioEN;
  int? salary;
  bool? car;
  bool? license;
  int? trips_count;
  String? licenseImage;
  String? idImage;
  String? nationality;
  int? rate;
  bool? is_favorite;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['salary'] = salary;
    map['car'] = car;
    map['license'] = license;
    map['licenseImage'] = licenseImage;
    map['ID'] = id;
    map['nationality'] = nationality;
    map['rate'] = rate;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

}