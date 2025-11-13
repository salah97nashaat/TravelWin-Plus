class Images {
  Images({
      this.id, 
      this.url,});

  Images.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
  }
  int? id;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    return map;
  }

}