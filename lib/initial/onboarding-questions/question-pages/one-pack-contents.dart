import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';

class OnePackContents extends StatefulWidget {
  const OnePackContents({super.key});

  @override
  State<OnePackContents> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<OnePackContents> {
  OnboardingController onboardingMainController =
      Get.find<OnboardingController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        initState: (v) {
          final initialIndex = onboardingMainController.packNumbers
              .indexOf(onboardingMainController.selectedNumber2);
          onboardingMainController.listWheelController2 =
              FixedExtentScrollController(
            initialItem: initialIndex >= 0 ? initialIndex : 0,
          );
          onboardingMainController.listWheelController2
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
                  context.l10n.onboarding_pack_contents_question,
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
              onboardingController.cigarreteFrequencyPack()
            ],
          );
        });
  }
}