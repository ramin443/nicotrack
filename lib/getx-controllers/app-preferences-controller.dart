import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/app-preferences-model/appPreferences-model.dart';
import '../services/app-preferences-service.dart';

class AppPreferencesController extends GetxController {
  AppPreferencesModel _preferences = AppPreferencesModel();
  bool _isInitialized = false;

  // Getters
  AppPreferencesModel get preferences => _preferences;
  String get currencySymbol => _preferences.currencySymbol;
  String get currencyCode => _preferences.currencyCode;
  String get locale => _preferences.locale;
  String get languageName => _preferences.languageName;
  bool get isInitialized => _isInitialized;

  @override
  void onInit() {
    super.onInit();
    // Initialize preferences after a delay to ensure Hive is ready
    Future.delayed(Duration.zero, () {
      initializePreferences();
    });
  }

  // Initialize preferences
  Future<void> initializePreferences() async {
    try {
      _preferences = await AppPreferencesService.initializePreferences();
      _isInitialized = true;
      update();
    } catch (e) {
      print('Error initializing app preferences: $e');
      // Use default values if initialization fails
      _preferences = AppPreferencesModel();
      _isInitialized = true;
      update();
    }
  }

  // Update currency
  Future<void> updateCurrency(String currencyCode, String currencySymbol) async {
    try {
      await AppPreferencesService.updateCurrency(currencyCode, currencySymbol);
      _preferences = _preferences.copyWith(
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
      );
      update();
    } catch (e) {
      print('Error updating currency: $e');
    }
  }

  // Update language
  Future<void> updateLanguage(String locale, String languageName) async {
    try {
      _preferences = _preferences.copyWith(
        locale: locale,
        languageName: languageName,
      );
      await AppPreferencesService.updatePreferences(_preferences);
      update();
      
      // Force rebuild of the entire app to apply new locale
      Get.forceAppUpdate();
    } catch (e) {
      print('Error updating language: $e');
    }
  }

  // Format price with current currency
  String formatPrice(double amount) {
    return AppPreferencesService.formatPrice(amount, preferences: _preferences);
  }

  // Get currency list for settings
  List<Map<String, String>> getCurrencyList() {
    return [
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'AUD', 'symbol': '\$', 'name': 'Australian Dollar'},
      {'code': 'CAD', 'symbol': '\$', 'name': 'Canadian Dollar'},
      {'code': 'BRL', 'symbol': 'R\$', 'name': 'Brazilian Real'},
      {'code': 'MXN', 'symbol': '\$', 'name': 'Mexican Peso'},
      {'code': 'KRW', 'symbol': '₩', 'name': 'South Korean Won'},
      {'code': 'ZAR', 'symbol': 'R', 'name': 'South African Rand'},
      {'code': 'SAR', 'symbol': 'ر.س', 'name': 'Saudi Riyal'},
      {'code': 'AED', 'symbol': 'د.إ', 'name': 'UAE Dirham'},
      {'code': 'NZD', 'symbol': '\$', 'name': 'New Zealand Dollar'},
    ];
  }

  // Register Hive adapter if not already registered
  static void registerHiveAdapters() {
    if (!Hive.isAdapterRegistered(100)) { // Using a unique type ID
      Hive.registerAdapter(AppPreferencesModelAdapter());
    }
  }
}