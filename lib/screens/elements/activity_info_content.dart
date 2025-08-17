import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../extensions/app_localizations_extension.dart';

/// Content widget for activity info bottom sheet
class ActivityInfoContent extends StatelessWidget {
  const ActivityInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title with icon
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                nicotrackGreen.withOpacity(0.1),
                nicotrackLightGreen.withOpacity(0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "🎮",
              style: TextStyle(fontSize: 40.sp),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          context.l10n.activity_info_title,
          style: TextStyle(
            fontSize: 24.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          context.l10n.activity_info_subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: circularMedium,
            color: nicotrackBlack1.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 30.h),
        
        // Main description
        _buildDescriptionCard(context),
        SizedBox(height: 16.h),
        
        // When to use section
        _buildWhenToUseCard(context),
        SizedBox(height: 16.h),
        
        // Disclaimer section
        _buildDisclaimerCard(context),
        SizedBox(height: 16.h),
        
        // Remember section
        _buildRememberCard(context),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            nicotrackBlack1,
            nicotrackBlack1.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    FeatherIcons.activity,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                context.l10n.activity_info_how_it_works,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularBold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            context.l10n.activity_info_description,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhenToUseCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: nicotrackLightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: nicotrackGreen.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: nicotrackGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    FeatherIcons.clock,
                    size: 18.sp,
                    color: nicotrackGreen,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                context.l10n.activity_info_when_to_use,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            context.l10n.activity_info_when_description,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
              color: nicotrackOrange.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                "⚠️",
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
                  context.l10n.activity_info_disclaimer_title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.l10n.activity_info_disclaimer_text,
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

  Widget _buildRememberCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            nicotrackPurple.withOpacity(0.1),
            nicotracklightBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: nicotrackPurple.withOpacity(0.2),
          width: 1.5,
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
              color: nicotrackPurple.withOpacity(0.15),
            ),
            child: Center(
              child: Text(
                "💪",
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
                  context.l10n.activity_info_remember,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.l10n.activity_info_remember_text,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: circularBook,
                    height: 1.3,
                    color: nicotrackBlack1.withOpacity(0.8),
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