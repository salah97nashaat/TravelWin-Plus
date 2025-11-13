class Data {
  Data({
    this.id,
    this.message,
    this.url,
    this.type,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.byMe,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    message = json['message'];
    url = json['url'];
    type = json['type'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    createdAt = json['created_at'];
    byMe = json['byMe'];
  }
  int? id;
  String? message;
  String? url;
  String? type;
  int? senderId;
  int? receiverId;
  String? createdAt;
  bool? byMe;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['message'] = message;
    map['url'] = url;
    map['type'] = type;
    map['sender_id'] = senderId;
    map['receiver_id'] = receiverId;
    map['created_at'] = createdAt;
    map['byMe'] = byMe;
    return map;
  }

}class ChatMessages {
  ChatMessages({
      this.status, 
      this.data,});

  ChatMessages.fromJson(dynamic json) {
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