import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';

Widget premiumBox(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PremiumPaywallScreen(),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 4.w, right: 13.w, top: 7.w, bottom: 8.w),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  nicopro,
                  width: 65.w,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6.w,
                  ),
                  TextAutoSize(
                    'Get Pro',
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1,
                      fontFamily: recoletaBold,
                      color: Colors.white,
                    ),
                  ),
                  TextAutoSize(
                    'Access all features',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: circularBook,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              )
            ],
          ),
          TextAutoSize(
            '🎉 Save 50% ',
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: circularMedium,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget smallLockBox() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.5.w),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(14.r),
    ),
    child: Center(
      child: Image.asset(
        lockImg,
        width: 16.w,
      ),
    ),
  );
}

Widget contentLockBox() {
  return Container(
    width: 200.w,
    height: 48.w,
    // padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 15.w),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Center(
      child: TextAutoSize(
        '🔒 Get Pro to unlock ',
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: circularMedium,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget calendarLock() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 124.w,
          height: 124.w,
          decoration:BoxDecoration(
            color: nicotrackBlack1,
            borderRadius: BorderRadius.circular(30.r)
          ),
          child: Center(
            child: Image.asset(
              lockImg,
              width: 52.w,
            ),
          )
        ),

        SizedBox(
          height: 7.w,
        ),
        Container(
          width: 120.w,
          height: 48.w,
          // padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 15.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: TextAutoSize(
              '✨ Get Pro ',
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: recoletaSemiBold,
                color: Colors.white,
              ),
            ),
          ),
        )

      ],
    ),
  );
}