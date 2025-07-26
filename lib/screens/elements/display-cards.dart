import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';

Widget mainCard({
  required String emoji,
  required int value,
  required String label,
  required bool isCost,
  Color? backgroundColor,
}) {
  return Container(
    height: 106.w,
    width: 186.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(homeMainBG), fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          emoji,
          width: 48.w,
        ),
        // SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedFlipCounter(
                prefix: isCost ? Get.find<AppPreferencesController>().currencySymbol : '',
                // 👈 add dollar sign here (escaped with backslash)
                wholeDigits: 2,
                // 👈 forces two digits to be shown & flip
                duration: Duration(seconds: 2),
                value: value,
                fractionDigits: 0,
                // No decimal
                textStyle: TextStyle(
                    fontSize: 33.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1)),
            SizedBox(
              width: 90.w,
              child: TextAutoSize(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 12.5.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1),
              ),
            )

          ],
        ),
      ],
    ),
  );
}

Widget statCard({
  required String emoji,
  required int value,
  required String label,
  required bool isCost,
  Color? backgroundColor,
}) {
  return Container(
    height: 106.w,
    width: 186.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F4F4),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          emoji,
          width: 48.w,
        ),
        // SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedFlipCounter(
                prefix: isCost ? Get.find<AppPreferencesController>().currencySymbol : '',
                // 👈 add dollar sign here (escaped with backslash)
                wholeDigits: 2,
                // 👈 forces two digits to be shown & flip
                duration: Duration(seconds: 2),
                value: value,
                fractionDigits: 0,
                // No decimal
                textStyle: TextStyle(
                    fontSize: 33.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1)),
            SizedBox(
              width: 90.w,
              child: TextAutoSize(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                  height: 1.1,
                  fontSize: 12.5.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1),
            )),
          ],
        ),
      ],
    ),
  );
}

Widget statCard2({
  required String emoji,
  required double value,
  required String label,
  required bool isCost,
  Color? backgroundColor,
}) {
  return Container(
    height: 106.w,
    width: 186.w,
    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 12.h),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xfff0f0f0), width: 1.w)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          emoji,
          width: 51.w,
        ),
        // SizedBox(width: 12.w),

        Expanded(
            flex: 2,
            child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedFlipCounter(
                prefix: isCost ? Get.find<AppPreferencesController>().currencySymbol : '',
                // 👈 add dollar sign here (escaped with backslash)
                wholeDigits: getWholeDigits(value),
                fractionDigits: getFractionDigits(value),
                // 👈 forces two digits to be shown & flip
                duration: Duration(milliseconds: 1250),
                value: value,
                // No decimal
                textStyle: TextStyle(
                    fontSize: 33.sp,
                    fontFamily: circularBold,
                    letterSpacing: 0.04,
                    color: nicotrackBlack1)),
            TextAutoSize(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                  height: 1.1,
                  fontSize: 12.5.sp,
                  fontFamily: circularMedium,
                  color: nicotrackBlack1),
            ),
          ],
        ))
      ],
    ),
  );
}