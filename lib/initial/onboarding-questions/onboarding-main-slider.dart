import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/welcome-initial-controller.dart';
import 'package:nicotrack/initial/welcome-info/slide-pages/track-milestones.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/last-smoke.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../../getx-controllers/onboarding-controller.dart';
import '../../screens/elements/textAutoSize.dart';
import 'package:flutter/services.dart';

class OnboardingMainSlider extends StatefulWidget {
  const OnboardingMainSlider({super.key});

  @override
  State<OnboardingMainSlider> createState() => _OnboardingMainSliderState();
}

class _OnboardingMainSliderState extends State<OnboardingMainSlider> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (onboardingController) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        surfaceTintColor: Colors.transparent,
                        centerTitle: false,
                        title: Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (onboardingController.currentPage != 0) {
                                  HapticFeedback.mediumImpact();
                                }
                                onboardingController.previousPage();
                              },
                              child: Container(
                                height: 36.w,
                                width: 36.w,
                                padding:
                                    EdgeInsets.only(right: 2.w, bottom: 2.w),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: onboardingController.currentPage == 0
                                        ? Colors.black54
                                        : nicotrackBlack1),
                                child: Center(
                                  child: Icon(
                                    FeatherIcons.chevronLeft,
                                    color: Colors.white,
                                    size: 24.w,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      onboardingController.topSlider(),
                      onboardingController.mainDisplay()
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(
                      //   height: 18.h,
                      // ),

                      onboardingController.continueButton(),

                      // TextAutoSize(
                      //   "Skip",
                      //   style: TextStyle(
                      //       fontSize: 18.sp,
                      //       decoration: TextDecoration.underline,
                      //       // Underline the text
                      //       fontFamily: circularMedium,
                      //       color: nicotrackBlack1),
                      // ),
                      SizedBox(
                        height: 34.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
