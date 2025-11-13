class Terms {
  Terms({
    this.id,
    this.titleEn,
    this.titleAr,
    this.bodyAr,
    this.bodyEn,});

  Terms.fromJson(dynamic json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    bodyAr = json['body_ar'];
    bodyEn = json['body_en'];
  }
  int? id;
  String? titleEn;
  String? titleAr;
  String? bodyAr;
  String? bodyEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title_en'] = titleEn;
    map['title_ar'] = titleAr;
    map['body_ar'] = bodyAr;
    map['body_en'] = bodyEn;
    return map;
  }

}
class TicketTerm {
  TicketTerm({
      this.status, 
      this.terms,});

  TicketTerm.fromJson(dynamic json) {
    status = json['status'];
    if (json['terms'] != null) {
      terms = [];
      json['terms'].forEach((v) {
        terms!.add(Terms.fromJson(v));
      });
    }
  }
  bool? status;
  List<Terms>? terms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (terms != null) {
      map['terms'] = terms!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}