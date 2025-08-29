import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../getx-controllers/premium-controller.dart';
import 'premium-persistence-service.dart';
import '../screens/premium/purchase-success-dialog.dart';
import '../constants/color-constants.dart';
import '../constants/font-constants.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  // Product IDs - Must match EXACTLY with App Store Connect configuration
  static const String monthlyProductId = 'nicotrack_monthly_plan';
  static const String yearlyProductId = 'nicotrack_yearly_plan';
  static const String lifetimeProductId = 'nicotrack_lifetime_premium'; // Non-consumable in App Store Connect
  
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
      print('🚀 Initializing purchase service...');
      
      // Check if the store is available
      isAvailable = await _inAppPurchase.isAvailable();

      if (!isAvailable) {
        print('❌ Store is not available');
        return;
      }
      
      print('✅ Store is available');

      // Listen to purchase updates
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        print('❌ Purchase stream error: $error');
      });

      // Load products with retry logic
      await loadProducts();
      
      // If products didn't load, try once more after a delay
      if (products.isEmpty) {
        print('⚠️ No products loaded on first attempt, retrying...');
        await Future.delayed(Duration(seconds: 2));
        await loadProducts();
      }
      
      // Log final product load status
      if (products.isEmpty) {
        print('❌ WARNING: No products loaded after retries!');
        print('❌ Users will not be able to make purchases');
      } else {
        print('✅ Products loaded successfully: ${products.map((p) => p.id).toList()}');
      }
      
      // Critical: Check for previous purchases and validate current subscription status
      // This is essential for TestFlight subscriptions to be recognized
      print('🔄 Starting purchase restoration and validation...');
      await restorePurchases();
      
      // Wait longer for purchase stream to process - critical for TestFlight
      await Future.delayed(Duration(seconds: 3)); 
      
      // Additional validation for subscription status
      await _validateActiveSubscriptions();
      
      // Final check - if we still don't have premium but have stored info, validate it
      final controller = Get.find<PremiumController>();
      if (!controller.isPremium.value) {
        print('🔍 Premium not detected after init, checking stored info...');
        await _validateStoredPurchaseInfo();
      }
      
      print('✅ Purchase service initialization complete. Premium status: ${controller.isPremium.value}');
      
    } catch (e) {
      print('Error initializing purchase service: $e');
    }
  }

  // Load available products from the store
  Future<void> loadProducts() async {
    try {
      print('🔍 Loading products from store...');
      print('🔍 Product IDs to query: $_productIds');
      
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.error != null) {
        print('❌ Error loading products: ${response.error}');
        print('❌ Error code: ${response.error?.code}');
        print('❌ Error message: ${response.error?.message}');
        return;
      }

      if (response.productDetails.isEmpty) {
        print('⚠️ No products found from store');
        print('⚠️ Not found product IDs: ${response.notFoundIDs}');
        return;
      }

      products.clear();
      products.addAll(response.productDetails);
      
      // Log each loaded product
      print('✅ Successfully loaded ${products.length} products:');
      for (final product in response.productDetails) {
        print('  📦 Product ID: ${product.id}');
        print('     Price: ${product.price}');
        print('     Title: ${product.title}');
        print('     Description: ${product.description}');
        
        // Special logging for lifetime product
        if (product.id == lifetimeProductId) {
          print('  🏆 LIFETIME PRODUCT DETAILS:');
          print('     Raw price: ${product.rawPrice}');
          print('     Currency code: ${product.currencyCode}');
          print('     Currency symbol: ${product.currencySymbol}');
        }
      }
      
      // Check specifically for lifetime product
      final hasLifetime = products.any((p) => p.id == lifetimeProductId);
      print('🔍 Lifetime product loaded: $hasLifetime');
      if (!hasLifetime && response.notFoundIDs.contains(lifetimeProductId)) {
        print('❌ LIFETIME PRODUCT NOT FOUND IN STORE!');
        print('❌ Make sure nicotrack_lifetime_premium is configured in App Store Connect');
      }
      
      // Sort products by type (monthly, yearly, lifetime)
      products.sort((a, b) {
        final order = {monthlyProductId: 0, yearlyProductId: 1, lifetimeProductId: 2};
        return (order[a.id] ?? 3).compareTo(order[b.id] ?? 3);
      });

      print('📊 Final product count: ${products.length}');
      
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
    print('🛒 Starting purchase for plan index: $planIndex');
    
    if (!isAvailable) {
      print('❌ Store is not available');
      _showStoreNotAvailableError();
      return false;
    }
    
    if (products.isEmpty) {
      print('❌ No products loaded yet');
      // Try to reload products once
      print('🔄 Attempting to reload products...');
      await loadProducts();
      
      if (products.isEmpty) {
        print('❌ Still no products after reload');
        _showStoreNotAvailableError();
        return false;
      }
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
        print('❌ Invalid plan index: $planIndex');
        return false;
    }
    
    print('🔍 Looking for product: $productId');
    print('🔍 Available products: ${products.map((p) => p.id).toList()}');

    // Find the product
    final ProductDetails? productDetails = products.firstWhereOrNull(
      (product) => product.id == productId,
    );

    if (productDetails == null) {
      purchasePending = false;
      
      // Show detailed error dialog for debugging
      _showDebugDialog(
        'Product Not Found',
        'Product ID: $productId\n\n'
        'Available products: ${products.map((p) => p.id).join(", ")}\n\n'
        'Possible causes:\n'
        '1. Product ID mismatch\n'
        '2. Not approved in TestFlight\n'
        '3. Wrong product type\n'
        '4. Network/store issue',
        autoClose: false,
      );
      
      _showProductNotFoundError(productId);
      return false;
    }
    
    // Extra debugging for lifetime product
    if (productId == lifetimeProductId) {
      _showDebugDialog(
        'Lifetime Product Found',
        'ID: ${productDetails.id}\n'
        'Title: ${productDetails.title}\n'
        'Price: ${productDetails.price}\n'
        'Raw price: ${productDetails.rawPrice}\n'
        'Currency: ${productDetails.currencyCode}\n'
        'Attempting purchase...',
        autoClose: true,
        duration: 3,
      );
    }

    // Create purchase parameter
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: null, // Optional: can be used for server-side validation
    );

    try {
      purchasePending = true;
      
      // Special handling for lifetime product
      if (productId == lifetimeProductId) {
        // Check if user already owns this product
        final controller = Get.find<PremiumController>();
        final premiumInfo = PremiumPersistenceService.getPremiumInfo();
        if (premiumInfo['productId'] == lifetimeProductId && controller.isPremium.value) {
          purchasePending = false;
          
          _showDebugDialog(
            'Already Owned',
            'User already owns lifetime access!\n'
            'Premium status: ${controller.isPremium.value}',
            autoClose: true,
            duration: 3,
          );
          
          // Show a message that they already own it
          Get.snackbar(
            'Already Purchased',
            'You already have lifetime access!',
            backgroundColor: Color(0xFFFFB800),
            colorText: Colors.black,
            duration: Duration(seconds: 3),
          );
          return false;
        }
      }
      
      // For iOS, both subscriptions and non-consumables use buyNonConsumable
      // The difference is handled by the App Store based on product configuration
      bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      _showDebugDialog(
        'Purchase Initiated',
        'Product: $productId\n'
        'Success: $success\n'
        'Waiting for App Store response...',
        autoClose: true,
        duration: 3,
      );
      
      if (!success) {
        purchasePending = false;
        
        
      }
      
      return success;
      
    } catch (e) {
      purchasePending = false;
      
      _showDebugDialog(
        'Purchase Exception',
        'Product: $productId\n'
        'Error: $e\n'
        'Type: ${e.runtimeType}',
        autoClose: false,
      );
      
      // Show error dialog for TestFlight debugging
      _showPurchaseError(productId, e.toString());
      return false;
    }
  }

  // Handle purchase updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          
          // Verify purchase
          bool valid = await _verifyPurchase(purchaseDetails);
          
          if (valid) {
            // Determine if this is a new purchase vs restored purchase
            bool isNewPurchase = purchaseDetails.status == PurchaseStatus.purchased;
            
            await _deliverProduct(purchaseDetails, showDialog: isNewPurchase);
          }
        } else {
          _showDebugDialog(
            'Unknown Status',
            'Product: ${purchaseDetails.productID}\n'
            'Unknown status: ${purchaseDetails.status}',
            autoClose: true,
            duration: 3,
          );
        }
        
        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          try {
            await _inAppPurchase.completePurchase(purchaseDetails);
          } catch (e) {
            _showDebugDialog(
              'Completion Error',
              'Product: ${purchaseDetails.productID}\n'
              'Error completing purchase: $e',
              autoClose: true,
              duration: 4,
            );
          }
        }
        
        purchasePending = false;
      }
    }
    
    // After processing all purchases, verify the current premium status
    final controller = Get.find<PremiumController>();
    _showDebugDialog(
      'Purchase Processing Complete',
      'Final premium status: ${controller.isPremium.value}',
      autoClose: true,
      duration: 2,
    );
  }

  // Verify purchase (implement server-side verification in production)  
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print('🔍 Verifying purchase for: ${purchaseDetails.productID}');
    print('🔍 Purchase status: ${purchaseDetails.status}');
    print('🔍 Purchase ID: ${purchaseDetails.purchaseID}');
    print('🔍 Transaction date: ${purchaseDetails.transactionDate}');
    
    // For TestFlight and development, be more lenient with verification
    // Check if product ID matches our expected products
    if (!_productIds.contains(purchaseDetails.productID)) {
      print('❌ Unknown product ID: ${purchaseDetails.productID}');
      return false;
    }
    
    // Check if we have verification data
    if (purchaseDetails.verificationData.localVerificationData.isEmpty) {
      print('⚠️ No verification data found, but accepting for TestFlight/development');
      // For TestFlight, we might not always have verification data, so we'll be lenient
    } else {
      print('✅ Verification data found: ${purchaseDetails.verificationData.localVerificationData.length} bytes');
    }
    
    // For TestFlight and development testing, accept the purchase if it has a valid product ID
    // and the status is purchased or restored
    if (purchaseDetails.status == PurchaseStatus.purchased || 
        purchaseDetails.status == PurchaseStatus.restored) {
      print('✅ Purchase verification passed for: ${purchaseDetails.productID}');
      return true;
    }
    
    print('❌ Purchase verification failed - invalid status: ${purchaseDetails.status}');
    return false;
  }

  // Deliver the product (update user's premium status)
  Future<void> _deliverProduct(PurchaseDetails purchaseDetails, {bool showDialog = true}) async {
    print('🎉 Delivering premium product: ${purchaseDetails.productID}');
    print('🎉 Purchase ID: ${purchaseDetails.purchaseID}');
    print('🎉 Transaction date: ${purchaseDetails.transactionDate}');
    
    try {
      // CRITICAL: Update premium status IMMEDIATELY in controller
      final controller = Get.find<PremiumController>();
      print('📱 Setting premium status to TRUE in controller...');
      controller.isPremium.value = true;  // Set immediately
      
      // Store purchase info (this will persist the status and update controller again)
      print('💾 Saving purchase info to persistent storage...');
      await _savePurchaseInfo(purchaseDetails);
      
      // Double-check and force UI refresh
      print('🔄 Forcing UI refresh...');
      controller.refreshPremiumStatus();
      
      // Verify the status was actually set
      print('✅ Premium delivery complete!');
      print('✅ Controller premium status: ${controller.isPremium.value}');
      print('✅ Effective premium status: ${controller.effectivePremiumStatus}');
      
      // Get plan type for dialog
      String planType = 'Premium Active';
      switch (purchaseDetails.productID) {
        case monthlyProductId:
          planType = 'Monthly Plan Activated';
          break;
        case yearlyProductId:
          planType = 'Annual Plan Activated';
          break;
        case lifetimeProductId:
          planType = 'Lifetime Access Activated';
          break;
      }
      
      // Show success dialog only for new purchases (not restored ones)
      if (showDialog) {
        // Show immediately but ensure UI thread is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showPurchaseSuccessDialogSafe(planType);
        });
      }
      
    } catch (e) {
      print('❌ Error delivering premium product: $e');
      // Even if there's an error, try to set premium status
      try {
        final controller = Get.find<PremiumController>();
        controller.isPremium.value = true;
      } catch (controllerError) {
        print('❌ Failed to set premium status in controller: $controllerError');
      }
    }
  }

  // Show purchase success dialog
  void _showPurchaseSuccessDialog(String planType) {
    _showDebugDialog(
      'Success Dialog Check',
      'Starting success dialog...\n'
      'Plan: $planType\n'
      'Get.context: ${Get.context != null}\n'
      'Get.overlayContext: ${Get.overlayContext != null}',
      autoClose: true,
      duration: 2,
    );
    
    // Get the most reliable context available
    BuildContext? context = Get.context ?? Get.overlayContext;
    
    if (context != null && context.mounted) {
      _showDebugDialog(
        'Context Found',
        'Valid context found, proceeding with dialog...',
        autoClose: true,
        duration: 1,
      );
      
      // First, try to close any existing loading dialogs
      try {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close loading dialog
        }
      } catch (e) {
        _showDebugDialog(
          'Loading Dialog Error',
          'Could not close loading dialog: $e',
          autoClose: true,
          duration: 3,
        );
      }
      
      // Small delay to ensure UI is ready after closing loading dialog
      Future.delayed(Duration(milliseconds: 100), () {
        if (context.mounted) {
          _showDebugDialog(
            'Showing Success Dialog',
            'About to call showDialog...\n'
            'Context still mounted: ${context.mounted}',
            autoClose: true,
            duration: 1,
          );
          
          // Show as a proper dialog, not a route
          try {
            showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Purchase Successful!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFB800),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Thank you for your purchase! You now have access to all premium features.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                
                // Also close any loading dialogs or premium screens
                _closeLoadingDialogsAndNavigateToHome(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFFFB800),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
                ),
              ],
            ),
          );
          } catch (e) {
            _showDebugDialog(
              'ShowDialog Failed',
              'Error showing success dialog: $e\n'
              'Type: ${e.runtimeType}',
              autoClose: false,
            );
          }
        } else {
          _showDebugDialog(
            'Context Lost',
            'Context no longer mounted after delay',
            autoClose: true,
            duration: 3,
          );
        }
      });
    } else {
      _showDebugDialog(
        'Context Error',
        'No valid context for success dialog\n'
        'Get.context: ${Get.context != null ? "available" : "null"}\n'
        'Get.overlayContext: ${Get.overlayContext != null ? "available" : "null"}\n'
        'Falling back to snackbar...',
        autoClose: true,
        duration: 4,
      );
      
      // Fallback to snackbar if no context available
      _showPurchaseSuccessSnackbar(planType);
    }
  }
  
  void _showPurchaseSuccessSnackbar(String planType) {
    // Use regular ScaffoldMessenger instead of Get.snackbar to avoid null errors
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.black),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎉 Purchase Successful',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      planType,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFFFB800),
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
  
  void _closeLoadingDialogsAndNavigateToHome(BuildContext context) {
    try {
      // Try to pop any existing loading dialogs
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      // Navigate to home/base screen if we're in the premium paywall
      // This helps ensure user sees their premium features activated
      final currentRoute = ModalRoute.of(context);
      if (currentRoute != null && currentRoute.settings.name?.contains('premium') == true) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      print('⚠️ Error closing dialogs/navigating: $e');
    }
  }

  // Save purchase information
  Future<void> _savePurchaseInfo(PurchaseDetails purchaseDetails) async {
    print('💾 Saving purchase info for product: ${purchaseDetails.productID}');
    print('💾 Purchase ID: ${purchaseDetails.purchaseID}');
    print('💾 Transaction date: ${purchaseDetails.transactionDate}');
    
    // Determine if this is a subscription or lifetime purchase
    bool isSubscription = purchaseDetails.productID != lifetimeProductId;
    print('💾 Product type: ${isSubscription ? "Subscription" : "Lifetime Purchase"}');
    
    // Save purchase info using persistence service
    await PremiumPersistenceService.savePremiumStatus(
      isPremium: true,
      purchaseId: purchaseDetails.purchaseID,
      productId: purchaseDetails.productID,
      purchaseDate: purchaseDetails.transactionDate != null 
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(purchaseDetails.transactionDate!))
          : DateTime.now(),
      subscriptionActive: isSubscription, // Only true for subscription products
    );
    
    print('💾 Purchase info saved successfully (subscriptionActive: $isSubscription)');
    
    // Special logging for lifetime purchases
    if (purchaseDetails.productID == lifetimeProductId) {
      print('🏆 LIFETIME PURCHASE PERSISTENCE COMPLETE!');
      print('🏆 Saved with subscriptionActive: $isSubscription (should be false)');
      
      // Verify it was saved correctly
      final savedInfo = PremiumPersistenceService.getPremiumInfo();
      print('🏆 Verification - isPremium: ${savedInfo['isPremium']}');
      print('🏆 Verification - productId: ${savedInfo['productId']}');
      print('🏆 Verification - subscriptionActive: ${savedInfo['subscriptionActive']}');
    }
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

  // Validate active subscriptions using multiple methods
  Future<void> _validateActiveSubscriptions() async {
    try {
      print('🔍 Validating active subscriptions using multiple methods...');
      
      // Method 1: Use restore purchases to validate current subscription status
      print('📱 Method 1: Checking via restore purchases...');
      await _inAppPurchase.restorePurchases();
      
      // Give time for the purchase stream to process restored purchases
      await Future.delayed(Duration(seconds: 3));
      
      // Method 2: Query current purchase status directly if available
      print('📱 Method 2: Checking current purchase status...');
      await _checkCurrentPurchaseStatus();
      
      // Check current premium status after validation
      final controller = Get.find<PremiumController>();
      print('📊 After comprehensive validation - Premium status: ${controller.isPremium.value}');
      
      // Method 3: If we still don't have premium but have stored purchase info, validate it
      if (!controller.isPremium.value) {
        await _validateStoredPurchaseInfo();
      }
      
    } catch (e) {
      print('❌ Error validating active subscriptions: $e');
      
      // If all validation methods fail, check if we have existing premium info
      final premiumInfo = PremiumPersistenceService.getPremiumInfo();
      if (premiumInfo['isPremium'] == true) {
        print('⚠️ Validation failed but using cached premium status');
        final controller = Get.find<PremiumController>();
        controller.isPremium.value = true;
      }
    }
  }
  
  // Check current purchase status (alternative method)
  Future<void> _checkCurrentPurchaseStatus() async {
    try {
      // For iOS, we can check if products are available and try to get current entitlements
      if (!isAvailable) return;
      
      // This is a simple availability check - real validation happens through purchase stream
      print('📱 Store is available, checking for active purchases...');
      
      // The main validation still happens through the purchase stream and restorePurchases
      // This is just an additional check to ensure store connectivity
      
    } catch (e) {
      print('❌ Error checking current purchase status: $e');
    }
  }
  
  // Validate stored purchase information
  Future<void> _validateStoredPurchaseInfo() async {
    try {
      print('🔍 Validating stored purchase information...');
      
      final premiumInfo = PremiumPersistenceService.getPremiumInfo();
      bool hasPremiumInfo = premiumInfo['isPremium'] == true;
      String? productId = premiumInfo['productId'];
      String? purchaseDate = premiumInfo['purchaseDate'];
      
      if (hasPremiumInfo && productId != null && purchaseDate != null) {
        print('📦 Found stored premium info - Product: $productId, Date: $purchaseDate');
        
        // For TestFlight and production, if we have stored premium info, trust it temporarily
        // while we wait for proper store validation
        final controller = Get.find<PremiumController>();
        if (!controller.isPremium.value) {
          print('🎯 Setting premium status based on stored info while validation completes');
          controller.isPremium.value = true;
        }
      }
      
    } catch (e) {
      print('❌ Error validating stored purchase info: $e');
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

  // Show error dialog for debugging TestFlight issues
  void _showProductNotFoundError(String productId) {
    if (Get.context != null) {
      String loadedProducts = products.isEmpty 
          ? 'No products loaded' 
          : products.map((p) => '${p.id}: ${p.price}').join('\n');
      
      // Check specifically if lifetime product was requested
      bool isLifetimeRequest = productId == lifetimeProductId;
      String lifetimeStatus = '';
      
      if (isLifetimeRequest) {
        bool lifetimeFound = products.any((p) => p.id == lifetimeProductId);
        lifetimeStatus = '\n🏆 LIFETIME DEBUG:\n'
                        '• Lifetime product found: $lifetimeFound\n'
                        '• Store available: $isAvailable\n'
                        '• Total products loaded: ${products.length}\n'
                        '• Product IDs searched: $_productIds';
      }
      
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('DEBUG: Product Not Available'),
          content: SingleChildScrollView(
            child: Text(
              'REQUESTED: $productId\n\n'
              'LOADED PRODUCTS:\n$loadedProducts\n'
              '$lifetimeStatus\n\n'
              'POSSIBLE ISSUES:\n'
              '• Product not configured in App Store Connect\n'
              '• Product ID mismatch\n'
              '• Product not approved for TestFlight\n'
              '• For Lifetime: Must be Non-Consumable type\n'
              '• Network/Store connection issue',
              style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Try to reload products and show result
                await loadProducts();
                _showProductLoadDebug();
              },
              child: Text('Reload & Debug'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  void _showProductLoadDebug() {
    if (Get.context != null) {
      String debugInfo = 'STORE CONNECTION:\n'
                        '• Store available: $isAvailable\n'
                        '• Products loaded: ${products.length}\n'
                        '• Purchase pending: $purchasePending\n\n';
      
      // Add detailed lifetime product analysis
      final hasLifetime = products.any((p) => p.id == lifetimeProductId);
      debugInfo += 'LIFETIME PRODUCT ANALYSIS:\n'
                  '• Expected ID: $lifetimeProductId\n'
                  '• Found in store: $hasLifetime\n';
      
      if (hasLifetime) {
        final lifetimeProduct = products.firstWhere((p) => p.id == lifetimeProductId);
        debugInfo += '• Price: ${lifetimeProduct.price}\n'
                    '• Raw price: ${lifetimeProduct.rawPrice}\n'
                    '• Currency: ${lifetimeProduct.currencyCode}\n'
                    '• Title: ${lifetimeProduct.title}\n'
                    '• ✅ LIFETIME PRODUCT IS LOADED!\n\n';
      } else {
        debugInfo += '• ❌ LIFETIME PRODUCT NOT FOUND!\n'
                    '• This is likely the main issue\n\n';
      }
      
      debugInfo += 'ALL PRODUCTS:\n';
      if (products.isEmpty) {
        debugInfo += '• NO PRODUCTS LOADED\n\n'
                    'POSSIBLE CAUSES:\n'
                    '• App Store Connect configuration\n'
                    '• Internet connection issue\n'
                    '• Products not approved for TestFlight\n'
                    '• Product IDs don\'t match exactly\n'
                    '• Lifetime product not set as Non-Consumable';
      } else {
        for (int i = 0; i < products.length; i++) {
          final product = products[i];
          debugInfo += '${i + 1}. ${product.id}\n'
                      '   Price: ${product.price}\n'
                      '   Title: ${product.title.length > 40 ? product.title.substring(0, 40) + "..." : product.title}\n';
          
          if (product.id == lifetimeProductId) {
            debugInfo += '   🏆 << THIS IS THE LIFETIME PRODUCT\n';
          }
          debugInfo += '\n';
        }
      }
      
      // Add specific lifetime troubleshooting steps
      if (!hasLifetime) {
        debugInfo += '\n🔧 LIFETIME TROUBLESHOOTING:\n'
                    '1. Check App Store Connect:\n'
                    '   • Product ID: nicotrack_lifetime_premium\n'
                    '   • Type: Non-Consumable\n'
                    '   • Status: Approved\n'
                    '2. Verify TestFlight access\n'
                    '3. Check internet connection\n'
                    '4. Try "Retry & Debug" button';
      }
      
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('DEBUG: Purchase System Status'),
          content: SingleChildScrollView(
            child: Text(
              debugInfo,
              style: TextStyle(fontSize: 9, fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Try to reload products and show updated status
                await loadProducts();
                Future.delayed(Duration(milliseconds: 500), () {
                  _showProductLoadDebug();
                });
              },
              child: Text('Retry & Debug'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  void _showPurchaseError(String productId, String error) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Debug: Purchase Error'),
          content: Text('Purchase failed for: $productId\n\nError: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  void _showStoreNotAvailableError() {
    if (Get.context != null) {
      String productList = products.isEmpty 
          ? 'None' 
          : products.map((p) => '${p.id}:${p.price}').join(', ');
      
      // Check if lifetime product is specifically missing
      bool lifetimeFound = products.any((p) => p.id == lifetimeProductId);
      String lifetimeCheck = lifetimeFound ? '✅ Found' : '❌ Missing';
          
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('DEBUG: Store/Products Issue'),
          content: SingleChildScrollView(
            child: Text(
              'STORE STATUS:\n'
              '• Store available: $isAvailable\n'
              '• Products loaded: ${products.length}\n\n'
              'PRODUCTS FOUND:\n$productList\n\n'
              'LIFETIME STATUS: $lifetimeCheck\n'
              '• Expected ID: $lifetimeProductId\n\n'
              'CHECKLIST:\n'
              '• Internet connection OK?\n'
              '• Signed into TestFlight?\n'
              '• Lifetime product approved in App Store Connect?\n'
              '• Product configured as Non-Consumable?\n'
              '• Product ID matches exactly?',
              style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Try to reinitialize and show debug
                await initialize();
                _showProductLoadDebug();
              },
              child: Text('Retry & Debug'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Public method to show debug dialog from other screens
  void showDebugDialog() {
    _showProductLoadDebug();
  }
  
  void testSuccessDialog() {
    _showDebugDialog(
      'Testing Success Dialog',
      'About to test success dialog...\n'
      'Context available: ${Get.context != null}\n'
      'Overlay context: ${Get.overlayContext != null}',
      autoClose: false,
    );
    
    // Show success dialog after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      _showPurchaseSuccessDialog('Monthly Plan Activated (TEST)');
    });
  }
  
  // Reusable debug dialog method for TestFlight
  void _showDebugDialog(String title, String message, {bool autoClose = false, int duration = 0}) {
    if (Get.context != null) {
      showDialog(
        context: Get.context!,
        barrierDismissible: !autoClose,
        builder: (context) {
          if (autoClose && duration > 0) {
            Timer(Duration(seconds: duration), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
          
          return AlertDialog(
            title: Text('DEBUG: $title'),
            content: Text(
              message,
              style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
            ),
            actions: autoClose ? null : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  
  // Monitor lifetime purchase progress
  Timer? _lifetimeMonitorTimer;
  
  void _startLifetimePurchaseMonitoring() {
    print('🏆 Starting lifetime purchase monitoring...');
    
    // Cancel any existing timer
    _lifetimeMonitorTimer?.cancel();
    
    // Start 10-second timer to check if purchase stream responds
    _lifetimeMonitorTimer = Timer(Duration(seconds: 10), () {
      print('🏆 LIFETIME PURCHASE TIMEOUT: No purchase stream response in 10 seconds');
      
      // Check current premium status
      final controller = Get.find<PremiumController>();
      if (!controller.isPremium.value && purchasePending) {
        print('🏆 Purchase still pending after 10 seconds - likely stuck');
        
        _showLifetimePurchaseFailureDebug(
          success: true, 
          error: 'Purchase initiated but no response from App Store after 10 seconds'
        );
      }
    });
  }
  
  void _showLifetimePurchaseFailureDebug({required bool success, required String error}) {
    if (Get.context != null) {
      final controller = Get.find<PremiumController>();
      final hasLifetimeProduct = products.any((p) => p.id == lifetimeProductId);
      
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('🏆 LIFETIME Purchase Debug'),
          content: SingleChildScrollView(
            child: Text(
              'LIFETIME PURCHASE STATUS:\n'
              '• Product found: $hasLifetimeProduct\n'
              '• Purchase initiated: $success\n'
              '• Purchase pending: $purchasePending\n'
              '• Premium status: ${controller.isPremium.value}\n\n'
              'ERROR: $error\n\n'
              'ANALYSIS:\n'
              '${hasLifetimeProduct ? "✅ Product is loaded correctly" : "❌ Product not found - main issue"}\n'
              '${success ? "✅ Purchase call succeeded" : "❌ Purchase call failed"}\n'
              '${purchasePending ? "⏳ Waiting for App Store" : "❌ No purchase in progress"}\n\n'
              'NEXT STEPS:\n'
              '1. If product not found: Check App Store Connect\n'
              '2. If purchase fails: Check TestFlight permissions\n'
              '3. If timeout: Check internet/store connection\n'
              '4. Try manual restore purchases',
              style: TextStyle(fontSize: 9, fontFamily: 'monospace'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await restorePurchases();
              },
              child: Text('Restore Purchases'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  // Safe success dialog method that handles context issues
  void _showPurchaseSuccessDialogSafe(String planType) {
    // Try to find a valid context
    BuildContext? context = Get.context ?? Get.overlayContext;
    
    if (context != null && context.mounted) {
      _showPurchaseSuccessDialogWithContext(context, planType);
    } else {
      // Fallback to snackbar if no valid context
      _showPurchaseSuccessSnackbar(planType);
    }
  }

  // Context-aware success dialog method
  void _showPurchaseSuccessDialogWithContext(BuildContext context, String planType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: nicotrackBlack1,
        contentPadding: EdgeInsets.all(24.w),
        title: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nicotrackGreen,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Purchase Successful!',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: circularBold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: nicotrackGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: nicotrackGreen.withOpacity(0.3)),
              ),
              child: Text(
                planType,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: nicotrackGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Thank you for your purchase! You now have access to all premium features and can start your enhanced quit journey.',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: circularBook,
                color: Colors.white.withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: nicotrackGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dispose resources
  void dispose() {
    _subscription.cancel();
    _lifetimeMonitorTimer?.cancel();
  }
}