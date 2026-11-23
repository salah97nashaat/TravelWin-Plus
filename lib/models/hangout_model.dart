import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HangoutModel {
  final int id;
  final int userId;
  final String creatorName;
  final String creatorImage;
  final String creatorPhone;
  final String activityType;
  final String title;
  final int? placeId;
  final String? placeType;
  final String? placeName;
  final String? locationText;
  final double? lat;
  final double? long;
  final bool hasWinPass;
  final String? meetingDate;
  final String meetingTime;
  final int seatsNeeded;
  final int seatsJoined;
  final int availableSeats;
  final String? note;
  final String status;
  final DateTime? expiresAt;
  final int minutesLeft;
  final int requestsCount;
  final DateTime? createdAt;

  HangoutModel({
    required this.id,
    required this.userId,
    required this.creatorName,
    required this.creatorImage,
    required this.creatorPhone,
    required this.activityType,
    required this.title,
    this.placeId,
    this.placeType,
    this.placeName,
    this.locationText,
    this.lat,
    this.long,
    this.hasWinPass = false,
    this.meetingDate,
    required this.meetingTime,
    required this.seatsNeeded,
    this.seatsJoined = 0,
    this.availableSeats = 1,
    this.note,
    this.status = 'active',
    this.expiresAt,
    this.minutesLeft = 1440,
    this.requestsCount = 0,
    this.createdAt,
  });

  factory HangoutModel.fromJson(Map<String, dynamic> json) {
    return HangoutModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      creatorName: json['creator_name'] ?? 'مستخدم',
      creatorImage: json['creator_image'] ?? '',
      creatorPhone: json['creator_phone'] ?? '',
      activityType: json['activity_type'] ?? 'coffee',
      title: json['title'] ?? '',
      placeId: json['place_id'] != null ? int.tryParse(json['place_id'].toString()) : null,
      placeType: json['place_type'],
      placeName: json['place_name'],
      locationText: json['location_text'],
      lat: json['lat'] != null ? double.tryParse(json['lat'].toString()) : null,
      long: json['long'] != null ? double.tryParse(json['long'].toString()) : null,
      hasWinPass: json['has_win_pass'] == true,
      meetingDate: json['meeting_date'],
      meetingTime: json['meeting_time'] ?? '',
      seatsNeeded: json['seats_needed'] is int ? json['seats_needed'] : int.tryParse(json['seats_needed']?.toString() ?? '1') ?? 1,
      seatsJoined: json['seats_joined'] is int ? json['seats_joined'] : int.tryParse(json['seats_joined']?.toString() ?? '0') ?? 0,
      availableSeats: json['available_seats'] is int ? json['available_seats'] : int.tryParse(json['available_seats']?.toString() ?? '1') ?? 1,
      note: json['note'],
      status: json['status'] ?? 'active',
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at'].toString()) : null,
      minutesLeft: json['minutes_left'] is int ? json['minutes_left'] : int.tryParse(json['minutes_left']?.toString() ?? '0') ?? 0,
      requestsCount: json['requests_count'] is int ? json['requests_count'] : int.tryParse(json['requests_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  // --- Category Visual Helpers ---
  static IconData getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'billiard':
        return Icons.sports_esports_rounded;
      case 'tour':
        return Icons.photo_camera_rounded;
      case 'camp':
        return Icons.forest_rounded;
      case 'business':
        return Icons.business_center_rounded;
      case 'sport':
        return Icons.sports_soccer_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      default:
        return Icons.groups_rounded;
    }
  }

  static String getCategoryTitle(String type) {
    switch (type.toLowerCase()) {
      case 'coffee':
        return 'Coffee & Meet'.tr;
      case 'billiard':
        return 'Billiards & Games'.tr;
      case 'tour':
        return 'City Tour'.tr;
      case 'camp':
        return 'Camping & Trips'.tr;
      case 'business':
        return 'Business Meet'.tr;
      case 'sport':
        return 'Sports & Workout'.tr;
      case 'food':
        return 'Food & Dining'.tr;
      default:
        return 'Free Activity'.tr;
    }
  }

  static List<Color> getCategoryGradient(String type) {
    switch (type.toLowerCase()) {
      case 'coffee':
        return const [Color(0xFF8B5CF6), Color(0xFFA855F7)];
      case 'billiard':
        return const [Color(0xFF3B82F6), Color(0xFF60A5FA)];
      case 'tour':
        return const [Color(0xFFEC4899), Color(0xFFF472B6)];
      case 'camp':
        return const [Color(0xFF10B981), Color(0xFF34D399)];
      case 'business':
        return const [Color(0xFF6366F1), Color(0xFF818CF8)];
      case 'sport':
        return const [Color(0xFFF59E0B), Color(0xFFFBBF24)];
      case 'food':
        return const [Color(0xFFEF4444), Color(0xFFF87171)];
      default:
        return const [Color(0xFF6B7280), Color(0xFF9CA3AF)];
    }
  }

  /// Displays only the first name of creator as requested
  String get firstName {
    final parts = creatorName.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty && parts.first.isNotEmpty ? parts.first : 'مستخدم';
  }

  String get timeLeftFormatted {
    final isAr = Get.locale?.languageCode == 'ar';
    if (minutesLeft <= 0) return isAr ? 'منتهي' : 'Expired';
    final days = minutesLeft ~/ (24 * 60);
    final hours = (minutesLeft % (24 * 60)) ~/ 60;
    final mins = minutesLeft % 60;

    final prefix = isAr ? 'متبقي: ' : 'Left: ';
    if (days > 0) {
      if (hours > 0) {
        return isAr ? '$prefix$days يوم و $hours س' : '$prefix${days}d ${hours}h';
      }
      return isAr ? '$prefix$days ${days == 1 ? "يوم" : "أيام"}' : '$prefix${days}d';
    }
    if (hours > 0) {
      return isAr ? '$prefix$hours س و $mins د' : '$prefix${hours}h ${mins}m';
    }
    return isAr ? '$prefix$mins دقيقة' : '$prefix${mins}m';
  }
}
