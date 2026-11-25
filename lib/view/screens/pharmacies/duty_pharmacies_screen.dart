import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelwin/helpers/adv/admob_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class DutyPharmaciesScreen extends StatefulWidget {
  const DutyPharmaciesScreen({Key? key}) : super(key: key);

  @override
  State<DutyPharmaciesScreen> createState() => _DutyPharmaciesScreenState();
}

class _DutyPharmaciesScreenState extends State<DutyPharmaciesScreen> {
  // Supported Cities list (all 81 loaded from server or fallback)
  List<Map<String, dynamic>> _cities = [
    {'id': 'istanbul', 'name_tr': 'İstanbul', 'name_ar': 'إسطنبول', 'name_en': 'Istanbul', 'popular': true},
    {'id': 'bursa', 'name_tr': 'Bursa', 'name_ar': 'بورصة', 'name_en': 'Bursa', 'popular': true},
    {'id': 'antalya', 'name_tr': 'Antalya', 'name_ar': 'أنطاليا', 'name_en': 'Antalya', 'popular': true},
    {'id': 'trabzon', 'name_tr': 'Trabzon', 'name_ar': 'طرابزون', 'name_en': 'Trabzon', 'popular': true},
    {'id': 'sakarya', 'name_tr': 'Sakarya (Sapanca)', 'name_ar': 'سكاريا (سبانجا)', 'name_en': 'Sakarya (Sapanca)', 'popular': true},
    {'id': 'yalova', 'name_tr': 'Yalova', 'name_ar': 'يلوا', 'name_en': 'Yalova', 'popular': true},
    {'id': 'mugla', 'name_tr': 'Muğla (Bodrum/Fethiye)', 'name_ar': 'موغلا (بودروم/فتحية)', 'name_en': 'Mugla (Bodrum/Fethiye)', 'popular': true},
    {'id': 'ankara', 'name_tr': 'Ankara', 'name_ar': 'أنقرة', 'name_en': 'Ankara', 'popular': true},
    {'id': 'izmir', 'name_tr': 'İzmir', 'name_ar': 'إزمير', 'name_en': 'Izmir', 'popular': true},
    {'id': 'gaziantep', 'name_tr': 'Gaziantep', 'name_ar': 'غازي عنتاب', 'name_en': 'Gaziantep', 'popular': true},
    {'id': 'nevsehir', 'name_tr': 'Nevşehir (Kapadokya)', 'name_ar': 'نوشهير (كابادوكيا)', 'name_en': 'Nevsehir (Cappadocia)', 'popular': true},
    {'id': 'rize', 'name_tr': 'Rize', 'name_ar': 'ريزا', 'name_en': 'Rize', 'popular': true},
  ];

  String _selectedCityId = 'istanbul';
  String _selectedCityNameTr = 'İstanbul';
  String _selectedCityNameAr = 'إسطنبول';
  String _selectedCityNameEn = 'Istanbul';

  List<String> _districts = [];
  String _selectedDistrict = ''; // '' means all

  List<Map<String, dynamic>> _pharmacies = [];
  List<Map<String, dynamic>> _filteredPharmacies = [];

  bool _isLoading = true;
  bool _isLocating = false;
  bool _isSortingByDistance = false;
  String _errorMessage = '';

  // User GPS position
  Position? _userPosition;

  // Local Geocoding memory cache to avoid repeated lookups
  final Map<String, Location> _geocodeCache = {};

  final TextEditingController _searchController = TextEditingController();

  static const String _apiBase = 'https://travelwin1.com/api/pharmacies';

