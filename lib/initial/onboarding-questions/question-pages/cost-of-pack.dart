import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';

class CostofPack extends StatefulWidget {
  const CostofPack({super.key});

  @override
  State<CostofPack> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<CostofPack> {
  OnboardingController onboardingMainController =
      Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        initState: (v) {
          // Ensure the initial index matches the current selection
          final initialIndex1 = onboardingMainController.dollars
              .indexOf(onboardingMainController.selectedDollar);
          onboardingMainController.dollarController =
              FixedExtentScrollController(
            initialItem: initialIndex1 >= 0 ? initialIndex1 : 0,
          );
          onboardingMainController.dollarController.jumpToItem(initialIndex1);

          final initialIndex2 = onboardingMainController.cents
              .indexOf(onboardingMainController.selectedCent);
          onboardingMainController.centController = FixedExtentScrollController(
            initialItem: initialIndex2 >= 0 ? initialIndex2 : 0,
          );
          onboardingMainController.centController.jumpToItem(initialIndex2);
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
                  "How much does your pack of cigarette 💰cost?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              onboardingController.pricePackPicker(),
            ],
          );
        });
  }
}