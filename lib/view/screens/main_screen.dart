// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import '../../logic/controllers/home_controller.dart';
import '../../logic/controllers/main_controller.dart';
import '../../logic/controllers/notification_count_controller.dart';
// import '../../utils/theme.dart';
import '../widgets/conex_bar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();

  //final controller =   Get.put(SettingController());
  final controller = Get.find<MainController>();
  final GetStorage authBox = GetStorage();
  final NotificationCountController notificationCountController =
      Get.put(NotificationCountController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            bottomNavigationBar: CustomNavigationBar(),
            body: IndexedStack(
              index: controller.currentIndex.value,
              children: controller.tabs,
            ),
          );
        },
      ),
    );
  }
}
