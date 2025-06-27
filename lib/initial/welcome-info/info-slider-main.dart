import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/welcome-initial-controller.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import '../../screens/elements/textAutoSize.dart';

class InfoSliderMain extends StatefulWidget {
  const InfoSliderMain({super.key});

  @override
  State<InfoSliderMain> createState() => _InfoSliderMainState();
}

class _InfoSliderMainState extends State<InfoSliderMain> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeInitialController>(
        init: WelcomeInitialController(),
        builder: (welcomeInitialController) {
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
                      ),
                      welcomeInitialController.mainDisplay(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: (welcomeInitialController.currentPage ==
                          welcomeInitialController.pages.length - 1)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            welcomeInitialController.sliderDisplay(),
                            SizedBox(
                              height: 14.h,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                welcomeInitialController.navigateToOnboarding(context);
                              },
                              child: Container(
                                width: 346.w,
                                height: 54.h,
                                margin: EdgeInsets.symmetric(vertical: 24.w),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        fullButtonBg), // Load from assets
                                    fit: BoxFit
                                        .cover, // Adjusts how the image fits the container
                                  ),
                                ),
                                child: Center(
                                  child: TextAutoSize(
                                    "Get Started",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: circularBold,
                                        color: nicotrackBlack1),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 34.h,
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            welcomeInitialController.sliderDisplay(),
                            SizedBox(
                              height: 18.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                welcomeInitialController.nextPage();
                              },
                              child: Container(
                                width: 346.w,
                                height: 54.h,
                                margin: EdgeInsets.symmetric(vertical: 24.w),
                                decoration: BoxDecoration(
                                  color: nicotrackBlack1,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Center(
                                  child: TextAutoSize(
                                    "Continue",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: circularMedium,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                welcomeInitialController.navigateToOnboarding(context);
                              },
                              child: TextAutoSize(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    decoration: TextDecoration.underline,
                                    // Underline the text
                                    fontFamily: circularMedium,
                                    color: nicotrackBlack1),
                              ),
                            ),
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
