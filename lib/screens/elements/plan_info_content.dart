import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../extensions/app_localizations_extension.dart';

/// Content widget for plan info bottom sheet
class PlanInfoContent extends StatelessWidget {
  const PlanInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        // Header Section
        Container(
          width: 86.w,
          height: 86.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: nicotrackLightGreen.withOpacity(0.2),
          ),
          child: Center(
            child: Text(
              "📋",
              style: TextStyle(fontSize: 48.sp),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          context.l10n.your_quit_journey,
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.1,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: nicotrackGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            context.l10n.personalized_plan,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: circularMedium,
              color: nicotrackGreen,
              height: 1.1,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        
        // Main Content
        _buildMainContentCard(context),
        SizedBox(height: 20.h),
        
        // Disclaimer Section
        _buildDisclaimerCard(context),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildMainContentCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: circularBook,
                height: 1.4,
                color: nicotrackBlack1,
              ),
              children: [
                TextSpan(text: context.l10n.plan_description),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureColumn(
                context,
                emoji: "🎯",
                label: context.l10n.track_progress,
                color: nicotrackOrange,
              ),
              _buildFeatureColumn(
                context,
                emoji: "🏆",
                label: context.l10n.earn_badges,
                color: nicotracklightBlue,
              ),
              _buildFeatureColumn(
                context,
                emoji: "💪",
                label: context.l10n.stay_strong,
                color: nicotrackPurple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureColumn(
    BuildContext context, {
    required String emoji,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: 24.sp)),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: circularMedium,
            color: nicotrackBlack1,
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFE0E0E0),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: nicotrackLightGreen.withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                "💡",
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.important_note,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.l10n.timeline_disclaimer,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    height: 1.3,
                    color: nicotrackBlack1.withOpacity(0.7),
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