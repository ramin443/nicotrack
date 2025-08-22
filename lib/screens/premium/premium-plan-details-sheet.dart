import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../getx-controllers/premium-controller.dart';
import '../../services/premium-persistence-service.dart';
import '../../extensions/app_localizations_extension.dart';

class PremiumPlanDetailsSheet extends StatelessWidget {
  const PremiumPlanDetailsSheet({Key? key}) : super(key: key);

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
    final DateTime? parsedPurchaseDate = purchaseDate != null ? DateTime.tryParse(purchaseDate) : null;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          
          // Content
          Padding(
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
                
                if (parsedPurchaseDate != null)
                  SizedBox(height: 16.h),
                
                if (productId != null)
                  _buildInfoCard(
                    context,
                    icon: '🆔',
                    title: 'Product ID',
                    value: _formatProductId(productId),
                  ),
                
                if (productId != null)
                  SizedBox(height: 16.h),
                
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
                      _buildFeatureItem('📊 Advanced Analytics & Progress Tracking'),
                      _buildFeatureItem('🎯 Unlimited Goals & Milestones'),
                      _buildFeatureItem('🏆 Complete Badge Collection'),
                      _buildFeatureItem('⚡ Smart Quick Actions'),
                      _buildFeatureItem('🔔 Advanced Notifications'),
                      _buildFeatureItem('📚 Expert Guidance & Tips'),
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
              ],
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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