import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class PersonalizedQuitPlan extends StatelessWidget {
  const PersonalizedQuitPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 293.w,
          child: TextAutoSize(
            "Your personalized Quit plan",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2,
                fontSize: 28.sp,
                fontFamily: circularMedium,
                color: nicotrackBlack1),
          ),
        ),
        SizedBox(height: 30.h,),
        Image.asset(
          illustration3,
          width: 312.w,
        ),
        SizedBox(height: 36.h,),
        SizedBox(
          width: 325.w,
          child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBook,
                      color: nicotrackBlack1),
                  children: [
                    TextSpan(
                      text: "⚡ Choose Your ",
                    ),
                    TextSpan(
                      text: "Quit Method – ",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1),
                    ),
                    TextSpan(text: "Instant quit or step-down approach\n\n🔗 Sync with Apple Health – Track "),
                    TextSpan(text: "improvements",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1),),
                    TextSpan(text: " in breathing, heart rate, and more "),
                  ])),
        ),
      ],
    );
  }
}
