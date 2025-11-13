// To parse this JSON data, do
//
//     final stateModels = stateModelsFromJson(jsonString);

import 'dart:convert';

List<StateModels> stateModelsFromJson(String str) => List<StateModels>.from(json.decode(str).map((x) => StateModels.fromJson(x)));

String stateModelsToJson(List<StateModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateModels {
  StateModels({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String nameAr;
  DateTime createdAt;
  DateTime updatedAt;

  factory StateModels.fromJson(Map<String, dynamic> json) => StateModels(
    id: json["id"],
    name: json["name"],
    nameAr: json["name_ar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_ar": nameAr,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
