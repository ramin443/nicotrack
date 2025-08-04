import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

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
            context.l10n.quit_plan_title,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAutoSize(
                context.l10n.quit_plan_feature_1,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1),
              ),
              SizedBox(height: 12.h),
              TextAutoSize(
                context.l10n.quit_plan_feature_2,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBook,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
