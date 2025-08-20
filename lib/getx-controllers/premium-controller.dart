import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../services/purchase-service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app-mode.dart';
import 'package:nicotrack/services/firebase-service.dart';
import 'package:nicotrack/services/premium-persistence-service.dart';

class PremiumController extends GetxController {
  // Premium status
  RxBool isPremium = false.obs;
  
  // Get effective premium status (checks app mode)
  bool get effectivePremiumStatus {
    // If in dev mode, always return true (full premium)
    if (AppModeConfig.shouldForcePremium) {
      print('⚠️ App in dev mode - forcing premium features enabled');
      return true;
    }
    // Otherwise, return actual premium status
    print('✅ Using actual premium status: ${isPremium.value}');
    return isPremium.value;
  }

  
  // Method to manually refresh premium status
  void refreshPremiumStatus() {
    print('🔄 Refreshing premium status...');
    update();
  }
  
  // Method to verify subscription status with app store
  Future<void> verifySubscriptionStatus() async {
    print('🔍 Manually verifying subscription status...');
    try {
      final purchaseService = PurchaseService();
      await purchaseService.checkSubscriptionStatus();
      refreshPremiumStatus();
    } catch (e) {
      print('❌ Error during manual subscription verification: $e');
    }
  }
  
  // Method to debug current premium status
  void debugPremiumStatus() {
    print('🐛 DEBUG Premium Status:');
    print('   - Raw isPremium value: ${isPremium.value}');
    print('   - App mode: ${AppModeConfig.appMode}');
    print('   - Should force premium: ${AppModeConfig.shouldForcePremium}');
    print('   - Effective premium status: $effectivePremiumStatus');
  }
  
  // Get current subscription plan type
  String getCurrentPlanType() {
    if (!effectivePremiumStatus) return '';
    
    // If in dev mode, return a default plan for testing
    if (AppModeConfig.shouldForcePremium) {
      return 'Premium Active';
    }
    
    // Get premium info from persistence service
    try {
      final premiumInfo = PremiumPersistenceService.getPremiumInfo();
      final productId = premiumInfo['productId'] as String?;
      
      if (productId == null) return 'Premium Active';
      
      // Map product IDs to plan names
      switch (productId) {
        case 'nicotrack_monthly_plan':
          return 'Monthly Plan';
        case 'nicotrack_yearly_plan':
          return 'Annual Plan';
        case 'nicotrack_lifetime_premium':
          return 'Lifetime Plan';
        default:
          return 'Premium Active';
      }
    } catch (e) {
      print('Error getting current plan type: $e');
      return 'Premium Active';
    }
  }
  
  // Get plan display text
  String getPlanDisplayText() {
    final planType = getCurrentPlanType();
    switch (planType) {
      case 'Monthly Plan':
        return 'Monthly Subscription';
      case 'Annual Plan':
        return 'Annual Subscription';
      case 'Lifetime Plan':
        return 'Lifetime Access';
      default:
        return 'Premium Active';
    }
  }
  
  // Get plan status emoji
  String getPlanStatusEmoji() {
    final planType = getCurrentPlanType();
    switch (planType) {
      case 'Monthly Plan':
        return '📅';
      case 'Annual Plan':
        return '⭐';
      case 'Lifetime Plan':
        return '👑';
      default:
        return '✨';
    }
  }
  
  // Selected subscription plan
  RxInt selectedPlan = 1.obs; // 0: Monthly, 1: Yearly, 2: Lifetime
  
  // Log plan selection
  void selectPlan(int planIndex) {
    selectedPlan.value = planIndex;
    final planData = subscriptionPlans[planIndex];
    if (planData != null) {
      FirebaseService().logPremiumPlanSelected(
        planIndex: planIndex,
        planType: planData['title'],
        planPrice: planData['price'],
      );
    }
  }
  
