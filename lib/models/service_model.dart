class ServiceModel {
  int id;
  // Map<String, String>? title;
  String nameAr, nameEn;
  String? imageUrl;
  ServiceModel(
      {required this.id, this.nameAr = "", this.nameEn = "", this.imageUrl});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        imageUrl: json['logo']);
  }
}
