import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelwin/models/win_pass_model.dart';

class WinPassService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://travelwin1.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static final GetStorage _box = GetStorage();

  /// Reactive set of provider IDs that have an active Win Pass program
  static final RxSet<int> activeProviderIds = <int>{}.obs;
  static bool _isLoadingActiveIds = false;
  static bool _initialized = false;

  /// Initialize and load cached IDs + refresh from API
  static void init() {
    if (_initialized) return;
    _initialized = true;

    // 1. Read cached IDs immediately for instant UI rendering
    try {
      final cached = _box.read('win_pass_active_ids');
      if (cached is List) {
        final ids = cached
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .where((e) => e > 0)
            .toSet();
        activeProviderIds.assignAll(ids);
      }
    } catch (_) {}

    // 2. Fetch fresh list from API in background
    loadActiveProviderIds();
  }

  /// Fetch active provider IDs from backend
  static Future<void> loadActiveProviderIds() async {
    if (_isLoadingActiveIds) return;
    _isLoadingActiveIds = true;
    try {
      final response = await _dio.get('/win-pass/active-ids');
      if (response.statusCode == 200 && response.data != null) {
        final rawList = response.data['provider_ids'];
        if (rawList is List) {
          final ids = rawList
              .map((e) => int.tryParse(e.toString()) ?? 0)
              .where((e) => e > 0)
              .toSet();
          activeProviderIds.assignAll(ids);
          _box.write('win_pass_active_ids', ids.toList());
        }
      }
    } catch (_) {
      // Quietly ignore network failures; cached list remains in effect
    } finally {
      _isLoadingActiveIds = false;
    }
  }

  /// Helper to check if a provider has active Win Pass
  static bool hasWinPass(int providerId) {
    return activeProviderIds.contains(providerId);
  }

  /// Retrieve persistent unique user/device identifier
  static String getUserIdentifier() {
    var userId = _box.read('userid')?.toString();
    if (userId != null && userId.isNotEmpty && userId != 'null') {
      return 'user_$userId';
    }

    var guestId = _box.read('win_pass_guest_uuid')?.toString();
    if (guestId == null || guestId.isEmpty) {
      guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
      _box.write('win_pass_guest_uuid', guestId);
    }
    return guestId;
  }

  /// Fetch Win Pass details and steps for a specific provider
  static Future<WinPassProgramModel?> fetchProgram(int providerId) async {
    try {
      final userIdentifier = getUserIdentifier();
      final response = await _dio.get(
        '/win-pass/provider/$providerId',
        queryParameters: {'user_id': userIdentifier},
      );

      if (response.statusCode == 200 && response.data != null) {
        return WinPassProgramModel.fromJson(response.data);
      }
    } catch (e) {
      // Quietly return null on network error
    }
    return null;
  }

  /// Redeem either via scanned QR Token or 4-digit manual PIN
  static Future<WinPassRedeemResult> redeem({
    required int providerId,
    String? qrToken,
    String? pin,
  }) async {
    try {
      final userIdentifier = getUserIdentifier();
      final response = await _dio.post(
        '/win-pass/redeem',
        data: {
          'provider_id': providerId,
          'user_identifier': userIdentifier,
          if (qrToken != null && qrToken.isNotEmpty) 'token': qrToken,
          if (pin != null && pin.isNotEmpty) 'pin': pin,
        },
      );

      if (response.data != null) {
        return WinPassRedeemResult.fromJson(response.data);
      }
      return WinPassRedeemResult(
        success: false,
        message: 'استجابة غير متوقعة من الخادم.',
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          return WinPassRedeemResult(
            success: false,
            message: data['message'].toString(),
          );
        }
      }
      return WinPassRedeemResult(
        success: false,
        message: 'تعذر الاتصال بالخادم، يرجى التأكد من اتصال الإنترنت.',
      );
    } catch (e) {
      return WinPassRedeemResult(
        success: false,
        message: 'حدث خطأ أثناء معالجة الطلب.',
      );
    }
  }
}
