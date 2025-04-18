import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class CrushCravings extends StatelessWidget {
  const CrushCravings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAutoSize(
          "Crush your cravings",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.2,
              fontSize: 28.sp,
              fontFamily: circularMedium,
              color: nicotrackBlack1),
        ),
        SizedBox(
          height: 18.h,
        ),
        SvgPicture.asset(
          illustration2,
          width: 312.w,
        ),
        SizedBox(
          height: 18.h,
        ),
        SizedBox(
          width: 315.w,
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: circularBook,
                      color: nicotrackBlack1),
                  children: [
                    TextSpan(
                      text: "We know cravings hit hard. ",
                    ),
                    TextSpan(
                      text: "Nicotrack",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: circularBold,
                          color: nicotrackBlack1),
                    ),
                    TextSpan(text: " helps manage them with tools like distraction mode and craving logs.")
                  ])),
        ),
      ],
    );
  }
}
