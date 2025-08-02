import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/app-preferences-model/appPreferences-model.dart';

class AppPreferencesService {
  static const String _boxName = 'appPreferences';
  static const String _preferencesKey = 'currentPreferences';
  
  // Currency mappings
  static final Map<String, Map<String, String>> _localeCurrencyMap = {
    // Americas
    'en_US': {'code': 'USD', 'symbol': '\$'},
    'en_CA': {'code': 'CAD', 'symbol': '\$'},
    'es_MX': {'code': 'MXN', 'symbol': '\$'},
    'pt_BR': {'code': 'BRL', 'symbol': 'R\$'},
    
    // Europe
    'de_DE': {'code': 'EUR', 'symbol': '€'},
    'fr_FR': {'code': 'EUR', 'symbol': '€'},
    'it_IT': {'code': 'EUR', 'symbol': '€'},
    'es_ES': {'code': 'EUR', 'symbol': '€'},
    'nl_NL': {'code': 'EUR', 'symbol': '€'},
    'en_GB': {'code': 'GBP', 'symbol': '£'},
    'en_IE': {'code': 'EUR', 'symbol': '€'},
    
    // Asia
    'zh_CN': {'code': 'CNY', 'symbol': '¥'},
    'ja_JP': {'code': 'JPY', 'symbol': '¥'},
    'ko_KR': {'code': 'KRW', 'symbol': '₩'},
    'hi_IN': {'code': 'INR', 'symbol': '₹'},
    'en_IN': {'code': 'INR', 'symbol': '₹'},
    
    // Oceania
    'en_AU': {'code': 'AUD', 'symbol': '\$'},
    'en_NZ': {'code': 'NZD', 'symbol': '\$'},
    
    // Middle East & Africa
    'ar_SA': {'code': 'SAR', 'symbol': 'ر.س'},
    'en_ZA': {'code': 'ZAR', 'symbol': 'R'},
    'ar_AE': {'code': 'AED', 'symbol': 'د.إ'},
  };
  
  static final Map<String, Map<String, String>> _countryCurrencyMap = {
    'US': {'code': 'USD', 'symbol': '\$'},
    'CA': {'code': 'CAD', 'symbol': '\$'},
    'GB': {'code': 'GBP', 'symbol': '£'},
    'EU': {'code': 'EUR', 'symbol': '€'},
    'JP': {'code': 'JPY', 'symbol': '¥'},
    'CN': {'code': 'CNY', 'symbol': '¥'},
    'IN': {'code': 'INR', 'symbol': '₹'},
    'AU': {'code': 'AUD', 'symbol': '\$'},
    'NZ': {'code': 'NZD', 'symbol': '\$'},
    'BR': {'code': 'BRL', 'symbol': 'R\$'},
    'MX': {'code': 'MXN', 'symbol': '\$'},
    'KR': {'code': 'KRW', 'symbol': '₩'},
    'ZA': {'code': 'ZAR', 'symbol': 'R'},
    'SA': {'code': 'SAR', 'symbol': 'ر.س'},
    'AE': {'code': 'AED', 'symbol': 'د.إ'},
  };
  
  static final Map<String, String> _languageNames = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'hi': 'Hindi',
    'ar': 'Arabic',
    'nl': 'Dutch',
  };
  
  // Initialize and detect preferences
  static Future<AppPreferencesModel> initializePreferences() async {
    final box = await Hive.openBox<AppPreferencesModel>(_boxName);
    
    // Check if preferences already exist
    final existingPreferences = box.get(_preferencesKey);
    if (existingPreferences != null) {
      return existingPreferences;
    }
    
    // Detect and set new preferences
    final detectedPreferences = await _detectPreferences();
    await box.put(_preferencesKey, detectedPreferences);
    return detectedPreferences;
  }
  
  // Get current preferences
  static Future<AppPreferencesModel> getPreferences() async {
    final box = await Hive.openBox<AppPreferencesModel>(_boxName);
    return box.get(_preferencesKey) ?? await initializePreferences();
  }
  
  // Update preferences
  static Future<void> updatePreferences(AppPreferencesModel preferences) async {
    final box = await Hive.openBox<AppPreferencesModel>(_boxName);
    final updatedPreferences = preferences.copyWith(
      lastUpdated: DateTime.now(),
    );
    await box.put(_preferencesKey, updatedPreferences);
  }
  
  // Update only currency
  static Future<void> updateCurrency(String currencyCode, String currencySymbol) async {
    final currentPreferences = await getPreferences();
    final updatedPreferences = currentPreferences.copyWith(
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      lastUpdated: DateTime.now(),
    );
    await updatePreferences(updatedPreferences);
  }
  
  // Detect preferences based on locale and IP
  static Future<AppPreferencesModel> _detectPreferences() async {
    // Force English as default locale instead of using device locale
    final locale = 'en_US'; // Always default to English
    final languageCode = 'en';
    final languageName = 'English';
    
    // Check if we have exact locale match
    if (_localeCurrencyMap.containsKey(locale)) {
      final currencyInfo = _localeCurrencyMap[locale]!;
      return AppPreferencesModel(
        currencyCode: currencyInfo['code']!,
        currencySymbol: currencyInfo['symbol']!,
        locale: locale,
        languageName: languageName,
        lastUpdated: DateTime.now(),
      );
    }
    
    // Check for language-only match (e.g., 'en' without country)
    final localePrefix = locale.substring(0, 2);
    final partialMatch = _localeCurrencyMap.keys
        .where((key) => key.startsWith(localePrefix))
        .firstOrNull;
    
    if (partialMatch != null) {
      final currencyInfo = _localeCurrencyMap[partialMatch]!;
      return AppPreferencesModel(
        currencyCode: currencyInfo['code']!,
        currencySymbol: currencyInfo['symbol']!,
        locale: locale,
        languageName: languageName,
        lastUpdated: DateTime.now(),
      );
    }
    
    // Fallback to IP-based detection
    try {
      final countryCode = await _getCountryFromIP();
      if (countryCode != null && _countryCurrencyMap.containsKey(countryCode)) {
        final currencyInfo = _countryCurrencyMap[countryCode]!;
        return AppPreferencesModel(
          currencyCode: currencyInfo['code']!,
          currencySymbol: currencyInfo['symbol']!,
          locale: locale,
          languageName: languageName,
          lastUpdated: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error detecting country from IP: $e');
    }
    
    // Default to USD
    return AppPreferencesModel(
      currencyCode: 'USD',
      currencySymbol: '\$',
      locale: locale,
      languageName: languageName,
      lastUpdated: DateTime.now(),
    );
  }
  
  // Get country from IP using free API
  static Future<String?> _getCountryFromIP() async {
    try {
      final response = await http.get(
        Uri.parse('http://ip-api.com/json/?fields=countryCode'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['countryCode'] as String?;
      }
    } catch (e) {
      print('Failed to get country from IP: $e');
    }
    return null;
  }
  
  // Get formatted price with currency
  static String formatPrice(double amount, {AppPreferencesModel? preferences}) {
    final prefs = preferences ?? AppPreferencesModel();
    return '${prefs.currencySymbol}${amount.toStringAsFixed(2)}';
  }
}