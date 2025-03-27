import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';

class SmokeFrequency extends StatefulWidget {
  const SmokeFrequency({super.key});

  @override
  State<SmokeFrequency> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<SmokeFrequency> {
  final onboardingMainController = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        initState: (v) {
          // Ensure the initial index matches the current selection
          final initialIndex = onboardingMainController.numbers
              .indexOf(onboardingMainController.selectedNumber1);
          onboardingMainController.listWheelController1 =
              FixedExtentScrollController(
            initialItem: initialIndex >= 0 ? initialIndex : 0,
          );
          onboardingMainController.listWheelController1
              .jumpToItem(initialIndex);
        },
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
                  "How many 🚬 cigarettes did you consume per day?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 44.h,
              ),
              onboardingController.cigarreteFrequencyScroll(),
            ],
          );
        });
  }
}