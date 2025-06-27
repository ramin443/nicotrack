import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/initial/welcome-info/slide-pages/crush-cravings.dart';
import 'package:nicotrack/initial/welcome-info/slide-pages/quit-plan.dart';
import 'package:nicotrack/initial/welcome-info/slide-pages/stay-motivated.dart';
import 'package:nicotrack/initial/onboarding-questions/onboarding-main-slider.dart';

import '../initial/welcome-info/slide-pages/track-milestones.dart';

class WelcomeInitialController extends GetxController {
  List<Widget> pages = [
    TrackMilestones(),
    CrushCravings(),
    PersonalizedQuitPlan(),
    StayMotivated()
  ];
  final PageController pageController = PageController();
  int currentPage = 0;

  void goToNextPage(int page) {
    currentPage = page;
    update();
  }

  void nextPage() {
    // Move to the next page
    if (currentPage < pages.length - 1) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle the case when reaching the last page (e.g., navigate to the main screen)
      print("Info slider complete!");
    }
  }

  void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingMainSlider()),
    );
  }

  Widget mainDisplay() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        onPageChanged: (int page) {
          goToNextPage(page);
        },
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(key: ValueKey<int>(index), child: pages[index]));
        },
      ),
    );
  }

  Widget sliderDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: 5.w,
          width: currentPage == 0 ? 36.w : 5.w,
          decoration: BoxDecoration(
            color: currentPage == 0
                ? nicotrackBlack1
                : Colors.black.withOpacity(0.46),
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: 5.w,
          width: currentPage == 1 ? 36.w : 5.w,
          decoration: BoxDecoration(
            color: currentPage == 1
                ? nicotrackBlack1
                : Colors.black.withOpacity(0.46),
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: 5.w,
          width: currentPage == 2 ? 36.w : 5.w,
          decoration: BoxDecoration(
            color: currentPage == 2
                ? nicotrackBlack1
                : Colors.black.withOpacity(0.46),
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: 5.w,
          width: currentPage == 3 ? 36.w : 5.w,
          decoration: BoxDecoration(
            color: currentPage == 3
                ? nicotrackBlack1
                : Colors.black.withOpacity(0.46),
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
      ],
    );
  }
}
