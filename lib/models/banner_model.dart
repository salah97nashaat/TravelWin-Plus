class BannerModel {
  String imageUrl;
  String link;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel()
      ..imageUrl = json['image']
      ..link = json['link'] ?? "";
  }
  BannerModel()
      : imageUrl = "",
        link = "";
}
