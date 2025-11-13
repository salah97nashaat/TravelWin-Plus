import 'dart:convert';
// To parse this JSON data, do
//
//     final tripeFavoriteModel = tripeFavoriteModelFromJson(jsonString);

List<TripeFavoriteModel> tripeFavoriteModelFromJson(String str) =>
    List<TripeFavoriteModel>.from(
        json.decode(str).map((x) => TripeFavoriteModel.fromJson(x)));

String tripeFavoriteModelToJson(List<TripeFavoriteModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripeFavoriteModel {
  TripeFavoriteModel({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.date,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.fromAr,
    required this.toAr,
    required this.typeAr,
    required this.favorite,
    required this.favoritesId,
    required this.file,
  });

  int id;
  String from;
  String to;
  String type;
  DateTime date;
  int duration;
  DateTime createdAt;
  DateTime updatedAt;
  String fromAr;
  String toAr;
  String typeAr;
  int favorite;
  int favoritesId;
  String file;

  factory TripeFavoriteModel.fromJson(Map<String, dynamic> json) =>
      TripeFavoriteModel(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        type: json["type"],
        date: DateTime.parse(json["date"]),
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fromAr: json["from_ar"],
        toAr: json["to_ar"],
        typeAr: json["type_ar"],
        favorite: json["favorite"],
        favoritesId: json["favorites_id"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from": from,
        "to": to,
        "type": type,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "duration": duration,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "from_ar": fromAr,
        "to_ar": toAr,
        "type_ar": typeAr,
        "favorite": favorite,
        "favorites_id": favoritesId,
        "file": file,
      };
}
