import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/onboarding-controller.dart';
import '../../../screens/elements/textAutoSize.dart';

class QuitMethod extends StatefulWidget {
  const QuitMethod({super.key});

  @override
  State<QuitMethod> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<QuitMethod> {
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
                width: 230.w,
                child: TextAutoSize(
                  "How do you want to ❌ quit smoking?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 24.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              SizedBox(
                  width: 150.w,
                  child: TextAutoSize(
                    "Please select one. You can change this later too",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.2,
                        fontSize: 13.sp,
                        fontFamily: circularBook,
                        color: Color(0xff979797)),
                  )),
              SizedBox(
                height: 58.h,
              ),
              onboardingController.quitMethodSelection()
            ],
          );
        });
  }
}
