class ProviderNoteModel {
  String bodyAr, bodyEn;
  String color;

  ProviderNoteModel(
      {required this.bodyAr, required this.bodyEn, required this.color});

  factory ProviderNoteModel.fromJson(Map<String, dynamic> json) {
    return ProviderNoteModel(
        bodyAr: json['body_ar'], bodyEn: json['body_en'], color: json['color']);
  }
}
