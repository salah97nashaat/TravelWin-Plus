import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class WeatherService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  static final RxList<Map<String, dynamic>> liveCitiesWeather = <Map<String, dynamic>>[
    {'nameAr': 'إسطنبول', 'nameEn': 'Istanbul', 'temp': '15°', 'icon': '🌤️'},
    {'nameAr': 'طرابزون', 'nameEn': 'Trabzon', 'temp': '7°', 'icon': '🌧️'},
    {'nameAr': 'أنطاليا', 'nameEn': 'Antalya', 'temp': '13°', 'icon': '☀️'},
    {'nameAr': 'كبادوكيا', 'nameEn': 'Cappadocia', 'temp': '4°', 'icon': '⛅'},
    {'nameAr': 'بورصة', 'nameEn': 'Bursa', 'temp': '8°', 'icon': '🌦️'},
    {'nameAr': 'ريزا', 'nameEn': 'Rize', 'temp': '10°', 'icon': '🌲'},
    {'nameAr': 'فتحية', 'nameEn': 'Fethiye', 'temp': '11°', 'icon': '🏖️'},
  ].obs;

  static Timer? _timer;
  static bool _isFetching = false;

  /// Start periodic real-time weather polling
  static void init() {
    fetchLiveWeather();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) {
      fetchLiveWeather();
    });
  }

  static Future<void> fetchLiveWeather() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      // Free public Open-Meteo endpoint for Turkish tourist cities in one call
      const url =
          'https://api.open-meteo.com/v1/forecast?latitude=41.0082,40.9833,36.8969,38.6431,40.1828,41.0201,36.6592&longitude=28.9784,39.7167,30.7133,34.8289,29.0667,40.5234,29.1263&current=temperature_2m,weather_code';

      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data is List) {
        final List list = response.data as List;
        final cityMeta = [
          {'nameAr': 'إسطنبول', 'nameEn': 'Istanbul'},
          {'nameAr': 'طرابزون', 'nameEn': 'Trabzon'},
          {'nameAr': 'أنطاليا', 'nameEn': 'Antalya'},
          {'nameAr': 'كبادوكيا', 'nameEn': 'Cappadocia'},
          {'nameAr': 'بورصة', 'nameEn': 'Bursa'},
          {'nameAr': 'ريزا', 'nameEn': 'Rize'},
          {'nameAr': 'فتحية', 'nameEn': 'Fethiye'},
        ];

        final List<Map<String, dynamic>> updated = [];
        for (int i = 0; i < list.length && i < cityMeta.length; i++) {
          final item = list[i];
          final current = item['current'];
          if (current != null) {
            final double tempVal = (current['temperature_2m'] as num).toDouble();
            final int code = (current['weather_code'] as num).toInt();
            final String icon = _codeToIcon(code);
            final String tempStr = '${tempVal.round()}°';

            updated.add({
              'nameAr': cityMeta[i]['nameAr']!,
              'nameEn': cityMeta[i]['nameEn']!,
              'temp': tempStr,
              'icon': icon,
            });
          }
        }

        if (updated.isNotEmpty) {
          liveCitiesWeather.assignAll(updated);
        }
      }
    } catch (e) {
      // Silently fall back to cached values without breaking UI
    } finally {
      _isFetching = false;
    }
  }

  static String _codeToIcon(int code) {
    if (code == 0) return '☀️';
    if (code == 1) return '🌤️';
    if (code == 2) return '⛅';
    if (code == 3) return '☁️';
    if (code >= 45 && code <= 48) return '🌫️';
    if (code >= 51 && code <= 67) return '🌧️';
    if (code >= 71 && code <= 77) return '❄️';
    if (code >= 80 && code <= 82) return '🌦️';
    if (code >= 95) return '⛈️';
    return '🌤️';
  }
}
