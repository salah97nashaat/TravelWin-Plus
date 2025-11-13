import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/service_state_controller.dart';
import 'package:travelwin/models/service_state_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/constants.dart';
// import 'package:travelwin/view/screens/services/service_chooser.dart';
import 'package:travelwin/view/widgets/services/state_grid_tile.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';

class StateChooser extends GetView<ServiceStateController> {
  const StateChooser({super.key, this.onStateChoosen});
  final Function(ServiceStateModel state)? onStateChoosen;

  // var states = <ServiceStateModel>[];
  @override
  Widget build(BuildContext context) {
    // var states = ['Istanbul', 'Izmir', 'Hatay'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor3,
        foregroundColor: colorScheme2.onPrimary,
        title: Text("choose_state".tr),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Icon(Icons.info),
                  content: Text(
                    "You can change state later".tr,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Ok".tr))
                  ],
                ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(() => controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                children: controller.states
                    .map((e) => GestureDetector(
                          onTap: () async {
                            await controller.setState(e);
                            if (onStateChoosen != null) {
                              print(e);
                              onStateChoosen?.call(e);
                            } else {
                              goToServiceChooser(e);
                            }
                          },
                          child: StateGridTile(model: e),
                        ))
                    .toList(),
              ),
            )),
    );
  }

  void goToServiceChooser(ServiceStateModel state) {
    // String? args;
    // if (Get.arguments != null) {
    //   args = Get.arguments['from'];
    // }

    // if (args != null) {
    //   Get.back();
    // } else {
    //   Get.off(() => const ServiceChooser());
    // }
    Get.toNamed(Routes.serviceChooser);
  }
}
