// import 'package:app/controllers/comments_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/models/comments_model.dart';
import 'package:travelwin/models/provider_model.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:travelwin/view/widgets/services/comment_card.dart';
import '../../../helpers/adv/admob_banner.dart';
// import 'package:get_storage/get_storage.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key, required this.provider});
  final ProviderModel provider;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  // final CommentsController controller = Get.put(CommentsController());
  final ProviderController controller = Get.find();
  List<CommentModel> comments = [];
  TextEditingController txtCommentController = TextEditingController();
  bool isLoading = false;
  // String txtComment = "";
  void getData() async {
    setState(() {
      isLoading = true;
    });
    // comments = await controller.getProviderComments(widget.provider);
    comments = widget.provider.comments;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        backgroundColor: mainColor3,
        foregroundColor: colorScheme2.onPrimary,
        title: Text("comments".tr),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.provider.comments.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      comment: widget.provider.comments[index],
                    );
                  },
                )),
                Container(
                  color: mainColor3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: txtCommentController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "add_comment".tr,
                          filled: true,
                          suffixIcon: IconButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var resp = await controller.addProviderComment(
                                    widget.provider, txtCommentController.text);

                                txtCommentController.clear();

                                setState(() {
                                  isLoading = false;
                                });
                                if (resp.statusCode != 200) {
                                  Get.dialog(AlertDialog(
                                    content: Text("cant_comment".tr),
                                    icon: const Icon(Icons.error),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("ok".tr))
                                    ],
                                  ));
                                }

                                // getData();
                              },
                              color: primaryColor2,
                              icon: const Icon(Icons.send))),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
