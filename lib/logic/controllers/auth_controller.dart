// import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:travelwin/const.dart';
import 'package:travelwin/models/facebook_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:dio/dio.dart' as d;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:travelwin/services/profile_services.dart';
import 'package:travelwin/utils/my_string.dart';

// import 'home_controller.dart';

class AuthController extends GetxController {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  var isLoading = false.obs;
  bool isVisibilty = false;
  bool isCheckBox = false;
  var displayUserId = ''.obs;
  var displayUserName = ''.obs;
  var displayUserPhoto = ''.obs;
  var displayUserEmail = ''.obs;
  var displayUserCountryDialCode = ''.obs;
  var displayUserCountryCode = ''.obs;
  var displayUserMobile = ''.obs;
  var displayUserToken = ''.obs;
  var displayUserAge = ''.obs;
  var dalyDate = ''.obs;
  var Name = ''.obs;

  var Email = ''.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn(
  //   scopes: <String>[
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );
  // NEW V7 WAY: Use the instance, do NOT use a constructor or scopes here!
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  FaceBookModel? faceBookModel;

  var isSignedIn = false;
  final GetStorage authBox = GetStorage();

  User? get userProfiloe => auth.currentUser;
  dynamic argumentData = Get.arguments;
  Rx<List<XFile>> images = Rx([]);
  @override
  void onInit() {
    // (userProfiloe != null ? userProfiloe!.displayName : "")!;
    // // displayUserPhoto.value =    (userProfiloe != null ? userProfiloe!.photoURL : "")!;
    // displayUserEmail.value = (userProfiloe != null ? userProfiloe!.email : "")!;
    googleSignIn.initialize();
    if (authBox.read("auth") == true || authBox.read("token") != null) {
      _updateFCMToken();
    }
    super.onInit();
  }

  void visibility() {
    isVisibilty = !isVisibilty;

    update();
  }

  void checkBox() {
    isCheckBox = !isCheckBox;

    update();
  }

  void signUpUsingFirebase({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        displayUserName.value = name;
        auth.currentUser!.updateDisplayName(name);
      });

      update();

