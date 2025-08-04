import 'dart:async';
import 'dart:io';
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
      
      // Check for previous purchases
      await restorePurchases();
      
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
            _deliverProduct(purchaseDetails);
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
  void _deliverProduct(PurchaseDetails purchaseDetails) {
    final controller = Get.find<PremiumController>();
    
    print('🎉 Delivering premium product: ${purchaseDetails.productID}');
    
    // Set premium status
    controller.isPremium.value = true;
    
    // Store purchase info (you might want to save this to local storage)
    _savePurchaseInfo(purchaseDetails);
    
    // Force UI refresh
    controller.refreshPremiumStatus();
    
    print('✅ Success! Premium features unlocked! Current status: ${controller.isPremium.value}');
  }

  // Save purchase information
  void _savePurchaseInfo(PurchaseDetails purchaseDetails) async {
    // Save purchase info using persistence service
    await PremiumPersistenceService.savePremiumStatus(
      isPremium: true,
      purchaseId: purchaseDetails.purchaseID,
      productId: purchaseDetails.productID,
      purchaseDate: DateTime.now(),
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
    // Check if we need to verify subscription status
    if (PremiumPersistenceService.needsVerification()) {
      // Restore purchases to verify subscription is still active
      await restorePurchases();
    }
    
    final controller = Get.find<PremiumController>();
    return controller.isPremium.value;
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