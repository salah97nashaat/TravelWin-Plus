class About {
  About({
    this.id,
    this.type,
    this.bodyEn,
    this.bodyAr,});

  About.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    bodyEn = json['body_en'];
    bodyAr = json['body_ar'];
  }
  int? id;
  String? type;
  String? bodyEn;
  String? bodyAr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['body_en'] = bodyEn;
    map['body_ar'] = bodyAr;
    return map;
  }

}
class Abou {
  Abou({
      this.status, 
      this.about,});

  Abou.fromJson(dynamic json) {
    status = json['status'];
    if (json['about'] != null) {
      about = [];
      json['about'].forEach((v) {
        about!.add(About.fromJson(v));
      });
    }
  }
  bool? status;
  List<About>? about;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (about != null) {
      map['about'] = about!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}