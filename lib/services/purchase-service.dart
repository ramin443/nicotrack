import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get/get.dart';
import '../getx-controllers/premium-controller.dart';
import 'premium-persistence-service.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  // Product IDs - Update these with your actual App Store Connect IDs
  static const String monthlyProductId = 'nicotrack_monthly_plan';
  static const String yearlyProductId = 'nicotrack_yearly_plan';
  static const String lifetimeProductId = 'nicotrack_lifetime_premium';
  
  // All product IDs
  static const Set<String> _productIds = {
    monthlyProductId,
    yearlyProductId,
    lifetimeProductId,
  };

  // Available products
  final List<ProductDetails> products = [];
  
  // Store connection status
  bool isAvailable = false;
  
  // Purchase pending flag
  bool purchasePending = false;

  // Initialize the purchase service
  Future<void> initialize() async {
    try {
      // Check if the store is available
      isAvailable = await _inAppPurchase.isAvailable();


      if (!isAvailable) {
        print('Store is not available');
        return;
      }

      // Listen to purchase updates
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        print('Purchase stream error: $error');
      });

      // Load products
      await loadProducts();
      
      // Check for previous purchases and validate current subscription status
      await restorePurchases();
      
      // Additional validation for subscription status
      await Future.delayed(Duration(seconds: 1)); // Allow purchase stream to process
      await _validateActiveSubscriptions();
      
    } catch (e) {
      print('Error initializing purchase service: $e');
    }
  }

  // Load available products from the store
  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.error != null) {
        print('Error loading products: ${response.error}');
        return;
      }

      if (response.productDetails.isEmpty) {
        print('No products found');
        return;
      }

      products.clear();
      products.addAll(response.productDetails);
      
      // Sort products by type (monthly, yearly, lifetime)
      products.sort((a, b) {
        final order = {monthlyProductId: 0, yearlyProductId: 1, lifetimeProductId: 2};
        return (order[a.id] ?? 3).compareTo(order[b.id] ?? 3);
      });

      print('Loaded ${products.length} products');
      
      // Update prices in PremiumController
      _updatePricesInController();
      
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  // Update actual prices from store in the controller
  void _updatePricesInController() {
    final controller = Get.find<PremiumController>();
    
    for (final product in products) {
      String price = product.price;
      int planIndex = -1;
      
      switch (product.id) {
        case monthlyProductId:
          planIndex = 0;
          break;
        case yearlyProductId:
          planIndex = 1;
          break;
        case lifetimeProductId:
          planIndex = 2;
          break;
      }
      
      if (planIndex >= 0) {
        controller.subscriptionPlans[planIndex]?['price'] = price;
      }
    }
  }

  // Purchase a product
  Future<bool> purchaseProduct(int planIndex) async {
    if (!isAvailable || products.isEmpty) {
      print('Error: Store is not available');
      return false;
    }

    // Get the product ID based on plan index
    String productId;
    switch (planIndex) {
      case 0:
        productId = monthlyProductId;
        break;
      case 1:
        productId = yearlyProductId;
        break;
      case 2:
        productId = lifetimeProductId;
        break;
      default:
        return false;
    }

    // Find the product
    final ProductDetails? productDetails = products.firstWhereOrNull(
      (product) => product.id == productId,
    );

    if (productDetails == null) {
      print('Error: Product not found. Please try again.');
      return false;
    }

    // Create purchase parameter
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      purchasePending = true;
      
      // Buy non-consumable (lifetime) or subscription (monthly/yearly)
      bool success;
      if (planIndex == 2) {
        // Lifetime is non-consumable
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // Monthly and yearly are subscriptions - use proper subscription purchase
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        // Note: For iOS, both subscriptions and non-consumables use buyNonConsumable
        // The App Store handles subscription vs non-consumable based on product configuration
      }
      
      return success;
      
    } catch (e) {
      print('Purchase error: $e');
      purchasePending = false;
      print('Error: Purchase failed. Please try again.');
      return false;
    }
  }

  // Handle purchase updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    print('🔔 Purchase stream received ${purchaseDetailsList.length} updates');
    
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('📦 Processing purchase: ${purchaseDetails.productID} - Status: ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        print('⏳ Purchase pending for: ${purchaseDetails.productID}');
        purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
          print('❌ Purchase error: ${purchaseDetails.error}');
          print('Purchase Failed: Something went wrong. Please try again.');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          print('✅ Processing ${purchaseDetails.status == PurchaseStatus.purchased ? "purchase" : "restore"} for: ${purchaseDetails.productID}');
          
          // Verify purchase
          bool valid = await _verifyPurchase(purchaseDetails);
          print('🔐 Purchase verification result: $valid');
          
          if (valid) {
            // Update premium status
            await _deliverProduct(purchaseDetails);
          } else {
            print('❌ Purchase verification failed for: ${purchaseDetails.productID}');
          }
        }
        
        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          print('✔️ Completing purchase for: ${purchaseDetails.productID}');
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
        
        purchasePending = false;
      }
    }
  }

  // Verify purchase (implement server-side verification in production)  
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print('🔍 Verifying purchase for: ${purchaseDetails.productID}');
    
    // TODO: Implement server-side receipt validation
    // For now, we'll do basic client-side validation
    
    // Check if we have verification data
    if (purchaseDetails.verificationData.localVerificationData.isEmpty) {
      print('❌ No verification data found');
      return false;
    }
    
    // Check if product ID matches our expected products
    if (!_productIds.contains(purchaseDetails.productID)) {
      print('❌ Unknown product ID: ${purchaseDetails.productID}');
      return false;
    }
    
    print('✅ Basic verification passed for: ${purchaseDetails.productID}');
    
    // In production, send receipt to your server for validation
    // Return true for now (testing purposes)
    return true;
  }

  // Deliver the product (update user's premium status)
  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    final controller = Get.find<PremiumController>();
    
    print('🎉 Delivering premium product: ${purchaseDetails.productID}');
    
    // Store purchase info first (this also updates the controller via PremiumPersistenceService)
    await _savePurchaseInfo(purchaseDetails);
    
    // Force UI refresh
    controller.refreshPremiumStatus();
    
    print('✅ Success! Premium features unlocked! Current status: ${controller.isPremium.value}');
    
    // Show success dialog
    _showPurchaseSuccessDialog();
  }

  // Show purchase success dialog
  void _showPurchaseSuccessDialog() {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success checkmark
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Success title
                  Text(
                    'Purchase Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  
                  // Success message
                  Text(
                    'Your premium features have been activated. Enjoy unlimited access to all Nicotrack features!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  
                  // OK button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate back to previous screen
                      if (Navigator.canPop(Get.context!)) {
                        Navigator.pop(Get.context!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Save purchase information
  Future<void> _savePurchaseInfo(PurchaseDetails purchaseDetails) async {
    // Save purchase info using persistence service
    await PremiumPersistenceService.savePremiumStatus(
      isPremium: true,
      purchaseId: purchaseDetails.purchaseID,
      productId: purchaseDetails.productID,
      purchaseDate: DateTime.now(),
      subscriptionActive: true,
    );
  }

  // Restore previous purchases
  Future<void> restorePurchases() async {
    try {
      print('🔄 Starting restore purchases...');
      await _inAppPurchase.restorePurchases();
      
      // Wait a bit for the purchase stream to process restored purchases
      await Future.delayed(Duration(seconds: 2));
      
      final controller = Get.find<PremiumController>();
      print('📱 After restore - Premium status: ${controller.isPremium.value}');
      
      // The purchase stream will handle the restored purchases
    } catch (e) {
      print('❌ Restore error: $e');
      print('Restore Failed: Could not restore purchases. Please try again.');
    }
  }

  // Check if user has active subscription
  Future<bool> checkSubscriptionStatus() async {
    print('🔍 Checking subscription status...');
    
    // Always check current subscription status with the store
    await _verifyCurrentSubscriptionStatus();
    
    final controller = Get.find<PremiumController>();
    return controller.isPremium.value;
  }

  // Verify current subscription status with the app store
  Future<void> _verifyCurrentSubscriptionStatus() async {
    try {
      print('🔄 Verifying subscription status with app store...');
      
      if (!isAvailable) {
        print('❌ App store is not available for verification');
        return;
      }

      // First, try to restore purchases to get current subscription status
      await _inAppPurchase.restorePurchases();
      
      // Wait for the purchase stream to process
      await Future.delayed(Duration(seconds: 3));
      
      // Update verification timestamp
      await PremiumPersistenceService.updateLastVerification();
      
      final controller = Get.find<PremiumController>();
      print('✅ Subscription verification complete. Premium status: ${controller.isPremium.value}');
      
    } catch (e) {
      print('❌ Error verifying subscription status: $e');
      
      // If verification fails, check if we have existing premium status
      // but mark that verification failed
      final premiumInfo = PremiumPersistenceService.getPremiumInfo();
      if (premiumInfo['isPremium'] == true) {
        print('⚠️ Using cached premium status due to verification failure');
      }
    }
  }

  // Comprehensive subscription verification (for app startup)
  Future<void> verifySubscriptionOnStartup() async {
    print('🚀 Starting comprehensive subscription verification on app startup...');
    
    // Check if we need verification
    if (!PremiumPersistenceService.needsVerification() && 
        !PremiumPersistenceService.hasSubscriptionToVerify()) {
      print('✅ No verification needed at this time');
      return;
    }
    
    try {
      // Perform comprehensive verification
      await _verifyCurrentSubscriptionStatus();
      
      // Additional validation for TestFlight and production subscriptions
      await _validateActiveSubscriptions();
      
    } catch (e) {
      print('❌ Comprehensive verification failed: $e');
    }
  }

  // Validate active subscriptions using restore purchases
  Future<void> _validateActiveSubscriptions() async {
    try {
      print('🔍 Validating active subscriptions using restore...');
      
      // Use restore purchases to validate current subscription status
      // The purchase stream will handle the validation when purchases are restored
      await _inAppPurchase.restorePurchases();
      
      // Give time for the purchase stream to process restored purchases
      await Future.delayed(Duration(seconds: 2));
      
      // Check current premium status after restore
      final controller = Get.find<PremiumController>();
      print('📊 After validation - Premium status: ${controller.isPremium.value}');
      
    } catch (e) {
      print('❌ Error validating active subscriptions: $e');
      
      // If restore fails, check if we have existing premium info
      final premiumInfo = PremiumPersistenceService.getPremiumInfo();
      if (premiumInfo['isPremium'] == true) {
        print('⚠️ Restore failed but using cached premium status');
      }
    }
  }

  // Get product details by plan index
  ProductDetails? getProductByPlanIndex(int planIndex) {
    String productId;
    switch (planIndex) {
      case 0:
        productId = monthlyProductId;
        break;
      case 1:
        productId = yearlyProductId;
        break;
      case 2:
        productId = lifetimeProductId;
        break;
      default:
        return null;
    }
    
    return products.firstWhereOrNull((product) => product.id == productId);
  }

  // Dispose resources
  void dispose() {
    _subscription.cancel();
  }
}