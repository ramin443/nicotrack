import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({super.key});

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen> {
  int selectedPlan = 1; // 0: Monthly, 1: Yearly, 2: Lifetime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            _buildHeader(),
            
            // Main content - no scrolling, fit everything on screen
            Expanded(
              child: Column(
                children: [
                  _buildPremiumTitle(),
                  SizedBox(height: 12.h),
                  _buildFeatures(),
                  SizedBox(height: 16.h),
                  _buildSubscriptionPlans(),
                ],
              ),
            ),
            
            // Bottom CTA
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 40.w), // Spacer
          TextAutoSize(
            "💜 Upgrade to Premium",
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.close,
                size: 20.sp,
                color: nicotrackBlack1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          TextAutoSize(
            "🚀 Unlock Your Complete Quit Journey",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: circularBold,
              color: nicotrackPurple,
            ),
          ),
          SizedBox(height: 4.h),
          TextAutoSize(
            "💜 Get advanced features & personalized insights",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      {"icon": "📊", "title": "Advanced\nAnalytics"},
      {"icon": "🎯", "title": "Unlimited\nGoals"},
      {"icon": "🏆", "title": "Complete\nBadges"},
      {"icon": "⚡", "title": "Smart\nActions"},
      {"icon": "🔔", "title": "Custom\nNotifications"},
      {"icon": "📚", "title": "Expert\nGuidance"},
    ];
    
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            TextAutoSize(
              "💜 Premium Features",
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularBold,
                color: nicotrackBlack1,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: nicotrackPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: nicotrackPurple.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextAutoSize(
                          features[index]["icon"]!,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        SizedBox(height: 8.h),
                        TextAutoSize(
                          features[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: circularBold,
                            color: nicotrackBlack1,
                            height: 1.2,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSubscriptionPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextAutoSize(
            "💳 Choose Your Plan",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              _buildHorizontalPlan(0, "📅 Monthly", "\$6.99", "per month", null, false),
              SizedBox(width: 12.w),
              _buildHorizontalPlan(1, "🎯 Yearly", "\$39.99", "per year", "Save 52%", true),
              SizedBox(width: 12.w),
              _buildHorizontalPlan(2, "💜 Lifetime", "\$79.99", "one-time", "Best Value", false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalPlan(int index, String title, String price, String period, String? savings, bool isPopular) {
    final isSelected = selectedPlan == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = index;
        });
      },
      child: Container(
        width: 120.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? nicotrackPurple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? nicotrackPurple : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.only(top: isPopular ? 12.h : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextAutoSize(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextAutoSize(
                    price,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: circularBold,
                      color: nicotrackPurple,
                    ),
                  ),
                  TextAutoSize(
                    period,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: circularBook,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (savings != null) ...[
                    SizedBox(height: 2.h),
                    TextAutoSize(
                      savings,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: circularMedium,
                        color: nicotrackPurple,
                      ),
                    ),
                  ],
                  // Selected indicator
                  if (isSelected) ...[
                    SizedBox(height: 4.h),
                    Container(
                      width: 16.w,
                      height: 16.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: nicotrackPurple,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Popular badge positioned outside
            if (isPopular)
              Positioned(
                top: -8.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: nicotrackPurple,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextAutoSize(
                      "POPULAR",
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: circularBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomCTA() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subscribe button
          GestureDetector(
            onTap: _handleSubscribe,
            child: Container(
              width: double.infinity,
              height: 45.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    nicotrackPurple,
                    nicotrackPurple.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Center(
                child: TextAutoSize(
                  _getSubscribeButtonText(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: circularBold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Compact info
          TextAutoSize(
            "📱 Cancel anytime • 💜 Less than cigarettes in ${_getComparisonText()}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: circularBook,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getSubscribeButtonText() {
    switch (selectedPlan) {
      case 0:
        return "🚀 Start Monthly Subscription";
      case 1:
        return "🎯 Start Yearly Subscription";
      case 2:
        return "💜 Get Lifetime Access";
      default:
        return "✨ Subscribe Now";
    }
  }

  String _getComparisonText() {
    switch (selectedPlan) {
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

  void _handleSubscribe() {
    // TODO: Implement subscription logic
    String planType = ["Monthly", "Yearly", "Lifetime"][selectedPlan];
    print("User selected: $planType plan");
    
    // Show success message for now
    Get.snackbar(
      "Coming Soon",
      "Subscription for $planType plan will be implemented",
      backgroundColor: Color(0xffFF4800),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}