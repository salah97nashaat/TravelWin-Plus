class CommentModel {
  String? userName, body;
  DateTime? date;

  CommentModel({this.userName, this.body, this.date});
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        body: json['body'], date: DateTime.tryParse(json['created_at']));
  }
}
