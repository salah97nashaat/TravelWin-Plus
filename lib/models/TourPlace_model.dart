// To parse this JSON data, do
//
//     final tourPlace = tourPlaceFromJson(jsonString);

import 'dart:convert';

List<TourPlace> tourPlaceFromJson(String str) => List<TourPlace>.from(json.decode(str).map((x) => TourPlace.fromJson(x)));

String tourPlaceToJson(List<TourPlace> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TourPlace {
  TourPlace({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.stateid,
    required this.typeid,
    required this.notes,
    required this.notesAr,
    required this.lat,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.file,
    required this.favorite,


  });

  int id;
  String name;
  String nameAr;
  int stateid;
  int typeid;
  String notes;
  String notesAr;
  String lat;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  String file;
  String favorite;

  factory TourPlace.fromJson(Map<String, dynamic> json) => TourPlace(
    id: json["id"],
    name: json["name"],
    nameAr: json["name_ar"],
    stateid: json["stateid"],
    typeid: json["typeid"],
    notes: json["notes"],
    notesAr: json["notes_ar"],
    lat: json["lat"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    file: json["file"],
    favorite: json["favorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_ar": nameAr,
    "stateid": stateid,
    "typeid": typeid,
    "notes": notes,
    "notes_ar": notesAr,
    "lat": lat,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "file": file,
    "favorite": favorite,
  };
}