      // Get.offNamed(Routes.mainScreen);
    } on FirebaseAuthException catch (error) {
      String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (error.code == 'weak-password') {
        message = ' Provided Password is too weak.. ';
      } else if (error.code == 'email-already-in-use') {
        message = ' Account Already exists for that email.. ';
      } else {
        message = error.message.toString();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error!',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  startsignUp({
    required String name,
    required String email,
    required String password,
    required String age,
    required String living,
    required String gender,
    required String mobile,
    required String countrydialcode,
    required String country_code,
  }) async {
    String apiurl = "${baseUrl}/register"; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    try {
      var response = await http.post(Uri.parse(apiurl), body: {
        'name': name,
        'email': email, //get the username text
        'password': password,
        'dialcode': countrydialcode,
        'country_code': country_code,
        'mobile': mobile,
        'birth_date': age,
        'living_country': 'turkey',
        'gender': gender == 'male'.tr ? 'male' : 'female',
        //get password text
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {
        // Get.snackbar(
        //   'logIn'.tr,
        //   'Please check your email to activate the account'.tr,
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        //Get.offAllNamed(Routes.loginScreen);
        logInUsingAPI(email: email, password: password);
        // authBox.write("auth", isSignedIn);
        // update();
        //  Get.to(());
      } else {
        Get.showSnackbar(GetSnackBar(
          message:
              '${'registered failed'.tr}\n${responsebody['message'].toString().tr}',
          duration: Duration(seconds: 5),
        ));
      }
    } catch (e) {}
  }

  forget({
    required String email,
  }) async {
    String apiurl =
        "https://travelwin1.com/new-travelwin/public/send-code"; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    var response = await http.post(Uri.parse(apiurl), body: {
      'email': email, //get the username text
    });
    var responsebody = jsonDecode(response.body);
    if (responsebody['status'] == true) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message:
            '${'Forgot Password'.tr}\n${'Your password reset request has been sent to your email'.tr}',
        duration: Duration(seconds: 5),
      ));
      Get.toNamed(Routes.enterCode);
      // authBox.write("auth", isSignedIn);
      // update();
      //  Get.to(());
    } else {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: '${'error'.tr}\n${responsebody['message']}',
        duration: Duration(seconds: 5),
      ));
    }
  }

  newPass({
    required String email,
    required String code,
    required String pass,
  }) async {
    String apiurl =
        "https://travelwin1.com/new-travelwin/public/rest/password"; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    var response = await http.post(Uri.parse(apiurl), body: {
      'email': email,
      'code': code,
      'password': pass //get the username text
    });
    var responsebody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: '${'Done'.tr}\n${'Your password reset successfully'.tr}',
        duration: Duration(seconds: 5),
      ));
      Get.offAllNamed(Routes.loginScreen);
      // authBox.write("auth", isSignedIn);
      // update();
      //  Get.to(());
    } else {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: '${'error'.tr}\n${responsebody['message']}',
        duration: Duration(seconds: 5),
      ));
    }
  }

  Future<void> fcmToken({required String fcm}) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    String apiurl = "${baseUrl}/users/fcm-token"; //api url
    await http.post(Uri.parse(apiurl), body: {
      'fcmToken': fcm, //get the username text
      // 'tokenfcm':token//get password text
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((value) {
      print(value.body);
    });
  }

  //======================logInUsingAPI=================================
  void logInUsingAPI({
    required String email,
    required String password,
  }) async {
    try {
      isLoading(true);
      String apiurl = "${baseUrl}/login";
      var response = await http.post(Uri.parse(apiurl), body: {
        'email': email,
        'password': password,
      });

      var responsebody = jsonDecode(response.body);

      if (responsebody['status'] == true) {
        // ---- START OF NEW LOGIC ----
        // 1. Successful Login: First, save the authentication token.
        authBox.write("token", responsebody['data']['token']);
        token.value = responsebody['data']['token'];
        isSignedIn = true;
        authBox.write("auth", isSignedIn);
        update();

        // 2. NOW it's safe to handle the FCM token.
        print("Login successful. Now handling FCM Token...");
        await _updateFCMToken(); // Call a dedicated function for this.

        // 3. Now proceed to fetch user data and navigate.
        Get.showSnackbar(GetSnackBar(
          message: '${'logIn'.tr}\n${'You are logged in successfully'.tr}',
          duration: Duration(seconds: 5),
        ));

        // Fetch all your data...
        // ... (your RemoteServices.fetch... calls)

        Get.offAllNamed(Routes.mainScreen);
        // ---- END OF NEW LOGIC ----
      } else {
        Get.showSnackbar(GetSnackBar(
          message:
              '${'login failed'.tr}${responsebody['message'].toString().tr}',
          duration: Duration(seconds: 5),
        ));
      }
    } catch (e) {
      // Add a catch block to see errors during login
      print("Error in logInUsingAPI: $e");
      Get.showSnackbar(GetSnackBar(message: 'An unexpected error occurred.'));
    } finally {
      isLoading(false);
    }
  }

// Create a new, reusable function in AuthController for the FCM logic.
  Future<void> _updateFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // 1. Request permission
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("User granted notification permission.");
        // 2. Get the token
        String? fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          print("FCM Token retrieved: $fcmToken");
          // 3. Send it to your server (using your existing fcmToken function)
          await this.fcmToken(
              fcm: fcmToken); // 'this.' is optional but good for clarity
          print("FCM Token sent to server.");
        } else {
          print("WARNING: Could not get FCM token. It was null.");
        }
      } else {
        print("User declined notification permission.");
      }
    } catch (e) {
      print("Error during FCM Token update: $e");
      // Don't block the login if this fails, just log it.
    }
  }

