class Data {
  Data({
    this.number,});

  Data.fromJson(dynamic json) {
    number = json['number'];
  }
  String? number;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = number;
    return map;
  }

}
class Whatappnumbers {
  Whatappnumbers({
      this.status, 
      this.data,});

  Whatappnumbers.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}