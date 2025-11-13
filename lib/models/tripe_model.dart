import 'dart:convert';

List<Trip> tripFromJson(String str) =>
    List<Trip>.from(json.decode(str).map((x) => Trip.fromJson(x)));

String tripToJson(List<Trip> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trip {
  Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.type,
    required this.date,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    required this.from_ar,
    required this.to_ar,
    required this.type_ar,
    required this.file,
    required this.favorite,
  });

  int id;
  String from;
  String from_ar;
  String to;
  String type;
  String to_ar;
  String type_ar;
  DateTime date;
  int duration;
  DateTime createdAt;
  DateTime updatedAt;
  String file;
  String favorite;
  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        from: json["from"],
        to: json["to"],
        type: json["type"],
        date: DateTime.parse(json["date"]),
        duration: json["duration"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        from_ar: json["from_ar"],
        to_ar: json["to_ar"],
        type_ar: json["type_ar"],
        file: json["file"],
    favorite: json["favorite"],

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
        "from_ar": from_ar,
        "to_ar": to_ar,
        "type_ar": type_ar,
        "file": file,
    "favorite": favorite,

      };
}
