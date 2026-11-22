import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travelwin/language/localiztion.dart';
import 'package:travelwin/logic/controllers/activities_controller.dart';
import 'package:travelwin/logic/controllers/adController.dart';
import 'package:travelwin/logic/controllers/auth_controller.dart';
import 'package:travelwin/logic/controllers/chat_controller.dart';
// import 'package:travelwin/logic/controllers/chat_controller.dart';
import 'package:travelwin/logic/controllers/theme_controller.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/services/win_pass_service.dart';
// import 'package:travelwin/services/profile_services.dart';
// import 'package:travelwin/services/notification_services.dart' as n;
import 'package:travelwin/utils/my_string.dart';
import 'package:travelwin/utils/theme.dart';
// import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'logic/controllers/home_controller.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(LoadingScreen()); // Show loading screen immediately

    // Run initializations in the background
    initializeServices().then((_) {
      // After initialization, check if user is logged in to decide the first screen
      final authBox = GetStorage();
      bool isLoggedIn = authBox.read("auth") ?? false;

      // If logged in, go to main screen, otherwise go to welcome screen.
      // NOTE: Get.put() your AuthController here so it's ready.
      Get.put(AuthController());
      Get.put(ActivitiesController());
      runApp(MyApp(isLoggedIn: isLoggedIn));

    }).catchError((error, stackTrace) {
      print("--- FATAL ERROR DURING INITIALIZATION ---");
      print("ERROR: $error");
      print("STACK TRACE: $stackTrace");
      print("-----------------------------------------");
      runApp(ErrorScreen(error: error.toString()));
    });
  } catch (e, stackTrace) {
    print("--- FATAL SYNCHRONOUS ERROR IN MAIN ---");
    print("ERROR: $e");
    print("---------------------------------------");
    runApp(ErrorScreen(error: e.toString()));
  }
}

/// This function now ONLY initializes services that DO NOT depend on a logged-in user.
Future<void> initializeServices() async {
  print("Main: Initializing GetStorage...");
  await GetStorage.init();
  print("Main: GetStorage initialized.");

  print("Main: Initializing Firebase...");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Main: Firebase initialized.");

  print("Main: Initializing MobileAds...");
  await MobileAds.instance.initialize();
  print("Main: MobileAds initialized.");

  // Your certificate logic remains here as it's a global setting.
  print("Main: Initializing asset bundle...");
  ByteData data = await PlatformAssetBundle().load('assets/ca/travelwin1.pem');
  print("Main: Asset loaded.");

  print("Main: Setting SecurityContext...");
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  print("Main: SecurityContext set.");

  // Controller initializations can also happen here
  Get.put(ChatController());
  Get.put(AdController());
  WinPassService.init();

  print("--- CORE SERVICES INITIALIZED SUCCESSFULLY ---");
}


// A simple, dependency-free widget to show while your app loads.
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// A simple, dependency-free widget to display an error if initialization fails.
class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "FATAL: The application could not start.\n\nError:\n$error",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({Key? key,required this.isLoggedIn}) : super(key: key);
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          392.7, 737.5), //android //iphone 11 pro // Size(375.0, 812.0),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'travel win',
          debugShowCheckedModeBanner: false,
          locale: GetStorage().read<String>('lang') == null
              ? Locale(ene)
              : Locale(GetStorage().read<String>('lang').toString()),
        
          translations: LocaliztionApp(),
          fallbackLocale:GetStorage().read<String>('lang').toString()==null? (Get.deviceLocale=='ar_GB'?Locale(ara):Locale(ene)) :Locale(GetStorage().read<String>('lang').toString()) ,
          builder: (context, child) => child!,
          theme: ThemesApp.light,
          darkTheme: ThemesApp.dark,
          themeMode: ThemeController().themeDataGet,
          initialRoute: isLoggedIn ? Routes.mainScreen : Routes.welcomeScreen,
          getPages: AppRoutes.routes,
        );
      },
    );
  }
}
