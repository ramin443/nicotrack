import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/services/mood-usage-service.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class MoodTrialInfoWidget extends StatelessWidget {
  const MoodTrialInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final remainingDays = MoodUsageService.getRemainingDays();
    
    // Don't show for premium users or if already exceeded limit
    if (remainingDays == -1 || remainingDays == 0) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFFFFF4E6), // Light orange background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Color(0xFFFFB84D), // Orange border
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFFFF8C00),
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextAutoSize(
                  'Free Trial',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: Color(0xFFFF8C00),
                  ),
                ),
                SizedBox(height: 2.h),
                TextAutoSize(
                  remainingDays == 4 
                    ? 'You can track your mood for 4 days to try this feature'
                    : 'You have $remainingDays day${remainingDays == 1 ? '' : 's'} remaining in your free trial',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    color: Color(0xFF666666),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}