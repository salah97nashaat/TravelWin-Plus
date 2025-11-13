// To parse this JSON data, do
//
//     final notificationModels = notificationModelsFromJson(jsonString);

import 'dart:convert';

List<NotificationModels> notificationModelsFromJson(String str) => List<NotificationModels>.from(json.decode(str).map((x) => NotificationModels.fromJson(x)));

String notificationModelsToJson(List<NotificationModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModels {
  NotificationModels({
    required this.id,
    required this.userId,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.status,

    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String title;
  String titleAr;
  String body;
  String bodyAr;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory NotificationModels.fromJson(Map<String, dynamic> json) => NotificationModels(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    titleAr: json["title_ar"],
    body: json["body"],
    bodyAr: json["body_ar"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "title_ar": titleAr,
    "body": body,
    "body_ar": bodyAr,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
