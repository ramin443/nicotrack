import 'package:hive/hive.dart';
import 'package:get/get.dart';
import '../getx-controllers/premium-controller.dart';

class PremiumPersistenceService {
  static const String _boxName = 'premiumData';
  static const String _isPremiumKey = 'isPremium';
  static const String _purchaseIdKey = 'purchaseId';
  static const String _purchaseDateKey = 'purchaseDate';
  static const String _productIdKey = 'productId';
  static const String _lastVerificationKey = 'lastVerification';
  static const String _subscriptionActiveKey = 'subscriptionActive';
  
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
    bool? subscriptionActive,
  }) async {
    if (_box == null) {
      print('❌ Premium persistence box is null!');
      return;
    }
    
    print('💾 Saving premium status: $isPremium');
    
    await _box!.put(_isPremiumKey, isPremium);
    
    if (purchaseId != null) {
      await _box!.put(_purchaseIdKey, purchaseId);
      print('💾 Saved purchase ID: $purchaseId');
    }
    
    if (productId != null) {
      await _box!.put(_productIdKey, productId);
      print('💾 Saved product ID: $productId');
    }
    
    if (purchaseDate != null) {
      await _box!.put(_purchaseDateKey, purchaseDate.toIso8601String());
      print('💾 Saved purchase date: $purchaseDate');
    }
    
    if (subscriptionActive != null) {
      await _box!.put(_subscriptionActiveKey, subscriptionActive);
      print('💾 Saved subscription active status: $subscriptionActive');
    }
    
    // Always update last verification timestamp
    await _box!.put(_lastVerificationKey, DateTime.now().toIso8601String());
    
    // Update controller
    final controller = Get.find<PremiumController>();
    controller.isPremium.value = isPremium;
    
    print('✅ Premium status saved and controller updated');
  }
  
  // Load premium status
  static Future<void> loadPremiumStatus() async {
    if (_box == null) {
      print('❌ Premium persistence box is null during load!');
      return;
    }
    
    bool isPremium = _box!.get(_isPremiumKey, defaultValue: false);
    print('📖 Loading premium status from storage: $isPremium');
    
    // Update controller
    final controller = Get.find<PremiumController>();
    controller.isPremium.value = isPremium;
    
    print('✅ Premium status loaded and controller updated: ${controller.isPremium.value}');
  }
  
  // Get premium info
  static Map<String, dynamic> getPremiumInfo() {
    if (_box == null) return {};
    
    return {
      'isPremium': _box!.get(_isPremiumKey, defaultValue: false),
      'purchaseId': _box!.get(_purchaseIdKey),
      'productId': _box!.get(_productIdKey),
      'purchaseDate': _box!.get(_purchaseDateKey),
      'subscriptionActive': _box!.get(_subscriptionActiveKey, defaultValue: false),
      'lastVerification': _box!.get(_lastVerificationKey),
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
    if (_box == null) return true;
    
    String? lastVerificationStr = _box!.get(_lastVerificationKey);
    if (lastVerificationStr == null) return true;
    
    try {
      DateTime lastVerification = DateTime.parse(lastVerificationStr);
      DateTime now = DateTime.now();
      
      // Verify if more than 6 hours have passed since last verification
      // This ensures we check subscription status regularly without being too aggressive
      return now.difference(lastVerification).inHours > 6;
    } catch (e) {
      print('Error parsing last verification date: $e');
      return true;
    }
  }
  
  // Check if we have an active subscription that needs validation
  static bool hasSubscriptionToVerify() {
    if (_box == null) return false;
    
    String? productId = _box!.get(_productIdKey);
    if (productId == null) return false;
    
    // Only subscriptions need regular verification (not lifetime purchases)
    return productId.contains('monthly') || productId.contains('yearly') || productId.contains('annual');
  }
  
  // Update subscription verification timestamp
  static Future<void> updateLastVerification() async {
    if (_box == null) return;
    
    await _box!.put(_lastVerificationKey, DateTime.now().toIso8601String());
  }
}