// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.data,
    this.status
}
   );

  bool? status;
  Data? data;

   Profile.fromJson(dynamic json) {
    status= json["status"];
    data= Data.fromJson(json["user"]);}

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.country_code,
    required this.dialcode,
    required this.image,
    required this.email,
    required this.mobile,
    required this.age,
    required this.living_country,
    required this.gender,
  });

  int id;
  String name;
  String email;
  String image;
  String country_code;
  int mobile;
  String dialcode;
  String living_country;
  String gender;
  String age;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json['image']??'',
    dialcode: json['dialcode']??'',
    country_code: json['country_code']??'',
    mobile:json["mobile"]!=null? int.tryParse(json["mobile"])!:0,
    age: json['birth_date']??'',
    living_country: json['living_country']??'',
      gender:json['gender']??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "age": age,
  };
}