//============================appleSinUpApp==========================
  /// Generate a cryptographically secure nonce
  /// Generate cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Return the sha256 hash of [input] in hex notation
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> appleSignUpApp() async {
    try {
      isLoading(true);

      // 1. Generate nonce for Firebase
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // 2. Request Apple credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // 3. Sign in with Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

// Always get email safely
      displayUserEmail.value = user?.email ?? "";

// Try to build a full name
      String fullName = (appleCredential.givenName ?? '') +
          ' ' +
          (appleCredential.familyName ?? '');
      fullName = fullName.trim();

// Fallbacks if name is empty
      if (fullName.isEmpty) {
        fullName = user?.displayName ?? "";
      }
      if (fullName.isEmpty) {
        fullName = displayUserEmail.value.split('@').first; // use email prefix
      }
      if (fullName.isEmpty) {
        fullName = "Apple User"; // final fallback
      }

      displayUserName.value = fullName;
      displayUserPhoto.value = user?.photoURL ?? "";

// 4. Call your backend API
      String apiurl =
          "https://travelwin1.com/new-travelwin/public/google/login";

      var response = await http.post(Uri.parse(apiurl), body: {
        'email': displayUserEmail.value,
        'password':
            "applePass123", // generate/save per user if backend expects it
        'name': displayUserName.value,
      });

// Debug log
      print("responsebody is ${response.body}");

      final responsebody = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          responsebody['status'] == true) {
        authBox.write("token", responsebody['data']['token']);
        token.value = responsebody['data']['token'];

        GetSnackBar(
          message: '${'logIn'.tr}\n${'You are logged in successfully'.tr}',
          duration: Duration(seconds: 5),
        );

        isSignedIn = true;
        authBox.write("auth", isSignedIn);
        update();
        Get.offAllNamed(Routes.mainScreen);
      } else {
        Get.showSnackbar(GetSnackBar(
          message:
              '${'login failed'.tr}${responsebody['message'].toString().tr}',
          duration: Duration(seconds: 5),
        ));
        isLoading(false);
      }
    } catch (e) {
      print("Apple sign-in error: $e");
      isLoading(false);
      Get.snackbar(
        'Error!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

//============================googleSinUpApp==========================
  void googleSinUpApp() async {
    try {
      isLoading(true);

      // 1. NEW V7 WAY: Use .authenticate() instead of .signIn()
      // We pass 'scopeHint' here instead of at initialization!
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      displayUserName.value = googleUser.displayName ?? "";
      displayUserPhoto.value = googleUser.photoUrl ?? "";
      displayUserEmail.value = googleUser.email;

      // 2. Obtain Authentication Details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create Firebase Credential
      // CRITICAL FIX FOR NEW VERSION: For basic Firebase login, you only need the idToken!
      // Because Access Tokens are now handled strictly for authorization via authorizationClient.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // We do not pass accessToken here anymore to avoid authorization errors!
      );

      // 4. Sign in to Firebase
      await auth.signInWithCredential(credential);

      // 5. Call the API endpoint with a JSON request. Laravel uses the Accept
      // header to return validation failures as JSON instead of an HTML page.
      final apiurl = Uri.parse('$baseUrl/google/login');
      final response = await http.post(
        apiurl,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': displayUserEmail.value,
          'password': googlePass,
          'name': displayUserName.value,
        }),
      );

      final responsebody = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          responsebody['status'] == true) {
        authBox.write("token", responsebody['data']['token']);
        token.value = responsebody['data']['token'];

        isSignedIn = true;
        authBox.write("auth", isSignedIn);
        update();
        Get.offAllNamed(Routes.mainScreen);
      } else {
        final errors = responsebody['errors'];
        final firstValidationError = errors is Map && errors.isNotEmpty
            ? (errors.values.first is List && errors.values.first.isNotEmpty
                ? errors.values.first.first.toString()
                : errors.values.first.toString())
            : null;
        final message = firstValidationError ??
            responsebody['message']?.toString() ??
            'Google login failed (HTTP ${response.statusCode})';

        debugPrint(
            'Google login failed (${response.statusCode}): ${response.body}');
        Get.showSnackbar(GetSnackBar(
          message: message,
          duration: Duration(seconds: 5),
        ));
      }
    } catch (error) {
      print("Google Auth Error: $error");
      Get.snackbar('Error!', error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

//======================EditProfile=================================
  void EditProfile({
    required String id,
    required String name,
    required String age,
    required String mobile,
    required String email,
    required String country_code,
    required String dialcode,
    required String living_country,
    required String gender,
    required AuthController controller,
    String newImage = '',
  }) async {
    try {
      print(newImage);
      isLoading(true);
      String token = authBox.read('token').toString();
      d.Response<dynamic> response = await d.Dio().post('$baseUrl/users/update',
          options: d.Options(headers: {'Authorization': 'Bearer ' + token}),
          data: newImage == ''
              ? d.FormData.fromMap({
                  'name': name,
                  'email': email,
                  'dialcode': dialcode,
                  'country_code': country_code,
                  'mobile': mobile,
                  'birth_date': age,
                  'living_country': living_country,
                  'gender': gender == 'male'.tr ? 'male' : 'female'
                })
              : d.FormData.fromMap({
                  'name': name,
                  'email': email,
                  'dialcode': dialcode,
                  'country_code': country_code,
                  'mobile': mobile,
                  'birth_date': age,
                  'living_country': living_country,
                  'gender': gender == 'male'.tr ? 'male' : 'female',
                  'image': await d.MultipartFile.fromFile(newImage)
                }));
      print(response.data);
      if (response.statusCode == 200) {
        profile.value = (await RemoteServices.fetchProfile())!;
        authBox.write("username", name);
        authBox.write("age", age);
        authBox.write("mobile", mobile);
        authBox.write('usercountrydialcode', dialcode);
        authBox.write('usercountrycode', country_code);
        // profile.value.data!.email=email;
        // profile.value.data!.name=name;
        // profile.value.data!.dialcode=dialcode;
        // profile.value.data!.age=int.parse(age);
        // if(newImage!=''){
        //   profile.value.data!.image='';
        //   image.value = XFile(newImage);
        // }
        // profile.value.data!.country_code=country_code;
        // profile.value.data!.mobile=int.parse(mobile);
        // RemoteServices.fetchProfile();
        controller.isLoading.value = false;
        Get.back();
        Get.showSnackbar(GetSnackBar(
          message:
              '${'Edit account information'.tr}\n${'Profile modified successfully'.tr}',
          duration: Duration(seconds: 5),
        ));
        //   isSignedIn = true;
        //   authBox.write("auth", isSignedIn);
        update();
        //Get.offNamed(Routes.ProfileScreen);
      } else {
        controller.isLoading.value = false;
        Get.snackbar(
          'Edit failed'.tr,
          response.data['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  //======================logInUsingEmailAPI=================================
  void logInUsingEmailAPI({
    required String email,
    required String name,
  }) async {
    try {
      isLoading(true);
      String apiurl = "$baseUrlApi/auth/check_email"; //api url
      //dont use http://localhost , because emulator don't get that address
      //insted use your local IP address or use live URL
      //hit "ipconfig" in windows or "ip a" in linux to get you local IP

      var response = await http.post(Uri.parse(apiurl), body: {
        'email': email //get the username text
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {
        // displayUserName.value = responsebody['user']['name'];
        // displayUserEmail.value = email;
        // authBox.write("username", 'hhh');
        authBox.write("useremail", email);
        authBox.write("token", responsebody['access_token']);

        Get.snackbar(
          'logIn'.tr,
          'You are logged in successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isSignedIn = true;
        authBox.write("auth", isSignedIn);
        update();
        Get.offAllNamed(Routes.mainScreen);
      } else {
        //
        if (responsebody['message'] != "not verified email") {
          Get.toNamed(Routes.SignUpEmailScreen, arguments: [
            {
              "name": name,
              "email": email,
            },
          ]);
        } else
          Get.snackbar(
            'login failed'.tr,
            responsebody['message'].toString().tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<String> CheckEmailAPI({
    required String email,
    required String name,
  }) async {
    try {
      String apiurl = "$baseUrlApi/auth/check_email"; //api url
      //dont use http://localhost , because emulator don't get that address
      //insted use your local IP address or use live URL
      //hit "ipconfig" in windows or "ip a" in linux to get you local IP
      var response = await http.post(Uri.parse(apiurl), body: {
        'email': email //get the username text
      });
      var responsebody = jsonDecode(response.body);
      if (responsebody['status'] == true) {
        authBox.write("useremail", email);
        authBox.write("token", responsebody['access_token']);
        authBox.write("auth", isSignedIn);
        update();
        return 'yes';
      } else {
        //
        if (responsebody['message'] != "not verified email") {
          Get.snackbar(
            'login failed'.tr,
            responsebody['message'].toString().tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Get.toNamed(Routes.SignUpEmailScreen, arguments: [
          //   {"name": name,
          //     "email": email,
          //   },
          // ]);
          return 'no';
        } else
          return 'verified';
      }
    } finally {
      isLoading(false);
    }
  }

  void signOutFromApp() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      //   await FacebookAuth.i.logOut();
      displayUserName.value = '';
      displayUserPhoto.value = '';
      displayUserEmail.value = '';

      displayUserId.value = '';

      displayUserAge.value = '';

      displayUserCountryDialCode.value = '';
      displayUserCountryCode.value = '';
      displayUserMobile.value = '';
      displayUserToken.value = '';

      isSignedIn = false;
      authBox.remove("auth");
      update();

      Get.offAllNamed(Routes.welcomeScreen);
    } catch (error) {
      Get.snackbar(
        'Error!',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

// void faceBookSignUpApp() async {
//   final LoginResult loginResult = await FacebookAuth.instance.login();
//   // final accesToken = loginResult.accessToken!.token;
//   // final credential = FacebookAuthProvider.credential(accesToken);
//   // await auth.signInWithCredential(credential);
//   if (loginResult.status == LoginStatus.success) {
//     final data = await FacebookAuth.instance.getUserData();
//     faceBookModel = FaceBookModel.fromJson(data);
//     // displayUserPhoto.value = faceBookModel!.faceBookPhotoModel!.url!;
//     // displayUserEmail.value = faceBookModel!.email!;
//     // displayUserName.value = faceBookModel!.name!;
//     isSignedIn = true;
//     authBox.write("auth", isSignedIn);
//     update();
//     Get.offNamed(Routes.mainScreen);
//   }
// }

//
// void logInUsingFirebase({
//   required String email,
//   required String password,
// }) async {
//   try {
//     await auth
//         .signInWithEmailAndPassword(email: email, password: password)
//         .then((value) =>
//     displayUserName.value = auth.currentUser!.displayName!);
//
//     isSignedIn = true;
//     authBox.write("auth", isSignedIn);
//
//     update();
//     Get.offAllNamed(Routes.mainScreen);
//   } on FirebaseAuthException catch (error) {
//     String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
//     String message = '';
//
//     if (error.code == 'user-not-found') {
//       message =
//       ' Account does not exists for that $email.. Create your account by signing up..';
//     } else if (error.code == 'wrong-password') {
//       message = ' Invalid Password... PLease try again! ';
//     } else {
//       message = error.message.toString();
//     }
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   } catch (error) {
//     Get.snackbar(
//       'Error!',
//       error.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
// }

// void resetPassword(String email) async {
//   try {
//     await auth.sendPasswordResetEmail(email: email);
//
//     update();
//     Get.back();
//   } on FirebaseAuthException catch (error) {
//     String title = error.code.replaceAll(RegExp('-'), ' ').capitalize!;
//     String message = '';
//
//     if (error.code == 'user-not-found') {
//       message =
//       ' Account does not exists for that $email.. Create your account by signing up..';
//     } else {
//       message = error.message.toString();
//     }
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   } catch (error) {
//     Get.snackbar(
//       'Error!',
//       error.toString(),
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//   }
// }
}
