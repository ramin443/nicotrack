import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../getx-controllers/premium-controller.dart';
import '../../services/premium-persistence-service.dart';
import '../../extensions/app_localizations_extension.dart';

class PremiumPlanDetailsSheet extends StatefulWidget {
  const PremiumPlanDetailsSheet({Key? key}) : super(key: key);

  @override
  State<PremiumPlanDetailsSheet> createState() =>
      _PremiumPlanDetailsSheetState();
}

class _PremiumPlanDetailsSheetState extends State<PremiumPlanDetailsSheet> {
  void _showCancelSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Cancel Subscription',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: circularBold,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to cancel your subscription?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '⚠️ TestFlight Note: This will reset your premium status locally for testing purposes. In production, users would manage subscriptions through App Store settings.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    color: const Color(0xFF991B1B),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Keep Subscription',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Clear premium status for testing
                _cancelSubscriptionForTesting();
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Close the bottom sheet
              },
              child: Text(
                'Cancel Subscription',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: const Color(0xFFF87171),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelSubscriptionForTesting() {
    final premiumController = Get.find<PremiumController>();

    // Clear premium status
    PremiumPersistenceService.clearPremiumStatus();
    premiumController.isPremium.value = false;
    premiumController.update();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscription cancelled (TestFlight testing mode)'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );

    // Force refresh the app state
    if (Get.isRegistered<PremiumController>()) {
      Get.find<PremiumController>().update();
    }
  }

  @override
  Widget build(BuildContext context) {
    final premiumController = Get.find<PremiumController>();
    final premiumInfo = PremiumPersistenceService.getPremiumInfo();

    // Extract premium information
    final String planType = premiumController.getCurrentPlanType();
    final String planDisplayText = premiumController.getPlanDisplayText();
    final String planEmoji = premiumController.getPlanStatusEmoji();
    final String? productId = premiumInfo['productId'];
    final String? purchaseDate = premiumInfo['purchaseDate'];
    final DateTime? parsedPurchaseDate =
        purchaseDate != null ? DateTime.tryParse(purchaseDate) : null;

    // Set the height to 85% of screen height
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85, // 85% of screen height
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Row(
                    children: [
                      // Plan icon
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFB800),
                              const Color(0xFFFF8F00),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB800).withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            planEmoji,
                            style: TextStyle(fontSize: 28.sp),
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Plan details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.premium_pro_active,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontFamily: circularBold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              planDisplayText,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularMedium,
                                color: const Color(0xFFFFB800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Plan information cards
                  _buildInfoCard(
                    context,
                    icon: '📋',
                    title: 'Plan Type',
                    value: planType.isNotEmpty ? planType : 'Premium Active',
                  ),

                  SizedBox(height: 16.h),

                  if (parsedPurchaseDate != null)
                    _buildInfoCard(
                      context,
                      icon: '📅',
                      title: 'Activated On',
                      value: _formatDate(parsedPurchaseDate),
                    ),

                  if (parsedPurchaseDate != null) SizedBox(height: 16.h),

                  if (productId != null)
                    _buildInfoCard(
                      context,
                      icon: '🆔',
                      title: 'Product ID',
                      value: _formatProductId(productId),
                    ),

                  if (productId != null) SizedBox(height: 16.h),

                  _buildInfoCard(
                    context,
                    icon: '✨',
                    title: 'Status',
                    value: 'Active & Verified',
                    valueColor: const Color(0xFF00C853),
                  ),

                  SizedBox(height: 32.h),

                  // Features section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Features Unlocked',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildFeatureItem(
                            '📊 Advanced Analytics & Progress Tracking'),
                        _buildFeatureItem('🎯 Unlimited Goals & Milestones'),
                        _buildFeatureItem('🏆 Complete Badge Collection'),
                        _buildFeatureItem('⚡ Smart Quick Actions'),
                        _buildFeatureItem('🔔 Advanced Notifications'),
                        _buildFeatureItem('📚 Expert Guidance & Tips'),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Subscription Management Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subscription Management',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Restore Purchase Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.of(context).pop();
                            premiumController.restorePurchases(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF3B82F6).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restore,
                                  color: const Color(0xFF60A5FA),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Restore Purchase',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularMedium,
                                    color: const Color(0xFF60A5FA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Cancel Subscription Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _showCancelSubscriptionDialog(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F1D1D).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFEF4444).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: const Color(0xFFF87171),
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Cancel Subscription',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularMedium,
                                    color: const Color(0xFFF87171),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Info text
                        Text(
                          'Note: For TestFlight testing, use "Cancel Subscription" to reset premium status locally.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: circularBook,
                            color: Colors.white.withOpacity(0.5),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Close button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            const Color(0xFFF5F5F5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: circularBold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h), // Add some padding at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularMedium,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: circularBold,
                    color: valueColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularMedium,
                color: Colors.white.withOpacity(0.9),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatProductId(String productId) {
    // Make product ID more readable
    return productId
        .replaceAll('nicotrack_', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
