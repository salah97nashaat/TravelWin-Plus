import 'dart:convert';

List<ActivityModel> activityModelFromJson(String str) {
  final jsonData = json.decode(str);
  // Support both Laravel resource collections and paginated/nested responses.
  dynamic data = jsonData is Map<String, dynamic>
      ? jsonData['data'] ?? jsonData['activities'] ?? jsonData['items']
      : jsonData;
  if (data is Map<String, dynamic>) {
    data = data['data'] ?? data['activities'] ?? data['items'] ?? const [];
  }
  if (data is! List) return const [];
  return List<ActivityModel>.from(data.map((x) => ActivityModel.fromJson(x)));
}

class ActivityModel {
  final int id;
  final String titleAr,
      titleEn,
      descAr,
      descEn,
      image,
      status,
      type,
      infoAr,
      infoEn;
  final List<String> rulesAr, rulesEn;

  ActivityModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.image,
    required this.status,
    required this.type,
    required this.infoAr,
    required this.infoEn,
    required this.rulesAr,
    required this.rulesEn,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: int.tryParse(json["id"]?.toString() ?? '') ?? 0,
        titleAr: json["title_ar"] ?? "",
        titleEn: json["title_en"] ?? "",
        descAr: json["description_ar"] ?? "",
        descEn: json["description_en"] ?? "",
        image: json["image"] ?? json["image_url"] ?? "",
        status: (json["status"] ?? "open")
            .toString()
            .toLowerCase(), // open, soon, closed
        type: json["type"] ?? "activity",
        infoAr: json["info_ar"] ?? "",
        infoEn: json["info_en"] ?? "",
        rulesAr: _rulesFrom(json["rules_ar"]),
        rulesEn: _rulesFrom(json["rules_en"]),
      );
}

List<String> _rulesFrom(dynamic value) {
  if (value is List) return value.map((item) => item.toString()).toList();
  if (value is! String || value.trim().isEmpty) return const [];

  try {
    final decoded = jsonDecode(value);
    return decoded is List
        ? decoded.map((item) => item.toString()).toList()
        : <String>[value];
  } catch (_) {
    // Older activity records can contain a plain text rule instead of JSON.
    return <String>[value];
  }
}
