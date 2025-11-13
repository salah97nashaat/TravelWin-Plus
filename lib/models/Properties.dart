class Properties {
  Properties({
    this.properties,
  });

  Properties.fromJson(dynamic json) {
    if (json['properties'] != null) {
      properties = [];
      json['properties'].forEach((v) {
        properties!.add(Properties.fromJson(v));
      });
    }
  }
  List<Properties>? properties;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (properties != null) {
      map['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
