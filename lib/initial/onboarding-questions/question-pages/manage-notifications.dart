import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class ManageNotifications extends StatelessWidget {
  const ManageNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30.w,
        ),
        SizedBox(
          width: 300.w,
          child: TextAutoSize(
            '🔔 Stay on track with timely reminders',
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.1,
                fontSize: 26.sp,
                fontFamily: circularMedium,
                color: nicotrackBlack1),
          ),
        ),
        SizedBox(
          height: 30.w,
        ),
        Image.asset(
          illustration3,
          width: 312.w,
        ),
        SizedBox(
          height: 36.w,
        ),
        SizedBox(
          width: 325.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.2,
                          fontFamily: circularBook,
                          color: nicotrackBlack1),
                      children: [
                        TextSpan(
                          text: '⏰ Morning check-ins ',
                          style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.2,
                              fontFamily: circularBold,
                              color: nicotrackBlack1),
                        ),
                        TextSpan(
                          text: '- Track your progress and mood,\n\n'
                        ),
                        TextSpan(
                          text: '💪 Motivation boosts ',
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1),
                        ),
                        TextSpan(
                            text: '- Encouraging messages when you need them most,\n\n'
                        ),
                        TextSpan(
                          text: '🎯 Evening reminders ',
                          style: TextStyle(
                              fontSize: 16.sp,
                              height: 1.2,
                              fontFamily: circularBold,
                              color: nicotrackBlack1),
                        ),
                        TextSpan(
                            text: '- Celebrate your smoke-free achievements.\n\n'
                        ),

                      ])),
            ],
          ),
        ),
      ],
    );
  }
}