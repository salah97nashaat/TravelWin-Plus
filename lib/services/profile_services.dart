import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:travelwin/models/Abou.dart';
import 'package:travelwin/models/ChatMessages.dart';
import 'package:travelwin/models/FavoriteModel.dart';
import 'package:travelwin/models/Guidence.dart';
import 'package:travelwin/models/MedicalTrip.dart';
import 'package:travelwin/models/Points.dart';
import 'package:travelwin/models/PropertiesModel.dart';
import 'package:travelwin/models/State_places.dart' as s;
import 'package:travelwin/models/StatesPlaces.dart';
import 'package:travelwin/models/Ticket.dart';
import 'package:travelwin/models/TicketTerm.dart';
import 'package:travelwin/models/TripModel.dart';
import 'package:travelwin/models/Whatappnumbers.dart';
import 'package:travelwin/models/activity_model.dart';
import 'package:travelwin/routes/routes.dart';
import 'package:travelwin/utils/my_string.dart';

import '../models/Chats.dart';
import '../models/NewHome.dart';
import '../models/profile_models.dart';

class RemoteServices {
  static var client = http.Client();
  static Dio dio = Dio(BaseOptions(
    headers: {},
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    validateStatus: (status) {
      return status! <= 500;
    },
  ));

  static Future<Profile?> fetchProfile() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/users/profile'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return profileFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<bool> submitActivityParticipation(
      Map<String, String> data, String? filePath) async {
    final GetStorage authBox = GetStorage();
    String token = authBox.read('token').toString();

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrlApi/leads/book'));

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields.addAll(data);

    if (filePath != null && filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  static Future<Chats?> fetchChats() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/chats'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print('CHATS');
      print(response.body);
      var jsonString = response.body;
      return Chats.fromJson(json.decode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<ChatMessages?> fetchChatMessages(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/chats/messages/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = response.body;
      chatMessages.value = ChatMessages.fromJson(json.decode(jsonString));
      return ChatMessages.fromJson(json.decode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<ActivityModel>?> fetchActivities() async {
    try {
      final authBox = GetStorage();
      final token = authBox.read('token')?.toString();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty && token != 'null') {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await client
          .get(Uri.parse('$baseUrl/activities'), headers: headers)
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        return activityModelFromJson(response.body);
      }
      return null;
    } catch (e) {
      print("Fetch Error: $e");
      return null;
    }
  }

  static Future<NewHome?> fetchHome() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/home'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return NewHome.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<s.StatePlaces?> fetchStateArea(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client
        .get(Uri.parse('${baseUrl}/home/places-types/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return s.StatePlaces.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<StatesPlaces?> fetchStateAreaPlaces(id, typeId, page) async {
    final GetStorage authBox = GetStorage();
    print('${baseUrl}/home/state-places/${id}/$typeId?page=$page');
    String token = authBox.read('token').toString();
    var response = await client.get(
        Uri.parse('${baseUrl}/home/state-places/${id}/$typeId?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return StatesPlaces.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<MedicalTrip?> fetchMedicalTrips() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/medical-trips'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return MedicalTrip.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<FavoriteModel?> fetchFavorite() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/favorites'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return FavoriteModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<TripModel?> fetchTrips() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/trips'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return TripModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<Whatappnumbers?> fetchWhatsApp() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/whatsapp-contact'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return Whatappnumbers.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<void> deleteAccount() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client
        .delete(Uri.parse('${baseUrl}/users/delete/account'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      g.Get.offAllNamed(Routes.welcomeScreen);
      authBox.remove('token');
    } else {
      //show error message
    }
  }

  static Future<Properties?> fetchProperties() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/properties'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      if (jsonString['properties'].toString() != '[]') {
        return Properties.fromJson(jsonString['properties']);
      }
      return Properties();
    } else {
      //show error message
      return null;
    }
  }

  static Future<Guidence?> fetchGuidences() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.get(Uri.parse('${baseUrl}/guidances'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonDecode(jsonString)['guidances'][1]);
      return Guidence.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<Points?> fetchPoint() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    // print('lll');
    var response = await client.get(Uri.parse('${baseUrl}/points'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).catchError((e) {
      print(e.toString());
      return http.Response.new('Internal Server Error', 500);
    });
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);
      return Points.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<Abou?> fetchAbout() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/about'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      //  print(jsonString);
      return Abou.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<Ticket?> fetchTickets() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/tickets'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      //  print(jsonString);
      return Ticket.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<TicketTerm?> fetchTicketsTerms() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.get(Uri.parse('${baseUrl}/terms'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      //  print(jsonString);
      return TicketTerm.fromJson(jsonDecode(jsonString));
    } else {
      //show error message
      return null;
    }
  }

  static Future<String?> dailyPoint() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.post(Uri.parse('${baseUrl}/points'), body: {
      'type': 'daily'
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 201) {
      var jsonString = jsonDecode(response.body);
      //  print(jsonString);
      return jsonString['message'];
    } else {
      //show error message
      return null;
    }
  }

  static Future<String?> addTicket() async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response = await client.post(Uri.parse('${baseUrl}/points'), body: {
      'type': 'ticket'
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 201) {
      var jsonString = jsonDecode(response.body);
      print(jsonString);
      return jsonString['message'];
    } else {
      //show error message
      var jsonString = jsonDecode(response.body);
      print(jsonString);
      return jsonString['message'];
    }
  }

  static Future<String?> ratePlace(id, rate) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.post(Uri.parse('${baseUrl}/places/rate/$id'), body: {
      'rate': rate.toString()
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      print(jsonString);
      return jsonString['message'];
    } else {
      //show error message
      var jsonString = jsonDecode(response.body);
      print(jsonString);
      return jsonString['message'];
    }
  }

  static Future<String> reserveGuidences(id, startDate, endDate) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.post(Uri.parse('${baseUrl}/reserve/$id'), body: {
      'start_date': startDate,
      'end_date': endDate
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      //  print(jsonString);
      return jsonString['message'];
    } else {
      //show error message
      return jsonString['message'];
    }
  }

  static Future<String> SendMessage(id, message, type) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    var response =
        await client.post(Uri.parse('${baseUrl}/chats/send-message'), body: {
      'receiver_id': id.toString(),
      'message': message,
      'type': type
    }, headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      //  print(jsonString);
      return jsonString['message'];
    } else {
      //show error message
      print(jsonString['message']);
      return jsonString['message'];
    }
  }

  static Future<String> addProperty(
      location_ar,
      location_en,
      square_size,
      furniture,
      currency,
      pa,
      description_ar,
      description_en,
      costs,
      rooms,
      bathrooms,
      price,
      floor,
      propertyType,
      paymentType,
      classification,
      age,
      List<XFile> images) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    List imageList = [];
    for (var i in images) {
      imageList.add(await MultipartFile.fromFile(i.path));
    }
    print(imageList);
    var response = await dio.post(('${baseUrl}/properties'),
        data: FormData.fromMap({
          'location_ar': location_ar,
          'location_en': location_en,
          'furniture': furniture,
          'currency': currency,
          'property_advertiser': pa,
          'square_size': square_size,
          'description_ar': description_ar,
          'description_en': description_en,
          'costs': costs,
          'rooms': rooms,
          'bathrooms': bathrooms,
          'price': price,
          'floor': floor,
          'payment_type': paymentType,
          'property_type': propertyType,
          'classification': classification,
          'age': age,
          'images[][image]': imageList
        }),
        options: Options(headers: {
          //'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }));
    //var jsonString = jsonDecode(response.data);
    if (response.statusCode == 200) {
      print(response.data);
      return response.data['message'];
    } else {
      isLoading.value = false;
      return response.data['message'];
    }
  }

  static Future<Response> becameGuidence(
      placesAR,
      placesEN,
      languageAR,
      languageEN,
      bioAR,
      bioEn,
      salary,
      imageId,
      license,
      car,
      licenseImage,
      nationality) async {
    final GetStorage authBox = GetStorage();
    // List<String> la = [jsonEncode(languageAR)];
    List<String> le = [jsonEncode(languageEN)];
    print(le);
    String token = authBox.read('token').toString();
    return await dio.post('/users/to-guidance',
        data: license == 1
            ? FormData.fromMap({
                'places_ar': placesAR,
                'places_en': placesEN,
                'languages_en[0]': jsonEncode(languageEN),
                'languages_ar[0]': jsonEncode(languageAR),
                'bio_en': bioEn,
                'bio_ar': bioAR,
                'salary': salary,
                'image_id': await MultipartFile.fromFile(imageId),
                'license': license,
                'car': car,
                'licenseImage': await MultipartFile.fromFile(licenseImage),
                'nationality': nationality
              })
            : FormData.fromMap({
                'places_ar': placesAR,
                'places_en': placesEN,
                'languages_en[0]': jsonEncode(languageEN),
                'languages_ar[0]': jsonEncode(languageAR),
                'bio_en': bioEn,
                'bio_ar': bioAR,
                'salary': salary,
                'image_id': await MultipartFile.fromFile(imageId),
                'license': license,
                'car': car,
                'nationality': nationality
              }),
        options: Options(headers: {'Authorization': 'Bearer ' + token}));
  }

  static Future<Response> addTripToFav(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    return await dio.put('/favorite/$id',
        options: Options(headers: {'Authorization': 'Bearer ' + token}));
  }

  static Future<Response> addGuideToFav(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    return await dio.put('/favorite/guidances/$id',
        options: Options(headers: {'Authorization': 'Bearer ' + token}));
  }

  static Future<Response> addPlaceToFav(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    return await dio.put('/favorite/places/$id',
        options: Options(headers: {'Authorization': 'Bearer ' + token}));
  }

  static Future<Response> addPropertyToFav(id) async {
    final GetStorage authBox = GetStorage();

    String token = authBox.read('token').toString();
    return await dio.put('/favorite/properties/$id',
        options: Options(headers: {'Authorization': 'Bearer ' + token}));
  }
}
