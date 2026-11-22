import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/hangout_model.dart';
import 'package:travelwin/utils/my_string.dart';

class HangoutService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://travelwin1.com/api',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static final GetStorage _box = GetStorage();

  /// Fetch active hangouts
  static Future<List<HangoutModel>> fetchHangouts({String? activityType}) async {
    try {
      final res = await _dio.get(
        '/hangouts',
        queryParameters: {
          if (activityType != null && activityType != 'all')
            'activity_type': activityType,
        },
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final list = res.data['hangouts'] as List;
        return list.map((item) => HangoutModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching hangouts: $e');
      return [];
    }
  }

  /// Create a new hangout (Protected by profile completion check)
  static Future<Map<String, dynamic>> createHangout({
    required String activityType,
    required String title,
    int? placeId,
    String? placeName,
    String? locationText,
    required String meetingTime,
    String? meetingDate,
    required int seatsNeeded,
    String? note,
  }) async {
    // Client-side profile completion gate
    if (isUserProfileIncomplete()) {
      return {
        'success': false,
        'error_code': 'PROFILE_INCOMPLETE',
        'message':
            'يجب إكمال ملفك الشخصي (الاسم، رقم الهاتف، والصورة الشخصية) قبل إنشاء نشاط.',
      };
    }

    final userData = profile.value.data;
    final payload = {
      'user_id': userData?.id ?? 0,
      'user_name': userData?.name ?? '',
      'user_phone': userData?.mobile != null ? userData!.mobile.toString() : '',
      'user_image': userData?.image ?? '',
      'activity_type': activityType,
      'title': title,
      'place_id': placeId,
      'place_name': placeName,
      'location_text': locationText,
      'meeting_time': meetingTime,
      'meeting_date': meetingDate,
      'seats_needed': seatsNeeded,
      'note': note,
    };

    try {
      final res = await _dio.post('/hangouts', data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return {
          'success': true,
          'message': res.data['message'] ?? 'تم إنشاء النشاط بنجاح!',
          'hangout': HangoutModel.fromJson(res.data['hangout']),
        };
      }
      return {
        'success': false,
        'message': res.data['message'] ?? 'فشل إنشاء النشاط',
      };
    } on DioException catch (dioErr) {
      if (dioErr.response?.data != null && dioErr.response?.data is Map) {
        final data = dioErr.response!.data as Map;
        return {
          'success': false,
          'error_code': data['error_code'],
          'message': data['message'] ?? 'حدث خطأ أثناء إنشاء النشاط',
        };
      }
      return {
        'success': false,
        'message': 'تعذر الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }

  /// Search places and partners for autocomplete
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final res = await _dio.get(
        '/hangouts/places',
        queryParameters: {'q': query},
      );
      if (res.statusCode == 200 && res.data['success'] == true) {
        final list = res.data['places'] as List;
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  /// Send a join request
  static Future<Map<String, dynamic>> joinHangout(
    int hangoutId, {
    String? message,
  }) async {
    if (isUserProfileIncomplete()) {
      return {
        'success': false,
        'error_code': 'PROFILE_INCOMPLETE',
        'message':
            'يجب إكمال ملفك الشخصي (الاسم، رقم الهاتف، والصورة الشخصية) قبل طلب الانضمام.',
      };
    }

    final userData = profile.value.data;
    try {
      final res = await _dio.post(
        '/hangouts/$hangoutId/join',
        data: {
          'user_id': userData?.id ?? 0,
          'user_name': userData?.name ?? '',
          'user_phone': userData?.mobile != null ? userData!.mobile.toString() : '',
          'user_image': userData?.image ?? '',
          'message': message ?? 'مهتم بالانضمام للنشاط',
        },
      );
      return {
        'success': res.data['success'] == true,
        'message': res.data['message'] ?? '',
      };
    } on DioException catch (dioErr) {
      final msg = dioErr.response?.data?['message'] ??
          'تعذر إرسال طلب الانضمام، حاول مرة أخرى';
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': 'حدث خطأ غير متوقع'};
    }
  }

  /// Submit a complaint / report against a hangout
  static Future<Map<String, dynamic>> reportHangout(
    int hangoutId, {
    required String reason,
    String? details,
  }) async {
    final userData = profile.value.data;
    try {
      final res = await _dio.post(
        '/hangouts/$hangoutId/report',
        data: {
          'user_id': userData?.id ?? 0,
          'reason': reason,
          'details': details ?? '',
        },
      );
      return {
        'success': res.data['success'] == true,
        'message': res.data['message'] ?? 'تم إرسال البلاغ بنجاح',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'تعذر إرسال البلاغ حالياً، يرجى المحاولة لاحقاً',
      };
    }
  }

  /// Cancel own hangout
  static Future<bool> cancelHangout(int hangoutId) async {
    try {
      final res = await _dio.post('/hangouts/$hangoutId/cancel');
      return res.data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
