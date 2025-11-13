class Notifications {
  Notifications({
    this.id,
    this.title,
    this.titleAr,
    this.body,
    this.bodyAr,
    this.winId,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Notifications.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    titleAr = json['title_ar'];
    body = json['body'];
    bodyAr = json['body_ar'];
    winId = json['win_id'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? title;
  String? titleAr;
  String? body;
  String? bodyAr;
  int? winId;
  int? status;
  dynamic userId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['title_ar'] = titleAr;
    map['body'] = body;
    map['body_ar'] = bodyAr;
    map['win_id'] = winId;
    map['status'] = status;
    map['user_id'] = userId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class Notification {
  Notification({
    this.status,
    this.notifications,
  });

  Notification.fromJson(dynamic json) {
    status = json['status'];
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }
  bool? status;
  List<Notifications>? notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (notifications != null) {
      map['notifications'] = notifications!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
