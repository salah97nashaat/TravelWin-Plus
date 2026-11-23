import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/Abou.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/models/Chats.dart';
import 'package:travelwin/models/FavoriteModel.dart' as fm;
import 'package:travelwin/models/Guidence.dart';
// import 'package:travelwin/models/Home.dart'as h;
import 'package:travelwin/models/MedicalTrip.dart';
import 'package:travelwin/models/NewHome.dart';
import 'package:travelwin/models/Notification.dart' as n;
import 'package:travelwin/models/Points.dart';
import 'package:travelwin/models/PropertiesModel.dart';
import 'package:travelwin/models/StatesPlaces.dart' as s;
import 'package:travelwin/models/Ticket.dart';
import 'package:travelwin/models/TicketTerm.dart';
import 'package:travelwin/models/TripModel.dart';
import 'package:travelwin/models/Whatappnumbers.dart';
import 'package:travelwin/models/profile_models.dart';
import 'package:travelwin/utils/theme.dart';

import '../logic/controllers/drop_down_controller.dart';
import '../models/State_places.dart';

String validationEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

String validationName = r'^[a-z A-Z]+$';
String validationAge = r'^[a-z A-Z]+$';
String baseUrl = 'https://travelwin1.com/new-travelwin/public/api';
String baseUrlApi = 'https://travelwin1.com/new-travelwin/public/api';
Rx<Profile> profile = Rx(Profile());

/// Checks if the current user profile is missing any mandatory fields
/// (Name, valid Mobile/Phone, and uploaded Profile Picture)
bool isUserProfileIncomplete() {
  final d = profile.value.data;
  if (d == null) return true;
  final hasName = d.name.trim().isNotEmpty && d.name != 'null';
  final hasPhone = d.mobile != 0 &&
      d.mobile.toString().trim().isNotEmpty &&
      d.mobile.toString() != 'null';
  final imageUrl = d.image.trim();
  final hasImage = imageUrl.isNotEmpty &&
      imageUrl != 'null' &&
      !imageUrl.endsWith('/public/') &&
      imageUrl != '/' &&
      (Uri.tryParse(imageUrl)?.hasScheme ?? false);
  return !(hasName && hasPhone && hasImage);
}
Rx<Guidence> guidence = Rx(Guidence());
Rx<Chats?> chats = Rx(Chats());
Rx<ChatMessages> chatMessages = Rx(ChatMessages());
Rx<String> guideName = Rx('');
Rx<String> guideImage = Rx('');
Rx<String> chatSubtitle = Rx('');
Rx<NewHome?> home = Rx(NewHome());
Rx<StatePlaces?> statePlacesForState = Rx(StatePlaces());
Rx<s.Data> statePlaces = Rx(s.Data());
Rx<String> stateImage = Rx('');
Rx<s.StatesPlaces> statesPlaces = Rx(s.StatesPlaces());
Rx<MedicalTrip?> medicalTrips = Rx(MedicalTrip());
Rx<TripModel?> tripModel = Rx(TripModel());
Rx<Trips?> trip = Rx(Trips());
Rx<String> realStateType = Rx('');
Rx<fm.FavoriteModel> favoriteModel = Rx(fm.FavoriteModel());
Rx<Properties> properties = Rx(Properties());
Rx<IstanbulTurkey> property = Rx(IstanbulTurkey());
Rx<int> stateId = Rx(0);
Rx<int> guidenceId = Rx(-1);
Rx<int> guidenceIndex = Rx(-1);
Rx<bool> isLoading = Rx(false);
TextEditingController nationality = TextEditingController();
TextEditingController businessPlaceEN = TextEditingController();
TextEditingController businessPlaceAR = TextEditingController();
TextEditingController languagesAR = TextEditingController();
TextEditingController languagesEN = TextEditingController();
TextEditingController bioAR = TextEditingController();
TextEditingController bioEN = TextEditingController();
TextEditingController dailyPay = TextEditingController();
TextEditingController space = TextEditingController();
TextEditingController propertyAgeController = TextEditingController();
TextEditingController rooms = TextEditingController();
TextEditingController bathrooms = TextEditingController();
TextEditingController areaAR = TextEditingController();
TextEditingController areaEn = TextEditingController();
TextEditingController floor = TextEditingController();
TextEditingController furnitureAR = TextEditingController();
TextEditingController furnitureEn = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController monthlyCost = TextEditingController();
TextEditingController descriptionAr = TextEditingController();
TextEditingController descriptionEn = TextEditingController();
TextEditingController locationEn = TextEditingController();
TextEditingController locationAr = TextEditingController();
DropDownController dropDownController = DropDownController(value: Rx('شقق'.tr));
DropDownController dropDownControllerForfur =
    DropDownController(value: Rx('yes'.tr));
DropDownController dropDownControllerForCur =
    DropDownController(value: Rx('lira turkey'.tr));
DropDownController dropDownControllerForPA =
    DropDownController(value: Rx('owner'.tr));
Rx<Points> points = Rx(Points());
Rx<Abou> about = Rx(Abou());
final GetStorage authBox = GetStorage();
String? email;
Whatappnumbers whatappnumbers = Whatappnumbers();
var token = authBox.read('token').toString().obs;
String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "acceptblue",
            "gatewayMerchantId": "1387-5908-4317"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TVHV2BA30",
      "merchantName": "travel win"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';
const String basicGooglePayIsReadyToPay = '''{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
        }
      }
    ],
  }
}''';
String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.travelwin",
    "displayName": "travel win",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["visa", "mastercard"],
    "countryCode": "US",
    "currencyCode": "USD"
  }
}''';
Rx<Ticket> tickets = Rx(Ticket());
Rx<int> stateid = Rx(0);
Rx<TicketTerm> ticketsTerm = Rx(TicketTerm());
Rx<n.Notification> notification = Rx(n.Notification());
RxInt unreadNotificationCount = 0.obs;

void updateUnreadNotificationCount() {
  final list = notification.value.notifications;
  if (list == null || list.isEmpty) {
    unreadNotificationCount.value = 0;
    return;
  }
  final lastReadId = GetStorage().read<int>('last_read_notification_id') ?? 0;
  unreadNotificationCount.value =
      list.where((item) => (item.id ?? 0) > lastReadId).length;
}

void markNotificationsAsRead() {
  final list = notification.value.notifications;
  if (list != null && list.isNotEmpty) {
    int maxId = 0;
    for (var item in list) {
      if ((item.id ?? 0) > maxId) maxId = item.id!;
    }
    GetStorage().write('last_read_notification_id', maxId);
  }
  unreadNotificationCount.value = 0;
}

void showSnackBar(BuildContext context, content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1),
  ));
}

dynamic showLoaderDialog() {
  return Get.dialog(
    Dialog(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.transparent),
        child: Center(
          child: CircularProgressIndicator(
            color: mainColor,
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

String arabic = 'Arabic 🇸🇦';
String english = 'English 🇬🇧';
String france = 'French 🇫🇷';

String ara = 'ar';
String ene = 'en';
String frf = 'fr';
