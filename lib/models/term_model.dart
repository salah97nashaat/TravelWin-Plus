// To parse this JSON data, do
//
//     final termModels = termModelsFromJson(jsonString);

import 'dart:convert';

List<TermModels> termModelsFromJson(String str) => List<TermModels>.from(json.decode(str).map((x) => TermModels.fromJson(x)));

String termModelsToJson(List<TermModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TermModels {
  TermModels({
    required this.id,
    required this.title,
    required this.body,
    required this.titleAr,
    required this.bodyAr,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String body;
  String titleAr;
  String bodyAr;
  DateTime createdAt;
  DateTime updatedAt;

  factory TermModels.fromJson(Map<String, dynamic> json) => TermModels(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    titleAr: json["title_ar"],
    bodyAr: json["body_ar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "title_ar": titleAr,
    "body_ar": bodyAr,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
