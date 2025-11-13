// import 'package:app/core/constants.dart';
// import 'package:app/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:travelwin/models/comments_model.dart';
import 'package:travelwin/utils/constants.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment.userName ?? ""),
                    Text(
                      formatDate(comment.date ?? DateTime.now()),
                      textDirection: TextDirection.ltr,
                    )
                  ],
                ),
                const Divider(),
                Text(comment.body!)
              ],
            ),
          )),
    );
  }
}
