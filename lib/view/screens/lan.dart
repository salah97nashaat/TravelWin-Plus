import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:travelwin/logic/controllers/auth_controller.dart';
// import 'package:travelwin/routes/routes.dart';
// import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:travelwin/view/screens/auth/forgot_password_screen.dart';
import 'package:travelwin/view/screens/mydrawer.dart';
// import 'package:travelwin/view/widgets/auth/auth_button.dart';
// import 'package:travelwin/view/widgets/auth/auth_text_from_field.dart';
// import 'package:travelwin/view/widgets/auth/container_under.dart';
// import 'package:travelwin/view/widgets/text_utils.dart';

class Lan extends StatelessWidget {
  Lan({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : mainColor,
          elevation: 0,
          title: const Text('Welcome to Flutter'),
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('من : '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
