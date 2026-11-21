import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travelwin/utils/theme.dart';
import '../../../helpers/adv/admob_banner.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'TRY';
  bool _isLive = false;
  bool _isFetching = false;

  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.91,
    'TRY': 50.5,
    'SAR': 3.75,
    'AED': 3.67,
    'KWD': 0.31,
    'QAR': 3.64,
    'EGP': 53.8,
    'GBP': 0.76,
    'JOD': 0.71,
  };

  final Map<String, String> _currencyNamesAr = {
    'USD': 'دولار أمريكي (\$)',
    'EUR': 'يورو (€)',
    'TRY': 'ليرة تركية (₺)',
    'SAR': 'ريال سعودي (ر.س)',
    'AED': 'درهم إماراتي (د.إ)',
    'KWD': 'دينار كويتي (د.ك)',
    'QAR': 'ريال قطري (ر.ق)',
    'EGP': 'جنيه مصري (ج.م)',
    'GBP': 'جنيه إسترليني (£)',
    'JOD': 'دينار أردني (د.أ)',
  };

  final Map<String, String> _currencyNamesEn = {
    'USD': 'US Dollar (\$)',
    'EUR': 'Euro (€)',
    'TRY': 'Turkish Lira (₺)',
    'SAR': 'Saudi Riyal (SAR)',
    'AED': 'UAE Dirham (AED)',
    'KWD': 'Kuwaiti Dinar (KWD)',
    'QAR': 'Qatari Riyal (QAR)',
    'EGP': 'Egyptian Pound (EGP)',
    'GBP': 'British Pound (£)',
    'JOD': 'Jordanian Dinar (JOD)',
  };

  double _convertedValue = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateConversion();
    _fetchLiveRates();
  }

  Future<void> _fetchLiveRates() async {
    try {
      setState(() => _isFetching = true);
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ));
      final response = await dio.get('https://open.er-api.com/v6/latest/USD');
      if (response.statusCode == 200 && response.data != null) {
        final ratesData = response.data['rates'] as Map<String, dynamic>?;
        if (ratesData != null) {
          ratesData.forEach((key, val) {
            if (_rates.containsKey(key) && val is num) {
              _rates[key] = val.toDouble();
            }
          });
          _isLive = true;
          _calculateConversion();
        }
      }
    } catch (e) {
      debugPrint('Live rates fetch error: $e');
    } finally {
      if (mounted) {
        setState(() => _isFetching = false);
      }
    }
  }

  void _calculateConversion() {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _convertedValue = 0.0;
      });
      return;
    }

    final double fromRate = _rates[_fromCurrency] ?? 1.0;
    final double toRate = _rates[_toCurrency] ?? 1.0;
    final double inUsd = amount / fromRate;
    final double result = inUsd * toRate;

    setState(() {
      _convertedValue = result;
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _calculateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    final bool isAr = Get.locale?.languageCode == 'ar';
    final currencyNames = isAr ? _currencyNamesAr : _currencyNamesEn;

    return Scaffold(
      bottomNavigationBar: const AdmobBannerUi(),
      appBar: AppBar(
        title: Text(
          isAr ? 'محول العملات ومصاريف السفر' : 'Travel Currency Converter',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Feature Hero Banner
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [mainColor, Color(0xFF1B3B5A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: mainColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TravelWin Plus Tools',
                        style: TextStyle(
                          color: goldAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          letterSpacing: 1.2,
                        ),
                      ),
                      InkWell(
                        onTap: _fetchLiveRates,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: _isLive ? Colors.green.withOpacity(0.25) : goldAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: _isLive ? Colors.greenAccent : goldAccent, width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isFetching ? Icons.sync : Icons.wifi_tethering,
                                size: 12.sp,
                                color: _isLive ? Colors.greenAccent : goldAccent,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                isAr
                                    ? (_isFetching ? 'جاري التحديث...' : (_isLive ? 'أسعار حية مباشرة 🟢' : 'تحديث الأسعار 🔄'))
                                    : (_isFetching ? 'Updating...' : (_isLive ? 'Live Rates 🟢' : 'Refresh Rates 🔄')),
                                style: TextStyle(
                                  color: _isLive ? Colors.greenAccent : goldAccent,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    '${_amountController.text.isEmpty ? "0" : _amountController.text} $_fromCurrency',
                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '≈ ${_convertedValue.toStringAsFixed(2)} $_toCurrency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Amount Input Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'المبلغ المراد تحويله' : 'Amount to Convert',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calculate_outlined, color: mainColor),
                      hintText: isAr ? 'أدخل المبلغ...' : 'Enter amount...',
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => _calculateConversion(),
                  ),
                  SizedBox(height: 12.h),

                  // Quick amount chips
                  Wrap(
                    spacing: 8.w,
                    children: [50, 100, 250, 500, 1000].map((amt) {
                      return ActionChip(
                        label: Text('+$amt'),
                        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: mainColor),
                        onPressed: () {
                          _amountController.text = amt.toString();
                          _calculateConversion();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Currency Selectors & Swap
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  // From Currency
                  _buildDropdownRow(
                    label: isAr ? 'من العملة' : 'From Currency',
                    value: _fromCurrency,
                    currencyNames: currencyNames,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _fromCurrency = val;
                          _calculateConversion();
                        });
                      }
                    },
                  ),

                  // Swap Button
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Center(
                      child: InkWell(
                        onTap: _swapCurrencies,
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: goldAccent.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: goldAccent, width: 1.2),
                          ),
                          child: const Icon(Icons.swap_vert_rounded, color: mainColor, size: 24),
                        ),
                      ),
                    ),
                  ),

                  // To Currency
                  _buildDropdownRow(
                    label: isAr ? 'إلى العملة' : 'To Currency',
                    value: _toCurrency,
                    currencyNames: currencyNames,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _toCurrency = val;
                          _calculateConversion();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Travel Tip Box
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFFD97706)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      isAr
                          ? 'نصيحة للمسافرين: احتفظ دائماً بمبالغ نقدية بالعملة المحلية للمواصلات والتسوق السريع أثناء رحلتك.'
                          : 'Traveler Tip: Keep some local cash handy for taxis, public transit, and local markets during your journey.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF92400E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required String value,
    required Map<String, String> currencyNames,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600], fontWeight: FontWeight.w600)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.withOpacity(0.25)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: _rates.keys.map((curr) {
                return DropdownMenuItem<String>(
                  value: curr,
                  child: Row(
                    children: [
                      Text(curr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8.w),
                      Text(
                        '(${currencyNames[curr] ?? ""})',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
