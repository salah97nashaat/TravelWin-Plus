import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  // Current app version & build number matching pubspec.yaml
  static const String currentVersion = "1.0.8";
  static const int currentBuild = 55;

  static const String _apiUrl = "https://travelwin1.com/api/app-version";
  static const String _defaultIosUrl = "https://apps.apple.com/app/id6738106116";
  static const String _defaultAndroidUrl = "https://play.google.com/store/apps/details?id=com.travelwin1.travelwin";

  static final GetStorage _box = GetStorage();
  static bool _dialogShowing = false;

  /// Check server for new version and prompt user if an update is available.
  static Future<void> checkForUpdate({bool manualTrigger = false}) async {
    try {
      // If not manual trigger, check if user dismissed recently (wait 8 hours before prompting again)
      if (!manualTrigger) {
        final lastDismissed = _box.read<int>('last_update_prompt_timestamp') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        final eightHoursMs = 8 * 60 * 60 * 1000;
        if (now - lastDismissed < eightHoursMs) {
          return;
        }
      }

      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);
      if (data == null || data['data'] == null) return;

      final serverData = data['data'];
      final latestBuild = int.tryParse(serverData['latest_build']?.toString() ?? '0') ?? 0;
      final latestVersion = serverData['latest_version']?.toString() ?? currentVersion;
      final bool forceUpdate = serverData['force_update'] == true;

      // Determine if update is available
      final isNewerBuild = latestBuild > currentBuild;
      final isNewerVersion = _isVersionHigher(latestVersion, currentVersion);

      if (isNewerBuild || isNewerVersion) {
        final isArabic = Get.locale?.languageCode == 'ar' || (Get.locale == null);

        final title = isArabic
            ? (serverData['title_ar'] ?? 'تحديث جديد متوفر 🚀')
            : (serverData['title_en'] ?? 'New Update Available 🚀');

        final message = isArabic
            ? (serverData['message_ar'] ?? 'يتوفر إصدار جديد من تطبيق Travel Win بميزات وتحسينات مهمة. يرجى التحديث للحصول على أفضل تجربة.')
            : (serverData['message_en'] ?? 'A new version of Travel Win is available with performance improvements and new features. Update now for the best experience.');

        String storeUrl;
        if (!kIsWeb && Platform.isIOS) {
          storeUrl = serverData['ios_url'] ?? _defaultIosUrl;
        } else {
          storeUrl = serverData['android_url'] ?? _defaultAndroidUrl;
        }

        _showUpdateDialog(
          title: title,
          message: message,
          latestVersion: latestVersion,
          storeUrl: storeUrl,
          forceUpdate: forceUpdate,
          isArabic: isArabic,
        );
      }
    } catch (e) {
      debugPrint('[AppUpdateService] Check failed silently: $e');
    }
  }

  /// Compares semantic version strings e.g. "1.0.9" vs "1.0.8"
  static bool _isVersionHigher(String vNew, String vCurrent) {
    try {
      final newParts = vNew.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final curParts = vCurrent.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < 3; i++) {
        final n = i < newParts.length ? newParts[i] : 0;
        final c = i < curParts.length ? curParts[i] : 0;
        if (n > c) return true;
        if (n < c) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Launch store link
  static Future<void> _openStore(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[AppUpdateService] Error opening store: $e');
    }
  }

  /// Shows the stylish in-app update popup
  static void _showUpdateDialog({
    required String title,
    required String message,
    required String latestVersion,
    required String storeUrl,
    required bool forceUpdate,
    required bool isArabic,
  }) {
    if (_dialogShowing) return;
    _dialogShowing = true;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => !forceUpdate,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 12,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header with Gradient
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0284C7), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.system_update_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),

                // Version Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    isArabic ? "الإصدار: $latestVersion" : "Version: $latestVersion",
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 24),

                // Update Now Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _openStore(storeUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? "تحديث الآن" : "Update Now",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Later Button (only if not force update)
                if (!forceUpdate) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: TextButton(
                      onPressed: () {
                        _box.write('last_update_prompt_timestamp', DateTime.now().millisecondsSinceEpoch);
                        _dialogShowing = false;
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isArabic ? "لاحقاً" : "Later",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !forceUpdate,
    ).then((_) {
      _dialogShowing = false;
    });
  }
}
