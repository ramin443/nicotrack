import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

class PrivacyPolicyComponents {
  static Widget buildPolicySection(String title, List<dynamic> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.2,
          ),
        ),
        SizedBox(height: 16.w),
        ...content.map((item) {
          if (item is Widget) {
            return Padding(
              padding: EdgeInsets.only(bottom: 0.h),
              child: item,
            );
          } else if (item is String) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.w, left: 16.w),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularBook,
                  color: nicotrackBlack1,
                  height: 1.4,
                ),
              ),
            );
          }
          return item;
        }).toList(),
        SizedBox(height: 20.h),
      ],
    );
  }

  static Widget buildDataPoint(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 6.h, right: 12.w),
            decoration: BoxDecoration(
              color: Color(0xFF3380F8),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1.withOpacity(0.7),
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

  static Widget buildInfoCard(String title, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularBold,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildPermissionItem(String permission, String reason) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            permission.split(' ')[0],
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission.substring(permission.indexOf(' ') + 1),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1,
                  ),
                ),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1.withOpacity(0.7),
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