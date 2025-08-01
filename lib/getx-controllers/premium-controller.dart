import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/purchase-service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/color-constants.dart';
import '../config/app-mode.dart';
import 'package:nicotrack/services/firebase-service.dart';

class PremiumController extends GetxController {
  // Premium status
  RxBool isPremium = false.obs;
  
  // Get effective premium status (checks app mode)
  bool get effectivePremiumStatus {
    // If in dev mode, always return true (full premium)
    if (AppModeConfig.shouldForcePremium) {
      return true;
    }
    // Otherwise, return actual premium status
    return isPremium.value;
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
        return "2 days";
      case 1:
        return "1 week";
      case 2:
        return "2 weeks";
      default:
        return "a few days";
    }
  }
}