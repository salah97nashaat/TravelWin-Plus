class States {
  States({
    this.id,
    this.nameAr,
    this.nameEn,
    this.image,
  });

  States.fromJson(dynamic json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    image = json['image'];
  }
  int? id;
  String? nameAr;
  String? nameEn;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['image'] = image;
    return map;
  }
}

class Banners {
  Banners({
    this.id,
    this.titleAr,
    this.titleEn,
    this.image,
    this.type,
    this.link,
    this.createdAt,
  });

  Banners.fromJson(dynamic json) {
    id = json['id'];
    titleAr = json['title_ar'];
    titleEn = json['title_en'];
    image = json['image'];
    type = json['type'];
    link = json['link'];
    createdAt = json['createdAt'];
  }
  int? id;
  String? titleAr;
  String? titleEn;
  String? image;
  String? type;
  dynamic link;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title_ar'] = titleAr;
    map['title_en'] = titleEn;
    map['image'] = image;
    map['type'] = type;
    map['link'] = link;
    map['createdAt'] = createdAt;
    return map;
  }
}

class Data {
  Data({
    this.states,
    this.banners,
  });

  Data.fromJson(dynamic json) {
    if (json['states'] != null) {
      states = [];
      json['states'].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
  }
  List<States>? states;
  List<Banners>? banners;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (states != null) {
      map['states'] = states!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      map['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NewHome {
  NewHome({
    this.status,
    this.data,
  });

  NewHome.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}
