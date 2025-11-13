// To parse this JSON data, do
//
//     final tourPlaceFavoriteModel = tourPlaceFavoriteModelFromJson(jsonString);

import 'dart:convert';

List<TourPlaceFavoriteModel> tourPlaceFavoriteModelFromJson(String str) => List<TourPlaceFavoriteModel>.from(json.decode(str).map((x) => TourPlaceFavoriteModel.fromJson(x)));

String tourPlaceFavoriteModelToJson(List<TourPlaceFavoriteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TourPlaceFavoriteModel {
  TourPlaceFavoriteModel({
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
    required this.favorite,
    required this.favoritesId,
    required this.file,
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
  int favorite;
  int favoritesId;
  String file;

  factory TourPlaceFavoriteModel.fromJson(Map<String, dynamic> json) => TourPlaceFavoriteModel(
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
    favorite: json["favorite"],
    favoritesId: json["favorites_id"],
    file: json["file"],
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
    "favorite": favorite,
    "favorites_id": favoritesId,
    "file": file,
  };
}