  @override
  void initState() {
    super.initState();
    _fetchCities();
    _fetchDutyPharmacies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetch all 81 cities from backend API
  Future<void> _fetchCities() async {
    try {
      final res = await http.get(Uri.parse('$_apiBase/cities')).timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] is List) {
          if (mounted) {
            setState(() {
              _cities = List<Map<String, dynamic>>.from(data['data']);
            });
          }
        }
      }
    } catch (_) {
      // Keep static default list on connection error
    }
  }

  /// Fetch duty pharmacies for selected city
  Future<void> _fetchDutyPharmacies() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse('$_apiBase/duty?city=$_selectedCityId');
      final res = await http.get(url).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true) {
          final list = List<Map<String, dynamic>>.from(data['data'] ?? []);
          final distList = List<String>.from(data['districts'] ?? []);

          if (mounted) {
            setState(() {
              _pharmacies = list;
              _districts = distList;
              _selectedDistrict = ''; // Reset district filter on city change
              _isLoading = false;
              _applyLocalFilter();
            });

            // If user location is already available and distance sort is active, re-calculate
            if (_userPosition != null && _isSortingByDistance) {
              _calculateDistancesAndSort();
            }
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = Get.locale?.languageCode == 'ar'
              ? 'تعذر تحميل بيانات الصيدليات. يرجى المحاولة مرة أخرى.'
              : 'Failed to load pharmacies data. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = Get.locale?.languageCode == 'ar'
              ? 'حدث خطأ في الاتصال بالسيرفر. تحقق من اتصال الإنترنت.'
              : 'Connection error. Please check your internet connection.';
        });
      }
    }
  }

  /// Filter locally by district & search keyword for instant UI responsiveness
  void _applyLocalFilter() {
    final query = _searchController.text.trim().toLowerCase();
    final districtLower = _selectedDistrict.toLowerCase();

    List<Map<String, dynamic>> result = List.from(_pharmacies);

    if (_selectedDistrict.isNotEmpty) {
      result = result.where((p) {
        final d = (p['district'] ?? '').toString().toLowerCase();
        final addr = (p['address'] ?? '').toString().toLowerCase();
        return d == districtLower || addr.contains(districtLower);
      }).toList();
    }

    if (query.isNotEmpty) {
      result = result.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final addr = (p['address'] ?? '').toString().toLowerCase();
        final dist = (p['district'] ?? '').toString().toLowerCase();
        return name.contains(query) || addr.contains(query) || dist.contains(query);
      }).toList();
    }

    // Preserve distance sorting if active
    if (_isSortingByDistance && _userPosition != null) {
      result.sort((a, b) {
        final double distA = a['distanceMeters'] ?? 999999999.0;
        final double distB = b['distanceMeters'] ?? 999999999.0;
        return distA.compareTo(distB);
      });
    }

    setState(() {
      _filteredPharmacies = result;
    });
  }

  /// Detect user location via GPS and sort by closest
  Future<void> _detectLocationAndFindNearest() async {
    final isAr = Get.locale?.languageCode == 'ar';

    setState(() => _isLocating = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          isAr ? 'خدمة الموقع غير مفعلة' : 'Location Service Disabled',
          isAr ? 'يرجى تفعيل الـ GPS في هاتفك لتحديد موقعك' : 'Please enable GPS on your phone',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E293B),
          colorText: Colors.white,
          margin: EdgeInsets.all(12.w),
        );
        setState(() => _isLocating = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            isAr ? 'إذن الموقع مطلوب' : 'Permission Required',
            isAr ? 'يرجى منح إذن الموقع لتحديد أقرب صيدلية' : 'Please grant location permission',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1E293B),
            colorText: Colors.white,
            margin: EdgeInsets.all(12.w),
          );
          setState(() => _isLocating = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          isAr ? 'إذن الموقع مرفوض دائماً' : 'Permission Denied Forever',
          isAr ? 'يرجى تفعيل إذن الموقع من إعدادات الهاتف' : 'Please enable location from device settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E293B),
          colorText: Colors.white,
          margin: EdgeInsets.all(12.w),
        );
        setState(() => _isLocating = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _userPosition = position;

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final adminArea = (place.administrativeArea ?? '').toLowerCase();
        final subAdmin = (place.subAdministrativeArea ?? '').toLowerCase();
        final locality = (place.locality ?? '').toLowerCase();

        // Match Turkish city
        Map<String, dynamic>? matchedCity;
        for (var c in _cities) {
          final id = c['id'].toString().toLowerCase();
          final tr = c['name_tr'].toString().toLowerCase();
          if (adminArea.contains(id) || adminArea.contains(tr) ||
              subAdmin.contains(id) || subAdmin.contains(tr) ||
              locality.contains(id) || locality.contains(tr)) {
            matchedCity = c;
            break;
          }
        }

        if (matchedCity != null) {
          final isSameCity = matchedCity['id'] == _selectedCityId;
          if (!isSameCity) {
            _onCitySelected(matchedCity);
          }

          // Try matching district
          Future.delayed(Duration(milliseconds: isSameCity ? 100 : 700), () {
            if (_districts.isNotEmpty) {
              for (var d in _districts) {
                final dLower = d.toLowerCase();
                if (subAdmin.contains(dLower) || locality.contains(dLower) || adminArea.contains(dLower)) {
                  setState(() {
                    _selectedDistrict = d;
                    _applyLocalFilter();
                  });
                  break;
                }
              }
            }

            // Calculate distance & sort by nearest
            _calculateDistancesAndSort();
          });

          Get.snackbar(
            isAr ? 'تم تحديد موقعك بدقة 📍' : 'Location Detected 📍',
            isAr
                ? 'تم فرز الصيدليات تلقائياً من الأقرب إليك لموقعك الحالي'
                : 'Pharmacies sorted by closest distance to you',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: EdgeInsets.all(12.w),
          );
        } else {
          // If outside Turkey, still calculate distance based on current view
          _calculateDistancesAndSort();
          Get.snackbar(
            isAr ? 'تم تحديد إحداثياتك' : 'Coordinates Located',
            isAr ? 'تم فرز الصيدليات المتاحة حسب المسافة' : 'Pharmacies sorted by distance',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1E293B),
            colorText: Colors.white,
            margin: EdgeInsets.all(12.w),
          );
        }
      }
    } catch (_) {
      Get.snackbar(
        isAr ? 'تعذر جلب الموقع' : 'Could Not Get Location',
        isAr ? 'يرجى اختيار المدينة يدوياً' : 'Please select city manually',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
        margin: EdgeInsets.all(12.w),
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  /// Asynchronously calculate distance for displayed pharmacies and sort by nearest
  Future<void> _calculateDistancesAndSort() async {
    if (_userPosition == null) return;
    setState(() => _isSortingByDistance = true);

    final userLat = _userPosition!.latitude;
    final userLng = _userPosition!.longitude;

    // Process displayed pharmacies (limit geocoding batch to top 25 for fast response)
    final itemsToProcess = _filteredPharmacies.take(25).toList();

    for (var p in itemsToProcess) {
      final addr = (p['address'] ?? '').toString();
      if (addr.isEmpty) continue;

      try {
        Location? loc = _geocodeCache[addr];
        if (loc == null) {
          final results = await Geocoding().locationFromAddress(addr);
          if (results.isNotEmpty) {
            loc = results.first;
            _geocodeCache[addr] = loc;
          }
        }

        if (loc != null) {
          final double distanceMeters = Geolocator.distanceBetween(
            userLat,
            userLng,
            loc.latitude,
            loc.longitude,
          );

          p['distanceMeters'] = distanceMeters;
          if (distanceMeters < 1000) {
            p['distanceText'] = '${distanceMeters.round()} م';
          } else {
            p['distanceText'] = '${(distanceMeters / 1000).toStringAsFixed(1)} كم';
          }
        }
      } catch (_) {
        // Continue silently if an address cannot be geocoded
      }
    }

    if (mounted) {
      setState(() {
        _filteredPharmacies.sort((a, b) {
          final double distA = a['distanceMeters'] ?? 999999999.0;
          final double distB = b['distanceMeters'] ?? 999999999.0;
          return distA.compareTo(distB);
        });
      });
    }
  }

  void _onCitySelected(Map<String, dynamic> city) {
    setState(() {
      _selectedCityId = city['id'] ?? 'istanbul';
      _selectedCityNameTr = city['name_tr'] ?? 'İstanbul';
      _selectedCityNameAr = city['name_ar'] ?? 'إسطنبول';
      _selectedCityNameEn = city['name_en'] ?? 'Istanbul';
      _selectedDistrict = '';
      _isSortingByDistance = false;
      _searchController.clear();
    });
    _fetchDutyPharmacies();
  }

  /// Launch phone call
  Future<void> _makePhoneCall(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (clean.isEmpty) return;

    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final isAr = Get.locale?.languageCode == 'ar';
      Get.snackbar(
        isAr ? 'تنبيه' : 'Notice',
        isAr ? 'تعذر فتح تطبيق الاتصال' : 'Could not launch dialer',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Launch Map Directions
  Future<void> _openMap(String mapUrl, String address) async {
    Uri? uri;
    if (mapUrl.isNotEmpty && mapUrl.startsWith('http')) {
      uri = Uri.parse(mapUrl);
    } else if (address.isNotEmpty) {
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    }

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final isAr = Get.locale?.languageCode == 'ar';
      Get.snackbar(
        isAr ? 'تنبيه' : 'Notice',
        isAr ? 'تعذر فتح تطبيق الخرائط' : 'Could not launch maps',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Copy text to clipboard
  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    final isAr = Get.locale?.languageCode == 'ar';
    Get.snackbar(
      isAr ? 'تم النسخ' : 'Copied',
      isAr ? 'تم نسخ $label إلى الحافظة' : '$label copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(12.w),
    );
  }

  /// Show Comprehensive City Picker Bottom Sheet with Search and Popular sections
  void _showCityPicker() {
    final isAr = Get.locale?.languageCode == 'ar';
    final citySearchController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          final query = citySearchController.text.trim().toLowerCase();

          final filteredCities = query.isEmpty
              ? _cities
              : _cities.where((c) {
                  final ar = (c['name_ar'] ?? '').toString().toLowerCase();
                  final tr = (c['name_tr'] ?? '').toString().toLowerCase();
                  final en = (c['name_en'] ?? '').toString().toLowerCase();
                  return ar.contains(query) || tr.contains(query) || en.contains(query);
                }).toList();

          final popularCities = filteredCities.where((c) => c['popular'] == true).toList();
          final allOtherCities = filteredCities.where((c) => c['popular'] != true).toList();

          return Container(
            height: 600.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 14.h),

                // Title Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.location_city_rounded, color: const Color(0xFF10B981), size: 22.sp),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        isAr ? 'اختر الولاية (81 ولاية تركية)' : 'Select Province (81 Provinces)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F2B48),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.grey),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                // City Search Box
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextField(
                      controller: citySearchController,
                      onChanged: (_) => setModalState(() {}),
                      style: TextStyle(fontSize: 13.sp),
                      decoration: InputDecoration(
                        hintText: isAr ? 'ابحث عن اسم الولاية...' : 'Search province name...',
                        hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                        prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF64748B), size: 18.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1.h, color: Colors.grey.shade200),

                // List of Cities (Categorized into Popular + All)
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    children: [
                      if (popularCities.isNotEmpty && query.isEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded, color: const Color(0xFFF59E0B), size: 16.sp),
                              SizedBox(width: 6.w),
                              Text(
                                isAr ? 'الولايات السياحية الأكثر زيارة' : 'Popular Tourist Destinations',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F2B48),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...popularCities.map((c) => _buildCityListTile(c, isAr)),
                        Divider(height: 20.h, color: Colors.grey.shade200),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                          child: Row(
                            children: [
                              Icon(Icons.map_rounded, color: const Color(0xFF64748B), size: 16.sp),
                              SizedBox(width: 6.w),
                              Text(
                                isAr ? 'كافة الولايات التركية (أبجدياً)' : 'All Turkish Provinces',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      ...allOtherCities.map((c) => _buildCityListTile(c, isAr)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCityListTile(Map<String, dynamic> city, bool isAr) {
    final isSelected = city['id'] == _selectedCityId;
    final cityName = isAr
        ? '${city['name_ar']} (${city['name_tr']})'
        : '${city['name_en']} (${city['name_tr']})';

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
      leading: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981).withOpacity(0.15)
              : const Color(0xFFF1F5F9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.pin_drop_rounded,
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF64748B),
          size: 16.sp,
        ),
      ),
      title: Text(
        cityName,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF1E293B),
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: const Color(0xFF10B981), size: 18.sp)
          : null,
      onTap: () {
        Get.back();
        _onCitySelected(city);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final currentCityDisplay = isAr
        ? '$_selectedCityNameAr ($_selectedCityNameTr)'
        : '$_selectedCityNameEn ($_selectedCityNameTr)';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2B48),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.local_pharmacy_rounded, color: Colors.white, size: 16.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              isAr ? 'الصيدليات المناوبة' : 'Duty Pharmacies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.white, size: 22.sp),
            tooltip: isAr ? 'تحديث' : 'Refresh',
            onPressed: _fetchDutyPharmacies,
          ),
        ],
      ),
      bottomNavigationBar: const AdmobBannerUi(),
      body: Column(
        children: [
          // Top Header Banner with City Selector & Search & GPS Quick Actions
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F2B48), Color(0xFF1B4D73)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
            child: Column(
              children: [
                // Live Status Pill & Subtitle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            isAr ? 'مناوبة 24 ساعة' : '24H On Duty',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isAr ? 'محدث يومياً لكافة الـ 81 ولاية' : 'Live Daily for all 81 Provinces',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // City Selector Button & GPS Nearest Pharmacy Button
                Row(
                  children: [
                    // City Dropdown Button
                    Expanded(
                      child: InkWell(
                        onTap: _showCityPicker,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.white.withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: const Color(0xFF10B981), size: 18.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  currentCityDisplay,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 20.sp),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // GPS Nearest Pharmacy Button (الأقرب لموقعي)
                    InkWell(
                      onTap: _isLocating ? null : _detectLocationAndFindNearest,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _isLocating
                            ? SizedBox(
                                width: 18.sp,
                                height: 18.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.my_location_rounded, color: Colors.white, size: 18.sp),
                                  SizedBox(width: 6.w),
                                  Text(
                                    isAr ? 'الأقرب لي' : 'Near Me',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Search Box
                Container(
                  height: 42.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _applyLocalFilter(),
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF0F172A)),
                    decoration: InputDecoration(
                      hintText: isAr ? 'ابحث باسم الصيدلية أو الشارع أو الحي...' : 'Search pharmacy name, street, district...',
                      hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                      prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF64748B), size: 20.sp),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded, color: const Color(0xFF64748B), size: 18.sp),
                              onPressed: () {
                                _searchController.clear();
                                _applyLocalFilter();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // District Filter Chips (Horizontal Scroll)
          if (_districts.isNotEmpty && !_isLoading)
            Container(
              height: 44.h,
              margin: EdgeInsets.only(top: 8.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                itemCount: _districts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isAllSelected = _selectedDistrict.isEmpty;
                    return Padding(
                      padding: EdgeInsets.only(right: isAr ? 0 : 8.w, left: isAr ? 8.w : 0),
                      child: ChoiceChip(
                        label: Text(
                          isAr ? 'الكل (${_pharmacies.length})' : 'All (${_pharmacies.length})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: isAllSelected ? FontWeight.bold : FontWeight.w500,
                            color: isAllSelected ? Colors.white : const Color(0xFF475569),
                          ),
                        ),
                        selected: isAllSelected,
                        selectedColor: const Color(0xFF10B981),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isAllSelected ? const Color(0xFF10B981) : Colors.grey.shade300,
                        ),
                        onSelected: (val) {
                          setState(() {
                            _selectedDistrict = '';
                            _applyLocalFilter();
                          });
                        },
                      ),
                    );
                  }

                  final district = _districts[index - 1];
                  final isSelected = _selectedDistrict == district;

                  return Padding(
                    padding: EdgeInsets.only(right: isAr ? 0 : 8.w, left: isAr ? 8.w : 0),
                    child: ChoiceChip(
                      label: Text(
                        district,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF10B981),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF10B981) : Colors.grey.shade300,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedDistrict = isSelected ? '' : district;
                          _applyLocalFilter();
                        });
                      },
                    ),
                  );
                },
              ),
            ),

          // Count & Distance Sorting Status Bar
          if (!_isLoading && _errorMessage.isEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
              child: Row(
                children: [
                  Icon(
                    _isSortingByDistance ? Icons.sort_by_alpha_rounded : Icons.check_circle_outline_rounded,
                    color: const Color(0xFF10B981),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      _isSortingByDistance
                          ? (isAr ? 'مرتبة حسب الأقرب لموقعك أولاً 📍' : 'Sorted by closest to you 📍')
                          : (isAr
                              ? 'تم العثور على ${_filteredPharmacies.length} صيدلية مناوبة'
                              : '${_filteredPharmacies.length} duty pharmacies found'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: _isSortingByDistance ? FontWeight.bold : FontWeight.w600,
                        color: _isSortingByDistance ? const Color(0xFF0F2B48) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  if (_userPosition != null && !_isSortingByDistance)
                    InkWell(
                      onTap: _calculateDistancesAndSort,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          isAr ? 'ترتيب حسب الأقرب' : 'Sort by Distance',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Main Content: List or Loading or Error
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Color(0xFF10B981)),
                        SizedBox(height: 16.h),
                        Text(
                          isAr ? 'جاري جلب الصيدليات المناوبة...' : 'Loading duty pharmacies...',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off_rounded, size: 54.sp, color: Colors.grey.shade400),
                              SizedBox(height: 14.h),
                              Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton.icon(
                                onPressed: _fetchDutyPharmacies,
                                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                                label: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filteredPharmacies.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded, size: 52.sp, color: Colors.grey.shade400),
                                SizedBox(height: 12.h),
                                Text(
                                  isAr
                                      ? 'لا توجد صيدليات مطابقة لبحثك'
                                      : 'No pharmacies match your search',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  isAr
                                      ? 'جرب البحث بكلمات أخرى أو اختر حياً مختلفاً'
                                      : 'Try searching other terms or change district',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            color: const Color(0xFF10B981),
                            onRefresh: _fetchDutyPharmacies,
                            child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 16.h),
                              itemCount: _filteredPharmacies.length,
                              itemBuilder: (context, index) {
                                final pharmacy = _filteredPharmacies[index];
                                final isNearest = _isSortingByDistance && index == 0 && (pharmacy['distanceText'] != null);
                                return _buildPharmacyCard(context, pharmacy, isAr, isNearest: isNearest);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  /// Modern Native Pharmacy Card with Nearest highlight & Distance Badge
  Widget _buildPharmacyCard(BuildContext context, Map<String, dynamic> p, bool isAr, {bool isNearest = false}) {
    final name = (p['name'] ?? '').toString();
    final district = (p['district'] ?? '').toString();
    final address = (p['address'] ?? '').toString();
    final phone = (p['phone'] ?? '').toString();
    final phoneDisplay = (p['phone_display'] ?? phone).toString();
    final mapUrl = (p['map_url'] ?? '').toString();
    final distanceText = p['distanceText'] as String?;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isNearest ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: isNearest ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isNearest
                ? const Color(0xFF10B981).withOpacity(0.12)
                : Colors.black.withOpacity(0.04),
            blurRadius: isNearest ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nearest Top Banner (if this is card #1 closest to user)
          if (isNearest)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    isAr ? 'الأقرب لموقعك الحالي الآن' : 'Closest to your current location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (distanceText != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        distanceText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Header: Name + Open Badge + Distance
          Container(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
            decoration: BoxDecoration(
              color: isNearest ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
              borderRadius: isNearest ? null : BorderRadius.vertical(top: Radius.circular(16.r)),
              border: Border(bottom: BorderSide(color: const Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                // Pharmacy Green Badge Icon
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: const Color(0xFF10B981),
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),

                // Name & District
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F2B48),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (district.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 12.sp, color: const Color(0xFF64748B)),
                              SizedBox(width: 2.w),
                              Text(
                                district,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Duty Badge or Distance Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.alarm_on_rounded, size: 12.sp, color: const Color(0xFF10B981)),
                          SizedBox(width: 4.w),
                          Text(
                            isAr ? 'مناوبة الآن' : 'On Duty',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (distanceText != null && !isNearest) ...[
                      SizedBox(height: 3.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          isAr ? 'يبعد $distanceText' : distanceText,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Body: Address & Phone & Actions
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Row with Copy
                InkWell(
                  onTap: () => _copyToClipboard(address, isAr ? 'العنوان' : 'Address'),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place_outlined, color: const Color(0xFF94A3B8), size: 16.sp),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF334155),
                              height: 1.35,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.copy_rounded, color: Colors.grey.shade400, size: 14.sp),
                      ],
                    ),
                  ),
                ),

                // Phone Row if available
                if (phone.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () => _copyToClipboard(phone, isAr ? 'رقم الهاتف' : 'Phone Number'),
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        children: [
                          Icon(Icons.phone_outlined, color: const Color(0xFF94A3B8), size: 15.sp),
                          SizedBox(width: 6.w),
                          Text(
                            phoneDisplay,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F2B48),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(Icons.copy_rounded, color: Colors.grey.shade400, size: 13.sp),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 12.h),

                // Action Buttons Row (Call + Directions)
                Row(
                  children: [
                    // Call Button
                    if (phone.isNotEmpty)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makePhoneCall(phone),
                          icon: Icon(Icons.phone_in_talk_rounded, size: 16.sp, color: Colors.white),
                          label: Text(
                            isAr ? 'اتصال فوري' : 'Call',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),

                    if (phone.isNotEmpty) SizedBox(width: 10.w),

                    // Directions / Map Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openMap(mapUrl, address),
                        icon: Icon(Icons.directions_rounded, size: 16.sp, color: Colors.white),
                        label: Text(
                          isAr ? 'الخريطة والاتجاهات' : 'Directions',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F2B48),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
