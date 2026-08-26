class BannerModel {
  String imageUrl;
  String titleAr;
  String titleEn;
  String placement;
  String actionType;
  String? actionValue;
  int? targetId;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel()
      ..imageUrl = json['image']?.toString() ?? ''
      ..titleAr = json['title_ar']?.toString() ?? ''
      ..titleEn = json['title_en']?.toString() ?? ''
      ..placement = json['placement']?.toString() ?? ''
      ..actionType = json['action_type']?.toString() ?? 'none'
      ..actionValue = json['action_value']?.toString()
      ..targetId = json['target_id'] is int
          ? json['target_id']
          : int.tryParse(json['target_id']?.toString() ?? '');
  }
  BannerModel()
      : imageUrl = "",
        titleAr = "",
        titleEn = "",
        placement = "",
        actionType = "none";
}
