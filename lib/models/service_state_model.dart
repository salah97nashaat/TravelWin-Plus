class ServiceStateModel {
  int id;
  String? nameEn, nameAr, imageUrl;
  ServiceStateModel(
      {required this.id, this.nameEn, this.nameAr, this.imageUrl});

  factory ServiceStateModel.fromJson(Map<String, dynamic> json) {
    return ServiceStateModel(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        imageUrl: "");
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}
