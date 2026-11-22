import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelwin/logic/controllers/provider_controller.dart';
import 'package:travelwin/utils/constants.dart';
import 'package:travelwin/view/screens/services/provider_details.dart';
import 'package:travelwin/view/widgets/services/provider_list_tile.dart';
import '../../../helpers/adv/admob_banner.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  ProviderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var appBarBackColor = Colors.white;
    var appBarForeColor1 = mainColor2;

    // var appBarForeColor2 = Colors.black;
    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        surfaceTintColor: appBarBackColor,
        backgroundColor: appBarBackColor,
        foregroundColor: appBarForeColor1,
        title: Text("favorites".tr),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Expanded(
                    child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  children: [
                    ...controller.providers
                        .where((p) => p.isfav)
                        .map((e) => GestureDetector(
                            onTap: () {
                              Get.to(() => ProviderDetailsPage(provider: e));
                            },
                            child: ProviderListTile(provider: e)))
                  ],
                ))
              ]),
      ),
    );
  }
}
