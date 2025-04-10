import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';


class CraveSituations extends StatefulWidget {
  const CraveSituations({super.key});

  @override
  State<CraveSituations> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<CraveSituations> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (onboardingController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 26.h,
              ),
              SizedBox(
                width: 340.w,
                child: TextAutoSize(
                  "What situations make you crave cigarettes 😥 the most?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              onboardingController.cravingsGrid(),

            ],
          );
        });
  }
}
