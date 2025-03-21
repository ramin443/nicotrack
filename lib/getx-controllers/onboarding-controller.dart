import 'package:get/get.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/cost-of-pack.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/last-smoke.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/smoke-frequency.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/one-pack-contents.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/biggest-motivation.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/crave-situations.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/help-need.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/quit-method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';

class OnboardingController extends GetxController {
  List<Widget> pages = [
    LastSmoked(),
    SmokeFrequency(),
    CostofPack(),
    OnePackContents(),
    BiggestMotivation(),
    CraveSituations(),
    HelpNeed(),
    QuitMethod()
  ];
  final PageController pageController = PageController();
  int currentPage = 0;

  //Page 2 variables - Cigarette frequency
  int selectedNumber = 3; // Default selected number
  FixedExtentScrollController listWheelController = FixedExtentScrollController(initialItem: 1);
  final List<int> numbers = [2, 3, 4];



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
      print("Onboarding complete!");
    }
  }

  void previousPage() {
    // Move to the next page
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle the case when reaching the last page (e.g., navigate to the main screen)
      print("Onboarding complete!");
    }
  }

  Widget topSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        width: 315.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: ((currentPage) / pages.length) * 315.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: nicotrackBlack1,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ],
        ),
      ),
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

  Widget cigarreteFrequencyScroll() {
    return // Number Picker
        SizedBox(
          height: 300.h,
      child: ListWheelScrollView.useDelegate(
        controller: listWheelController,
        itemExtent: 120,
        // Spacing between items
        perspective: 0.005,
        diameterRatio: 5.0,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
            selectedNumber = numbers[index];
            update();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = selectedNumber == numbers[index];

            return AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                fontSize:  96.sp,
                fontFamily: circularBold,
                color: isSelected ? Colors.deepPurple : Colors.grey.shade400,
              ),
              child: Center(child: Text(numbers[index].toString())),
            );
          },
          childCount: numbers.length,
        ),
      ),
    );
  }
}
