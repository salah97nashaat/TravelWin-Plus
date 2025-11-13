// To parse this JSON data, do
//
//     final ticketModels = ticketModelsFromJson(jsonString);

import 'dart:convert';

List<TicketModels> ticketModelsFromJson(String str) => List<TicketModels>.from(json.decode(str).map((x) => TicketModels.fromJson(x)));

String ticketModelsToJson(List<TicketModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketModels {
  TicketModels({
    required this.id,
    required this.userId,
    required this.code,

    required this.createdAt,
    required this.updatedAt,

  });

  int id;
  int userId;
  int code;
  DateTime createdAt;
  DateTime updatedAt;

  factory TicketModels.fromJson(Map<String, dynamic> json) => TicketModels(
    id: json["id"],
    userId: json["user_id"],
    code: json["code"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "code": code,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
