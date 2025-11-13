class LastMessageReceived {
  LastMessageReceived({
    this.id,
    this.message,
    this.url,
    this.type,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.byMe,});

  LastMessageReceived.fromJson(dynamic json) {
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

}
class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.dialcode,
    this.countryCode,
    this.mobile,
    this.gender,
    this.birthDate,
    this.livingCountry,
    this.image,
    this.lastMessageReceived,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dialcode = json['dialcode'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    livingCountry = json['living_country'];
    image = json['image'];
    lastMessageReceived = json['lastMessageReceived'] != null ? LastMessageReceived.fromJson(json['lastMessageReceived']) : null;
    lastMessageSended = json['lastMessageSended'] != null ? LastMessageReceived.fromJson(json['lastMessageSended']) : null;
  }
  int? id;
  String? name;
  String? email;
  String? dialcode;
  String? countryCode;
  String? mobile;
  String? gender;
  String? birthDate;
  String? livingCountry;
  String? image;
  LastMessageReceived? lastMessageReceived;
  LastMessageReceived? lastMessageSended;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['dialcode'] = dialcode;
    map['country_code'] = countryCode;
    map['mobile'] = mobile;
    map['gender'] = gender;
    map['birth_date'] = birthDate;
    map['living_country'] = livingCountry;
    map['image'] = image;
    if (lastMessageReceived != null) {
      map['lastMessageReceived'] = lastMessageReceived!.toJson();
    }
    return map;
  }

}
class Chats {
  Chats({
      this.status, 
      this.data,});

  Chats.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].reversed.forEach((v) {
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