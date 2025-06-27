import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/screens/elements/linear-progress-bar.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/how-many-today.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/how-you-feel.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/next-avoid.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/smoked-today.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/update-quit-date.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/what-triggered.dart';
import 'package:nicotrack/screens/home/did-you-smoke/pages/no-selected/congratulatory-page.dart';
import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../models/emoji-text-pair/emojitext-model.dart';
import '../screens/elements/data-cubes.dart';
import '../screens/elements/textAutoSize.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/base/base.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/getx-controllers/home-controller.dart';

class DidYouSmokeController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0;
  DidYouSmokeModel didYouSmokeFilledData = DidYouSmokeModel();
  
  // All pages are for smoking flow only
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
  List<Map<String, dynamic>> selectedTriggered = [];
  List<EmojiTextModel> triggerPairs = [
    EmojiTextModel(emoji: stressedEmoji, text: "Work Stress"),
    EmojiTextModel(emoji: tiredImg, text: "Relationship"),
    EmojiTextModel(emoji: beerEmoji, text: "Social setting"),
    EmojiTextModel(emoji: platesEmoji, text: "After a meal"),
    EmojiTextModel(emoji: cigImg, text: "Craving Episode"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Other"),
  ];

  //How you feel variables
  List<Map<String, dynamic>> selectedhowYouFeelIndex = [];
  List<EmojiTextModel> howyouFeelPairs = [
    EmojiTextModel(emoji: sadImg, text: " Guilty"),
    EmojiTextModel(emoji: frustratedImg, text: "Frustrated "),
    EmojiTextModel(emoji: neutralImg, text: "Indifferent"),
    EmojiTextModel(emoji: motivImg, text: "Motivated to bounce back"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Others"),
  ];

  //Avoid Next variables
  List<Map<String, dynamic>> selectedAvoidIndex = [];
  List<EmojiTextModel> nextAvoidPairs = [
    EmojiTextModel(emoji: meditateImg, text: " Use breathing exercises"),
    EmojiTextModel(emoji: gameImg, text: "Distract with a game"),
    EmojiTextModel(emoji: walkImg, text: "Go for a walk"),
    EmojiTextModel(emoji: phoneImg, text: "Call someone"),
    EmojiTextModel(emoji: notesImg, text: "Log craving and mood"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Other"),
  ];

  // UpdateQuitDate variables
  int updateQuitDate = -1;

  Widget continueButton(DateTime currentDateTime, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          
          // If on first page and user selected smoke-free, navigate directly to congratulations
          if (currentPage == 0 && !smokedToday) {
            navigateToCongratsPage(currentDateTime, context);
          } else if (currentPage == (pages.length - 1)) {
            addDatatoHiveandNavigate(currentDateTime, context);
          } else {
            nextPage();
          }
        }
      },
      child: Container(
        width: 346.w,
        height: 54.w,
        decoration: currentPage == (pages.length - 1)
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(fullButtonBg), // Load from assets
                  fit: BoxFit.cover, // Adjusts how the image fits the container
                ),
              )
            : BoxDecoration(
                color: currentPageDoneStatus
                    ? nicotrackBlack1
                    : nicotrackButtonLightBlack,
                borderRadius: BorderRadius.circular(30.r),
              ),
        child: Center(
          child: TextAutoSize(
            currentPage == (pages.length - 1) ? "🏠 Finish" : "Continue",
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularBold,
                color: currentPage == (pages.length - 1)
                    ? nicotrackBlack1
                    : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget gotoHomeBtn() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Save smoke-free data and navigate to home
            DateTime currentDateTime = DateTime.now();
            addDatatoHiveandNavigate(currentDateTime, Get.context!);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                fullButtonBg,
                width: 346.w,
              ),
              TextAutoSize(
                "🏠 Go to home",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 24.h,
        )
      ],
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
                      didYouSmokeFilledData =
                          didYouSmokeFilledData.copyWith(hasSmokedToday: 0);
                      getCurrentPageStatus();
                    },
                    child: Container(
                      width: 155.w,
                      height: 235.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: didYouSmokeFilledData.hasSmokedToday == 0
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
                      didYouSmokeFilledData = didYouSmokeFilledData.copyWith(
                        hasSmokedToday: 1,
                        // Set empty/default values for smoking-related fields
                        howManyCigs: 0,
                        whatTriggerred: [],
                        howYouFeel: [],
                        avoidNext: [],
                        updateQuitDate: 1, // Keep current quit date
                      );
                      getCurrentPageStatus();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.w,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: didYouSmokeFilledData.hasSmokedToday == 1
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
          didYouSmokeFilledData =
              didYouSmokeFilledData.copyWith(howManyCigs: selectedNumber1);
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
        padding: EdgeInsets.only(
          left: 28.w,
          right: 28.w,
        ),
        child: GridView.builder(
          itemCount: triggerPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedTriggered.any(
                (element) => (element['emoji'] == triggerPairs[index].emoji));

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedTriggered.any((element) =>
                    (element['emoji'] == triggerPairs[index].emoji))) {
                  selectedTriggered.removeWhere((elem) =>
                      elem['emoji'] == triggerPairs[index].emoji &&
                      elem['text'] == triggerPairs[index].text);
                } else {
                  selectedTriggered.add(triggerPairs[index].toJson());
                  didYouSmokeFilledData = didYouSmokeFilledData.copyWith(
                      whatTriggerred: selectedTriggered);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple.shade100 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Color(0xffF0F0F0),
                    width: isSelected ? 2.sp : 1.sp,
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
                            color: nicotrackBlack1),
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
        padding: EdgeInsets.only(
          left: 28.w,
          right: 28.w,
        ),
        child: GridView.builder(
          itemCount: howyouFeelPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedhowYouFeelIndex.any(
                (element) => element["emoji"] == howyouFeelPairs[index].emoji);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedhowYouFeelIndex.any((element) =>
                    element["emoji"] == howyouFeelPairs[index].emoji)) {
                  selectedhowYouFeelIndex.removeWhere(
                      (elem) => elem["emoji"] == howyouFeelPairs[index].emoji);
                } else {
                  selectedhowYouFeelIndex.add(howyouFeelPairs[index].toJson());
                  didYouSmokeFilledData = didYouSmokeFilledData.copyWith(
                      howYouFeel: selectedhowYouFeelIndex);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple.shade100 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Color(0xffF0F0F0),
                    width: isSelected ? 2.sp : 1.sp,
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
                            color: nicotrackBlack1),
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
        padding: EdgeInsets.only(
          left: 28.w,
          right: 28.w,
        ),
        child: GridView.builder(
          itemCount: nextAvoidPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedAvoidIndex.any(
                (element) => element["emoji"] == nextAvoidPairs[index].emoji);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedAvoidIndex.any((element) =>
                    element["emoji"] == nextAvoidPairs[index].emoji)) {
                  selectedAvoidIndex.removeWhere((element) =>
                      element["emoji"] == nextAvoidPairs[index].emoji);
                } else {
                  selectedAvoidIndex.add(nextAvoidPairs[index].toJson());
                  didYouSmokeFilledData = didYouSmokeFilledData.copyWith(
                      avoidNext: selectedAvoidIndex);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple.shade100 : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Color(0xffF0F0F0),
                    width: isSelected ? 2.sp : 1.sp,
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
                            color: nicotrackBlack1),
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
                      updateQuitDate = 0;
                      didYouSmokeFilledData =
                          didYouSmokeFilledData.copyWith(updateQuitDate: 0);
                      getCurrentPageStatus();
                      update();
                    },
                    child: Container(
                      width: 155.w,
                      height: 235.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: updateQuitDate == 0
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
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              "Yes, update my quit date",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 18.sp,
                                fontFamily: circularBold,
                                color: nicotrackBlack1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            width: 145.w,
                            child: TextAutoSize(
                              "(Resets your smoke-free streak to Day 0)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 11.sp,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
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
                      updateQuitDate = 1;
                      didYouSmokeFilledData =
                          didYouSmokeFilledData.copyWith(updateQuitDate: 1);
                      getCurrentPageStatus();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.w,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: updateQuitDate == 1
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
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              "No, keep my quit date",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 18.sp,
                                fontFamily: circularBold,
                                color: nicotrackBlack1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            width: 145.w,
                            child: TextAutoSize(
                              "(This was just a one-time slip — I’m still on track!)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 11.sp,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      ),
                    ))),
          ],
        ));
  }

  Widget notSmokedTodayDataCubes() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 6.w,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: 1.58,
        children: [
          mainCard(
            emoji: bicepsEmoji,
            value: '24',
            label: 'Days since\nlast smoked',
            backgroundColor: const Color(0xFFB0F0A1), // green-ish background
          ),
          statCard(
            emoji: moneyEmoji,
            value: 24,
            label: 'Money saved',
            isCost: true,
          ),
        ],
      ),
    );
  }

  Widget financialGoalProgressBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularMedium,
                        height: 1.1,
                        color: nicotrackBlack1,
                      ),
                      children: [
                        TextSpan(text: '🥅 Financial Goal: 📱 iPad '),
                        TextSpan(
                          text: '4%',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: Color(0xff6D9C32),
                          ),
                        ),
                        TextSpan(text: ' completed.'),
                      ])),
            ],
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: StyledProgressBar(progress: 0.04),
        ),
        SizedBox(
          height: 18.h,
        ),
      ],
    );
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
    print("FIlled data is ${didYouSmokeFilledData.toJson()}");
    
    // Standard flow for all pages
    switch (currentPage) {
      case 0:
        if (didYouSmokeFilledData.hasSmokedToday != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 1:
        if (didYouSmokeFilledData.howManyCigs != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 2:
        if (didYouSmokeFilledData.whatTriggerred.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 3:
        if (didYouSmokeFilledData.howYouFeel.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 4:
        if (didYouSmokeFilledData.avoidNext.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 5:
        if (didYouSmokeFilledData.updateQuitDate != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      default:
        currentPageDoneStatus = false;
    }
    update();
  }

  void navigateToCongratsPage(DateTime currentDateTime, BuildContext context) async {
    // Save smoke-free data to Hive
    String didYouSmokeStringToday = DateFormat.yMMMd()
        .format(currentDateTime);
    final box = Hive.box<DidYouSmokeModel>('didYouSmokeData');
    await box.put(didYouSmokeStringToday, didYouSmokeFilledData);
    print("Saving smoke-free data: $didYouSmokeStringToday with data $didYouSmokeFilledData");
    
    if (context.mounted) {
      // Navigate to congratulations page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NoSmokeCongratsPage(),
        ),
      );
    }
  }

  void addDatatoHiveandNavigate(DateTime currentDateTime, BuildContext context) async {
    String didYouSmokeStringToday = DateFormat.yMMMd()
        .format(currentDateTime);
    final box = Hive.box<DidYouSmokeModel>('didYouSmokeData');
    await box.put(didYouSmokeStringToday, didYouSmokeFilledData);
    
    // If user chose to update their quit date (0 = Yes, update my quit date)
    if (didYouSmokeFilledData.updateQuitDate == 0) {
      // Update the last smoked date in onboarding data
      final onboardingBox = Hive.box<OnboardingData>('onboardingCompletedData');
      OnboardingData? userOnboardingData = onboardingBox.get('currentUserOnboarding');
      
      if (userOnboardingData != null) {
        // Update the last smoked date to today's date
        String newQuitDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
        OnboardingData updatedData = userOnboardingData.copyWith(lastSmokedDate: newQuitDate);
        await onboardingBox.put('currentUserOnboarding', updatedData);
        print("Updated quit date to: $newQuitDate");
      }
    }
    
    if (context.mounted) {
      // Force refresh home controller if quit date was updated
      if (didYouSmokeFilledData.updateQuitDate == 0) {
        // Get the home controller if it exists and refresh its data
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().resetHomeGridValues();
        }
      }
      
      // Good practice: check if the widget is still in the tree
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Base(),
          ),
              (route) => false);
    }
  }
}