import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/how-many-today.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/how-you-feel.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/next-avoid.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/smoked-today.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/update-quit-date.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/what-triggered.dart';

import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../models/emoji-text-pair/emojitext-model.dart';
import '../models/mood-model/mood-model.dart';
import '../screens/elements/textAutoSize.dart';

class DidYouSmokeController extends GetxController{
  final PageController pageController = PageController();
  int currentPage = 0;
  MoodModel moodFilledData = MoodModel();
  List<Widget> pages = [
    SmokedToday(),
    HowManyToday(),
    WhatTriggered(),
    HowYouFeel(),
    NextAvoid(),
    UpdateQuitDate()
  ];
  bool currentPageDoneStatus = false;

  // Smoked today variables
  bool smokedToday = false;

  // Cigarette frequency variables
  int selectedNumber1 = 5; // Default selected number
  late FixedExtentScrollController listWheelController;
  final List<int> packNumbers =
  List.generate(20, (index) => index + 1); // 1 to 15

  //What Trigerred variables
  int selectedTriggered = -1;
  List<EmojiTextModel> triggerPairs = [
    EmojiTextModel(emoji: stressedEmoji, text: "Work Stress"),
    EmojiTextModel(emoji: tiredImg, text: "Relationship"),
    EmojiTextModel(emoji: beerEmoji, text: "Social setting"),
    EmojiTextModel(emoji: platesEmoji, text: "After a meal"),
    EmojiTextModel(emoji: cigImg, text: "Craving Episode"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Other"),
  ];

  //How you feel variables
  int selectedhowYouFeelIndex = -1;
  List<EmojiTextModel> howyouFeelPairs = [
    EmojiTextModel(emoji: sadImg, text: " Guilty"),
    EmojiTextModel(emoji: frustratedImg, text: "Frustrated "),
    EmojiTextModel(emoji: neutralImg, text: "Indifferent"),
    EmojiTextModel(emoji: motivImg, text: "Motivated to bounce back"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Others"),
  ];

  //Avoid Next variables
  int selectedAvoidIndex = -1;
  List<EmojiTextModel> nextAvoidPairs = [
    EmojiTextModel(emoji: meditateImg, text: " Use breathing exercises"),
    EmojiTextModel(emoji: gameImg, text: "Distract with a game"),
    EmojiTextModel(emoji: walkImg, text: "Go for a walk"),
    EmojiTextModel(emoji: phoneImg, text: "Call someone"),
    EmojiTextModel(emoji: notesImg, text: "Log craving and mood"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Other"),
  ];

  // UpdateQuitDate variables
  bool updateQuitDate = false;

  Widget continueButton() {
    return GestureDetector(
      onTap: () {
        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          if (currentPage == (pages.length - 1)) {
          } else {
            nextPage();
          }
        }
      },
      child: Container(
        width: 346.w,
        height: 54.h,
        decoration:  currentPage == (pages.length - 1) ?
        BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                fullButtonBg), // Load from assets
            fit: BoxFit
                .cover, // Adjusts how the image fits the container
          ),
        ):
        BoxDecoration(
          color: currentPageDoneStatus
              ? nicotrackBlack1
              : nicotrackButtonLightBlack,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: TextAutoSize(
            currentPage == (pages.length - 1) ? "🙌 Submit" : "Continue",
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularBold,
                color: currentPage == (pages.length - 1) ?nicotrackBlack1:Colors.white),
          ),
        ),
      ),
    );
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
        physics: NeverScrollableScrollPhysics(),
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

  Widget smokedTodaySelection() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      smokedToday = true;
                      // onboardingFilledData.quitMethod = 1;
                      update();
                    },
                    child: Container(
                      width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: smokedToday
                            ? DecorationImage(
                          image: AssetImage(
                              quitMethodBG), // Replace with your image path
                          fit: BoxFit
                              .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                        )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Image.asset(
                            fireImg,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          TextAutoSize(
                            "Yes, I smoked today",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                        ],
                      ),
                    ))),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      smokedToday = false;
                      update();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: !smokedToday
                              ? DecorationImage(
                            image: AssetImage(
                                quitMethodBG), // Replace with your image path
                            fit: BoxFit
                                .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                          )
                              : null,
                          borderRadius: BorderRadius.circular(16.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Image.asset(
                            iceImg,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          TextAutoSize(
                            " No, I stayed smoke-free!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),

                        ],
                      ),
                    ))),
          ],
        ));
  }

  Widget cigarreteFrequencySlider() {
    return // Number Picker
      SizedBox(
        height: 300.h,
        child: ListWheelScrollView.useDelegate(
          controller: listWheelController,
          itemExtent: 120,
          // Spacing between items
          perspective: 0.005,
          diameterRatio: 5.0,
          physics: BouncingScrollPhysics(),
          onSelectedItemChanged: (index) {
            HapticFeedback.mediumImpact();
            selectedNumber1 = packNumbers[index];
            // onboardingFilledData.numberOfCigarettesIn1Pack = packNumbers[index];
            getCurrentPageStatus();
          },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              bool isSelected = selectedNumber1 == packNumbers[index];

              return AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(
                    fontSize: 86.sp,
                    fontFamily: circularBold,
                    color: isSelected
                        ? nicotrackPurple
                        : nicotrackPurple.withOpacity(0.3)),
                child: Center(child: Text(packNumbers[index].toString())),
              );
            },
            childCount: packNumbers.length,
          ),
        ),
      );
  }

  Widget whatTriggeredGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w,),
        child: GridView.builder(
          itemCount: triggerPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedNumber1 == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedNumber1 == index) {

                } else {
                  selectedNumber1 = index;
                  moodFilledData = moodFilledData.copyWith(moodAffecting: triggerPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? nicotrackBlack1 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? nicotrackBlack1 : Color(0xffF0F0F0),
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      triggerPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        triggerPairs[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: circularMedium,
                            color: isSelected ? Colors.white : nicotrackBlack1),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget howYouFeelGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w,),
        child: GridView.builder(
          itemCount: howyouFeelPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedhowYouFeelIndex == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedhowYouFeelIndex == index) {

                } else {
                  selectedhowYouFeelIndex = index;
                  moodFilledData = moodFilledData.copyWith(moodAffecting: howyouFeelPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? nicotrackBlack1 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? nicotrackBlack1 : Color(0xffF0F0F0),
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      howyouFeelPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        howyouFeelPairs[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.1,
                            fontFamily: circularMedium,
                            color: isSelected ? Colors.white : nicotrackBlack1),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget avoidNextGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w,),
        child: GridView.builder(
          itemCount: nextAvoidPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedAvoidIndex == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedAvoidIndex == index) {

                } else {
                  selectedAvoidIndex = index;
                  moodFilledData = moodFilledData.copyWith(moodAffecting: nextAvoidPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? nicotrackBlack1 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? nicotrackBlack1 : Color(0xffF0F0F0),
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      nextAvoidPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        nextAvoidPairs[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.1,
                            fontFamily: circularMedium,
                            color: isSelected ? Colors.white : nicotrackBlack1),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget updateQuitDateSelection() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      updateQuitDate = true;
                      // onboardingFilledData.quitMethod = 1;
                      update();
                    },
                    child: Container(
                      width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: updateQuitDate
                            ? DecorationImage(
                          image: AssetImage(
                              quitMethodBG), // Replace with your image path
                          fit: BoxFit
                              .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                        )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Image.asset(
                            yesUpdateImg,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          TextAutoSize(
                            "Yes, update my quit date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                        ],
                      ),
                    ))),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      updateQuitDate = false;
                      update();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: !updateQuitDate
                              ? DecorationImage(
                            image: AssetImage(
                                quitMethodBG), // Replace with your image path
                            fit: BoxFit
                                .cover, // You can also use BoxFit.fill, BoxFit.contain, etc.
                          )
                              : null,
                          borderRadius: BorderRadius.circular(16.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Image.asset(
                            noUpdateImg,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          TextAutoSize(
                            "No, keep my quit date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularBold,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),

                        ],
                      ),
                    ))),
          ],
        ));
  }

  void initializeToStart() {
    // Initialize controller to set the pre-selected item without animation
    listWheelController = FixedExtentScrollController(
      initialItem: packNumbers.indexOf(
          selectedNumber1), // Selects the correct number without scrolling
    );
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

  void nextPage() {
    // Move to the next page
    if (currentPage < pages.length - 1) {
      currentPage++;
      getCurrentPageStatus();
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
  void goToNextPage(int page) {
    currentPage = page;
    update();
  }

  void getCurrentPageStatus() {
    switch (currentPage) {
      case 0:
        if (moodFilledData.selfFeeling.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 1:
        if (moodFilledData.moodAffecting.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 2:
        if (moodFilledData.anyCravingToday != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 3:
        if (moodFilledData.craveTiming.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 4:
        currentPageDoneStatus = true;
      default:
        currentPageDoneStatus = false;
    }
    update();
  }


}