  // Subscription prices
  final Map<int, Map<String, dynamic>> subscriptionPlans = {
    0: {
      "title": "Monthly",
      "price": "\$6.99",
      "period": "per month",
      "savings": null,
      "isPopular": false,
    },
    1: {
      "title": "Yearly", 
      "price": "\$39.99",
      "period": "per year",
      "savings": "Save 52%",
      "isPopular": true,
    },
    2: {
      "title": "Lifetime",
      "price": "\$99.99", 
      "period": "one-time",
      "savings": "Best Value",
      "isPopular": false,
    },
  };

  // Premium features list
  final List<Map<String, String>> premiumFeatures = [
    {
      "icon": "📊",
      "title": "Advanced Analytics",
      "description": "5-tab progress system with detailed health insights"
    },
    {
      "icon": "🎯", 
      "title": "Unlimited Goals",
      "description": "Set and track multiple financial and health goals"
    },
    {
      "icon": "🏆",
      "title": "Complete Badge Collection", 
      "description": "19+ unique achievements and milestone celebrations"
    },
    {
      "icon": "⚡",
      "title": "Smart Quick Actions",
      "description": "4+ personalized quit-smoking actions with tracking"
    },
    {
      "icon": "🔔",
      "title": "Advanced Notifications",
      "description": "Custom schedules and weekly summary reports"
    },
    {
      "icon": "📚",
      "title": "Expert Guidance",
      "description": "Complete quit tips library and crisis support"
    },
  ];


  void subscribeToPremium(int planIndex, BuildContext context) async {
    // Use PurchaseService to handle the actual purchase
    final purchaseService = PurchaseService();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.w,
            backgroundColor: Colors.black,
          ),
        );
      },
    );
    
    // Log purchase attempt
    final planData = subscriptionPlans[planIndex];
    if (planData != null) {
      FirebaseService().logPremiumPurchaseAttempted(
        planType: planData['title'],
        planIndex: planIndex,
      );
    }
    
    try {
      bool success = await purchaseService.purchaseProduct(planIndex);
      HapticFeedback.lightImpact();
      Navigator.pop(context); // Close loading dialog
      
      if (!success) {
        print("Purchase failed for plan: ${subscriptionPlans[planIndex]?["title"]}");
        FirebaseService().logEvent(
          name: 'premium_purchase_failed',
          parameters: {
            'plan_type': planData?['title'] ?? 'unknown',
            'plan_index': planIndex,
            'error_type': 'purchase_failed',
          },
        );
      } else {
        FirebaseService().logEvent(
          name: 'premium_purchase_completed',
          parameters: {
            'plan_type': planData?['title'] ?? 'unknown',
            'plan_index': planIndex,
          },
        );
      }
      // The purchase service will handle success/error messages and update isPremium
    } catch (e) {
      HapticFeedback.lightImpact();
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Purchase failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void restorePurchases(BuildContext context) async {
    // Use PurchaseService to restore purchases
    final purchaseService = PurchaseService();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    
    FirebaseService().logEvent(
      name: 'premium_restore_attempted',
      parameters: {
        'page': 'premium_screen',
      },
    );
    
    try {
      await purchaseService.restorePurchases();
      HapticFeedback.lightImpact();
      Navigator.pop(context); // Close loading dialog
      
      // Show message based on whether purchases were restored
      if (isPremium.value) {
        FirebaseService().logEvent(
          name: 'premium_restore_successful',
          parameters: {
            'restored_premium': 'true',
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Purchases restored successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No previous purchases to restore"),
            backgroundColor: Colors.grey,
          ),
        );
      }
    } catch (e) {
      HapticFeedback.lightImpact();
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to restore purchases. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Check if user has access to premium features
  bool hasFeatureAccess(String feature) {
    return effectivePremiumStatus;
  }

  // Get subscription button text based on selected plan
  String getSubscribeButtonText() {
    switch (selectedPlan.value) {
      case 0:
        return "Start Monthly Subscription";
      case 1:
        return "Start Yearly Subscription"; 
      case 2:
        return "Get Lifetime Access";
      default:
        return "Subscribe Now";
    }
  }

  // Get comparison text for value proposition
  String getComparisonText() {
    switch (selectedPlan.value) {
      case 0:
        return "4 days";
      case 1:
        return "1 week";
      case 2:
        return "2 weeks";
      default:
        return "a few days";
    }
  }
}