// To parse this JSON data, do
//
//     final typeState = typeStateFromJson(jsonString);

import 'dart:convert';

List<TypeState> typeStateFromJson(String str) => List<TypeState>.from(json.decode(str).map((x) => TypeState.fromJson(x)));

String typeStateToJson(List<TypeState> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeState {
  TypeState({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.createdAt,
    required this.updatedAt,
    required this.stateid,
  });

  int id;
  String name;
  String nameAr;
  DateTime createdAt;
  DateTime updatedAt;
  int stateid;
  factory TypeState.fromJson(Map<String, dynamic> json) => TypeState(
    id: json["id"],
    name: json["name"],
    nameAr: json["name_ar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    stateid: json["stateid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_ar": nameAr,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "stateid": stateid,
  };
}
