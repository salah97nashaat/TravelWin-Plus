import 'package:get/get.dart';
import 'package:travelwin/models/comments_model.dart';
import 'package:travelwin/models/provider_model.dart';

class CommentsController extends GetxController {
  List<CommentModel> comments = <CommentModel>[].obs;
  // var isLoading = false.obs;

  Future getComments(ProviderModel provider) async {
    // isLoading(true);
    await Future.delayed(const Duration(seconds: 3));
    comments.clear();

    // isLoading(false);
  }
}
