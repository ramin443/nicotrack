import 'package:get/get.dart';

class PremiumController extends GetxController {
  // Premium status
  RxBool isPremium = false.obs;
  
  // Selected subscription plan
  RxInt selectedPlan = 1.obs; // 0: Monthly, 1: Yearly, 2: Lifetime
  
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
      "price": "\$79.99", 
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

  void selectPlan(int planIndex) {
    selectedPlan.value = planIndex;
  }

  void subscribeToPremium(int planIndex) {
    // TODO: Implement actual subscription logic with payment processing
    print("Starting subscription for plan: ${subscriptionPlans[planIndex]?["title"]}");
    
    // For now, just show success message
    Get.snackbar(
      "Success!",
      "Premium subscription activated",
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.onPrimaryColor,
    );
    
    // Set premium status to true
    isPremium.value = true;
  }

  void restorePurchases() {
    // TODO: Implement restore purchases logic
    print("Restoring purchases...");
  }

  // Check if user has access to premium features
  bool hasFeatureAccess(String feature) {
    return isPremium.value;
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