import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/models/Notification.dart';
import 'package:travelwin/services/notification_services.dart' as n;
import 'package:travelwin/utils/my_string.dart';

class ViewNotificationScreen extends StatefulWidget {
  const ViewNotificationScreen({Key? key}) : super(key: key);

  @override
  State<ViewNotificationScreen> createState() => _ViewNotificationScreenState();
}

class _ViewNotificationScreenState extends State<ViewNotificationScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  Future<void> _refreshNotifications() async {
    setState(() => _isLoading = true);
    try {
      final res = await n.RemoteServices.fetchNotifications('1');
      if (res != null) {
        notification.value = res;
      }
    } catch (_) {}
    markNotificationsAsRead();
    if (mounted) setState(() => _isLoading = false);
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 60) {
        final m = diff.inMinutes;
        return Get.locale?.languageCode == 'ar'
            ? 'منذ ${m <= 1 ? "دقيقة" : "$m دقيقة"}'
            : '${m <= 1 ? "1 min" : "$m mins"} ago';
      } else if (diff.inHours < 24) {
        final h = diff.inHours;
        return Get.locale?.languageCode == 'ar'
            ? 'منذ ${h <= 1 ? "ساعة" : "$h ساعة"}'
            : '${h <= 1 ? "1 hr" : "$h hrs"} ago';
      } else if (diff.inDays < 7) {
        final d = diff.inDays;
        return Get.locale?.languageCode == 'ar'
            ? 'منذ ${d <= 1 ? "يوم" : "$d أيام"}'
            : '${d <= 1 ? "1 day" : "$d days"} ago';
      } else {
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      }
    } catch (_) {
      return dateStr;
    }
  }

  void _showNotificationDetails(Notifications item) {
    final title = (Get.locale?.languageCode == 'ar' ? item.titleAr : item.title) ??
        item.titleAr ??
        item.title ??
        '';
    final body = (Get.locale?.languageCode == 'ar' ? item.bodyAr : item.body) ??
        item.bodyAr ??
        item.body ??
        '';

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      if (item.createdAt != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          _formatDateTime(item.createdAt),
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                body,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: const Color(0xFF334155),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Back'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
            color: const Color(0xFF1E293B),
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Notifications".tr,
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        color: const Color(0xFF2563EB),
        child: Obx(() {
          final list = notification.value.notifications;

          if (_isLoading && (list == null || list.isEmpty)) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          if (list == null || list.isEmpty) {
            return ListView(
              children: [
                SizedBox(height: 120.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(22.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF3B82F6),
                          size: 48,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'No notifications yet'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        isAr
                            ? 'ستصلك هنا كافة التحديثات والعروض وإشعارات أنشطتك'
                            : 'All updates, offers and activity alerts will appear here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            itemCount: list.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final item = list[index];
              final title = (isAr ? item.titleAr : item.title) ??
                  item.titleAr ??
                  item.title ??
                  '';
              final body = (isAr ? item.bodyAr : item.body) ??
                  item.bodyAr ??
                  item.body ??
                  '';
              final timeStr = _formatDateTime(item.createdAt);

              return InkWell(
                onTap: () => _showNotificationDetails(item),
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                if (timeStr.isNotEmpty)
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      fontSize: 10.5.sp,
                                      color: const Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5.sp,
                                color: const Color(0xFF475569),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
