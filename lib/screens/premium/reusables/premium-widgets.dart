import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/font-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';
import 'package:nicotrack/screens/premium/premium-plan-details-sheet.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/premium-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

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
                    context.l10n.premium_get_pro,
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1,
                      fontFamily: recoletaBold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  SizedBox(
                    width: 140.w,
                    child:
                    TextAutoSize(
                    context.l10n.premium_access_all_features,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.05,
                      fontFamily: circularBook,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),)
                ],
              )
            ],
          ),
          SizedBox(
            width: 110.w,
          child:
          TextAutoSize(
            context.l10n.premium_save_50 + ' ',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.1,
              fontFamily: circularMedium,
              color: Colors.white,
            ),
          ),)
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

Widget contentLockBox(BuildContext context) {
  return Container(
    constraints: BoxConstraints(
      maxWidth: 260.w,  // Maximum width it can be
      maxHeight: 65.w, // Maximum height it can be
      // minWidth: 0, // Optional: if you want a minimum size
      // minHeight: 0,
    ),
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(30.r),
    ),
    child: Text( // Removed inner Center, text alignment handles it.
      context.l10n.premium_get_pro_to_unlock + ' ',
      textAlign: TextAlign.center, // Text itself will center
      style: TextStyle(
        fontSize: 16.sp,
        height: 1.2,
        fontFamily: circularMedium,
        color: Colors.white,
      ),
    ),
  );
}

Widget calendarLock(BuildContext context) {
  // Assuming nicotrackBlack1, lockImg, recoletaSemiBold, w, r, sp are defined
  // final String circularMedium = 'YourCircularMediumFont'; // Placeholder
  // final String recoletaSemiBold = 'YourRecoletaSemiBoldFont'; // Placeholder
  // final Color nicotrackBlack1 = Colors.grey[900]!; // Placeholder

  return Container( // Outer container, can be removed if not needed for alignment/background
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 124.w,
          height: 124.w,
          decoration: BoxDecoration(
            color: nicotrackBlack1,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Image.asset(
              lockImg, // Ensure lockImg is correctly defined in your assets
              width: 52.w,
            ),
          ),
        ),
        SizedBox(
          height: 7.w,
        ),
        // This SizedBox can still define the MAX available width for the centered box,
        // or you can remove it if the Column's crossAxisAlignment handles centering.
        // For explicit max width and centering of the potentially smaller box:
        SizedBox(
          width: 180.w, // Maximum width for the text box area
          child: Center( // Center the potentially smaller text box within this 180.w space
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 180.w,  // Text box won't exceed this width
                maxHeight: 48.w,   // Text box won't exceed this height (optional, if text can wrap)
                // If text is short, height will be determined by text + padding
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.w), // Adjusted padding
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextAutoSize(
                context.l10n.premium_get_pro_sparkle + ' ',
                textAlign: TextAlign.center, // Center text within its own bounds
                minFontSize: 10, // Optional: prevent text from becoming too small
                maxLines: 2,     // Optional: allow text to wrap to two lines if too long
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: recoletaSemiBold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget premiumStatusBox(BuildContext context) {
  final premiumController = Get.find<PremiumController>();

  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const PremiumPlanDetailsSheet(),
      );
    },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 4.w, right: 13.w, top: 10.w, bottom: 10.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 6.w,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  width: 65.w,
                  height: 65.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: TextAutoSize(
                      premiumController.getPlanStatusEmoji(),
                      style: TextStyle(
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
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
                    context.l10n.premium_pro_active,
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1,
                      fontFamily: recoletaBold,
                      color: Colors.white,
                    ),
                  ),
                  TextAutoSize(
                      premiumController.getPlanDisplayText(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularBook,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                ],
              )
            ],
          ),
          Row(
            children: [
              TextAutoSize(
                context.l10n.premium_active,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: circularMedium,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.7),
                size: 20.sp,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}