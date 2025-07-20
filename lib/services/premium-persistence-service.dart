import 'package:hive/hive.dart';
import 'package:get/get.dart';
import '../getx-controllers/premium-controller.dart';

class PremiumPersistenceService {
  static const String _boxName = 'premiumData';
  static const String _isPremiumKey = 'isPremium';
  static const String _purchaseIdKey = 'purchaseId';
  static const String _purchaseDateKey = 'purchaseDate';
  static const String _productIdKey = 'productId';
  
  static Box? _box;
  
  // Initialize the service
  static Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
    await loadPremiumStatus();
  }
  
  // Save premium status
  static Future<void> savePremiumStatus({
    required bool isPremium,
    String? purchaseId,
    String? productId,
    DateTime? purchaseDate,
  }) async {
    if (_box == null) return;
    
    await _box!.put(_isPremiumKey, isPremium);
    
    if (purchaseId != null) {
      await _box!.put(_purchaseIdKey, purchaseId);
    }
    
    if (productId != null) {
      await _box!.put(_productIdKey, productId);
    }
    
    if (purchaseDate != null) {
      await _box!.put(_purchaseDateKey, purchaseDate.toIso8601String());
    }
    
    // Update controller
    final controller = Get.find<PremiumController>();
    controller.isPremium.value = isPremium;
  }
  
  // Load premium status
  static Future<void> loadPremiumStatus() async {
    if (_box == null) return;
    
    bool isPremium = _box!.get(_isPremiumKey, defaultValue: false);
    
    // Update controller
    final controller = Get.find<PremiumController>();
    controller.isPremium.value = isPremium;
  }
  
  // Get premium info
  static Map<String, dynamic> getPremiumInfo() {
    if (_box == null) return {};
    
    return {
      'isPremium': _box!.get(_isPremiumKey, defaultValue: false),
      'purchaseId': _box!.get(_purchaseIdKey),
      'productId': _box!.get(_productIdKey),
      'purchaseDate': _box!.get(_purchaseDateKey),
    };
  }
  
  // Clear premium status (for testing or when user requests refund)
  static Future<void> clearPremiumStatus() async {
    if (_box == null) return;
    
    await _box!.clear();
    
    // Update controller
    final controller = Get.find<PremiumController>();
    controller.isPremium.value = false;
  }
  
  // Check if premium status needs verification (e.g., for subscriptions)
  static bool needsVerification() {
    if (_box == null) return false;
    
    String? productId = _box!.get(_productIdKey);
    if (productId == null) return false;
    
    // If it's a subscription (not lifetime), check if we should verify
    if (productId.contains('monthly') || productId.contains('annual')) {
      String? purchaseDateStr = _box!.get(_purchaseDateKey);
      if (purchaseDateStr == null) return true;
      
      DateTime purchaseDate = DateTime.parse(purchaseDateStr);
      DateTime now = DateTime.now();
      
      // Verify if more than 24 hours have passed since last check
      return now.difference(purchaseDate).inHours > 24;
    }
    
    return false;
  }
}