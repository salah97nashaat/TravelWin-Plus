class Data {
  Data({
    this.total,});

  Data.fromJson(dynamic json) {
    total = json['total'];
  }
  int? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    return map;
  }

}
class Points {
  Points({
      this.status, 
      this.data,});

  Points.fromJson(dynamic json) {
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