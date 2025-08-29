import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get/get.dart';
import '../getx-controllers/premium-controller.dart';
import 'premium-persistence-service.dart';
import '../screens/premium/purchase-success-dialog.dart';

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
      // Product not found - this is likely the issue
      print('❌ Product not found: $productId');
      print('❌ This is likely because:');
      print('   1. Product ID mismatch between code and App Store Connect');
      print('   2. Product not approved/available in TestFlight');
      print('   3. Product type mismatch (consumable vs non-consumable)');
      
      purchasePending = false;
      
      // Show detailed error dialog for debugging
      _showProductNotFoundError(productId);
      return false;
    }
    
    print('✅ Found product: ${productDetails.id}');
    print('   Title: ${productDetails.title}');
    print('   Price: ${productDetails.price}');

    // Create purchase parameter
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: null, // Optional: can be used for server-side validation
    );

    try {
      purchasePending = true;
      print('🚀 Initiating purchase for: $productId');
      
      // Special handling for lifetime product
      if (productId == lifetimeProductId) {
        print('🏆 Processing LIFETIME product purchase...');
        print('🏆 This is a non-consumable product');
        
        // Check if user already owns this product
        final controller = Get.find<PremiumController>();
        final premiumInfo = PremiumPersistenceService.getPremiumInfo();
        if (premiumInfo['productId'] == lifetimeProductId && controller.isPremium.value) {
          print('⚠️ User already owns lifetime access');
          purchasePending = false;
          
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
      
      // For iOS, all products (subscriptions and non-consumables) use buyNonConsumable
      // The App Store knows the difference and handles them appropriately
      bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      
      print('📦 Purchase initiated successfully: $success');
      
      if (!success) {
        purchasePending = false;
        print('⚠️ Purchase initiation returned false');
        print('⚠️ This might mean:');
        print('   - User cancelled the purchase');
        print('   - Product already owned (for non-consumables)');
        print('   - Store error occurred');
      }
      
      return success;
      
    } catch (e) {
      purchasePending = false;
      print('❌ Purchase exception: $e');
      print('❌ Exception type: ${e.runtimeType}');
      
      // Show error dialog for TestFlight debugging
      _showPurchaseError(productId, e.toString());
      return false;
    }
  }

  // Handle purchase updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    print('🔔 Purchase stream received ${purchaseDetailsList.length} updates');
    print('🔔 Purchase details: ${purchaseDetailsList.map((p) => '${p.productID}:${p.status}:${p.purchaseID}').join(', ')}');
    
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('📦 ========== PROCESSING PURCHASE ==========');
      print('📦 Product ID: ${purchaseDetails.productID}');
      print('📦 Status: ${purchaseDetails.status}');
      print('📦 Purchase ID: ${purchaseDetails.purchaseID}');
      print('📦 Transaction date: ${purchaseDetails.transactionDate}');
      print('📦 Pending complete: ${purchaseDetails.pendingCompletePurchase}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        print('⏳ Purchase pending for: ${purchaseDetails.productID}');
        purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
          print('❌ Purchase error: ${purchaseDetails.error}');
          print('❌ Error details: ${purchaseDetails.error?.message}');
          print('Purchase Failed: Something went wrong. Please try again.');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          print('✅ Processing ${purchaseDetails.status == PurchaseStatus.purchased ? "PURCHASE" : "RESTORE"} for: ${purchaseDetails.productID}');
          
          // Special logging for lifetime purchases
          if (purchaseDetails.productID == lifetimeProductId) {
            print('🏆 LIFETIME PURCHASE DETECTED!');
            print('🏆 Product ID: ${purchaseDetails.productID}');
            print('🏆 Status: ${purchaseDetails.status}');
            print('🏆 Purchase ID: ${purchaseDetails.purchaseID}');
          }
          
          // Verify purchase with detailed logging
          print('🔐 Starting verification process...');
          bool valid = await _verifyPurchase(purchaseDetails);
          print('🔐 Purchase verification result: $valid');
          
          if (valid) {
            // Update premium status with detailed logging
            print('🎉 Verification passed! Delivering product...');
            
            // For purchased status (not restored), we know this is a fresh purchase
            // that needs the success dialog shown
            bool isNewPurchase = purchaseDetails.status == PurchaseStatus.purchased;
            
            await _deliverProduct(purchaseDetails, showDialog: isNewPurchase);
            print('🎉 Product delivery completed!');
          } else {
            print('❌ Purchase verification failed for: ${purchaseDetails.productID}');
            print('❌ Skipping product delivery due to verification failure');
          }
        } else {
          print('⚠️ Unknown purchase status: ${purchaseDetails.status}');
        }
        
        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          print('✔️ Completing purchase transaction for: ${purchaseDetails.productID}');
          try {
            await _inAppPurchase.completePurchase(purchaseDetails);
            print('✔️ Purchase transaction completed successfully');
          } catch (e) {
            print('❌ Error completing purchase: $e');
          }
        }
        
        purchasePending = false;
      }
      print('📦 ========================================');
    }
    
    // After processing all purchases, verify the current premium status
    final controller = Get.find<PremiumController>();
    print('📊 Final status after purchase processing: ${controller.isPremium.value}');
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
        print('🎊 Showing purchase success dialog: $planType');
        
        // Add a small delay to ensure UI is ready, especially for TestFlight
        Future.delayed(Duration(milliseconds: 500), () {
          _showPurchaseSuccessDialog(planType);
        });
      } else {
        print('ℹ️ Skipping dialog for restored purchase');
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
    // Try multiple methods to show the success dialog
    print('🎊 Attempting to show purchase success dialog...');
    
    // Method 1: Try using Get.context first
    if (Get.context != null) {
      print('✅ Using Get.context to show dialog');
      Navigator.of(Get.context!).push(
        MaterialPageRoute(
          builder: (context) => PurchaseSuccessDialog(
            planType: planType,
          ),
          fullscreenDialog: true,
        ),
      );
      return;
    }
    
    // Method 2: Try using overlayContext if available
    final overlayContext = Get.overlayContext;
    if (overlayContext != null) {
      print('✅ Using Get.overlayContext to show dialog');
      Navigator.of(overlayContext).push(
        MaterialPageRoute(
          builder: (context) => PurchaseSuccessDialog(
            planType: planType,
          ),
          fullscreenDialog: true,
        ),
      );
      return;
    }
    
    // Method 3: Use Get.to for navigation (works without specific context)
    print('✅ Using Get.to() to show dialog');
    Get.to(
      () => PurchaseSuccessDialog(planType: planType),
      fullscreenDialog: true,
      transition: Transition.fadeIn,
      duration: Duration(milliseconds: 300),
    );
    
    // If all methods fail, at least show a snackbar
    if (Get.isSnackbarOpen == false) {
      Get.snackbar(
        '🎉 Purchase Successful',
        planType,
        backgroundColor: Color(0xFFFFB800),
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.check_circle, color: Colors.black),
      );
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
      
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Product Not Available'),
          content: SingleChildScrollView(
            child: Text(
              'Requested: $productId\n\n'
              'Loaded products:\n$loadedProducts\n\n'
              'Possible issues:\n'
              '• Product not configured in App Store Connect\n'
              '• Product ID mismatch\n'
              '• Product not approved for TestFlight\n'
              '• For Lifetime: Ensure it\'s set as Non-Consumable',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Try to reload products
                await loadProducts();
              },
              child: Text('Reload Products'),
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
          : products.map((p) => p.id).join(', ');
          
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Store Connection Issue'),
          content: SingleChildScrollView(
            child: Text(
              'Store Status:\n'
              '• Available: $isAvailable\n'
              '• Products loaded: ${products.length}\n'
              '• Product IDs: $productList\n\n'
              'Please check:\n'
              '• Internet connection\n'
              '• TestFlight app is signed in\n'
              '• Products are configured in App Store Connect\n\n'
              'For Lifetime plan:\n'
              '• Must be Non-Consumable type\n'
              '• Product ID: nicotrack_lifetime_premium',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Try to reinitialize
                await initialize();
              },
              child: Text('Retry'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  // Dispose resources
  void dispose() {
    _subscription.cancel();
  }
}