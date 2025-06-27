import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';

class LastSmoked extends StatefulWidget {
  const LastSmoked({super.key});

  @override
  State<LastSmoked> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<LastSmoked> {
  OnboardingController onboardingController = Get.find<OnboardingController>();

  @override
  void initState() {
    super.initState();
  }

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
                  "When was the last time you smoked a 🚬 cigarette?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(height: 60.h),
              onboardingController.getLastSmokedDate(),
              Spacer(),
            ],
          );
        });
  }
}