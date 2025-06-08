import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/cost-of-pack.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/last-smoke.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/smoke-frequency.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/one-pack-contents.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/biggest-motivation.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/crave-situations.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/help-need.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/image-constants.dart';
import 'package:flutter/services.dart';
import 'package:nicotrack/models/emoji-Text-Pair.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:nicotrack/initial/onboarding-questions/question-pages/enter-name.dart';
import '../models/onboarding-data/onboardingData-model.dart';
import '../screens/base/base.dart';
import 'package:hive/hive.dart';

class OnboardingController extends GetxController {
  List<Widget> pages = [
    LastSmoked(),
    SmokeFrequency(),
    CostofPack(),
    OnePackContents(),
    BiggestMotivation(),
    CraveSituations(),
    HelpNeed(),
    // QuitMethod(),
    EnterName(),
  ];
  final PageController pageController = PageController();
  int currentPage = 0;
  bool currentPageDoneStatus = false;

  OnboardingData onboardingFilledData = OnboardingData();

  //Page 2 variables - Cigarette frequency
  int selectedNumber1 = 2; // Default selected number
  FixedExtentScrollController listWheelController1 =
      FixedExtentScrollController(initialItem: 1);
  final List<int> numbers = List.generate(15, (index) => index + 1); // 1 to 15

  //Page 3 variables - Cigarette frequency
  late FixedExtentScrollController dollarController;
  late FixedExtentScrollController centController;
  int selectedDollar = 3;
  int selectedCent = 0;
  List<int> dollars = List.generate(100, (index) => index); // 0 to 100
  List<int> cents = List.generate(100, (index) => index); // 0 to 99

  //Page 4 variables - Cigarette frequency
  int selectedNumber2 = 5; // Default selected number
  late FixedExtentScrollController listWheelController2;
  final List<int> packNumbers =
      List.generate(20, (index) => index + 1); // 1 to 15

  //Page 5 variables - Cigarette frequency
  List<int> selectedMotivationIndex = [];
  List<String> selectedMotivations = [];
  List<EmojiTextPair> motivationPairs = [
    EmojiTextPair(emoji: heartEmoji, text: "Health benefits"),
    EmojiTextPair(emoji: cashEmoji, text: "Save Money"),
    EmojiTextPair(emoji: crownEmoji, text: "Personal challenge"),
    EmojiTextPair(emoji: peopleEmoji, text: "Family & loved ones"),
    EmojiTextPair(emoji: xmarkEmoji, text: "Break the addiction"),
    EmojiTextPair(emoji: rocketEmoji, text: "Other"),
  ];

  //Page 6 variables - Cigarette frequency
  List<int> selectedcravingsIndex = [];
  List<EmojiTextPair> craveSituationPairs = [
    EmojiTextPair(emoji: coffeeEmoji, text: "Morning with coffee"),
    EmojiTextPair(emoji: platesEmoji, text: "After meals"),
    EmojiTextPair(emoji: beerEmoji, text: "When drinking alcohol"),
    EmojiTextPair(emoji: stressedEmoji, text: "When feeling stressed"),
    EmojiTextPair(emoji: homeEmoji, text: "Boredom or habit"),
    EmojiTextPair(emoji: othersEmoji, text: "Other"),
  ];

  //Page 7 variables - Cigarette frequency
  List<int> selectedHelpIndex = [];
  List<EmojiTextPair> helpPairs = [
    EmojiTextPair(
        emoji: brainsoutEmoji, text: "Handling cravings & withdrawal"),
    EmojiTextPair(emoji: mountainEmoji, text: "Sticking to my quit plan"),
    EmojiTextPair(emoji: celebrateEmoji, text: "Support & motivation"),
    EmojiTextPair(emoji: badge1Emoji, text: "Tracking my progress"),
  ];

  //Page 8 variables - Cigarette frequency
  int instantQuitSelected = 0;



  void goToNextPage(int page) {
    currentPage = page;
    update();
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

  Widget getLastSmokedDate() {
    return Builder(builder: (context) {
      return SizedBox(
        height: 240.h,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newDateTime) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(newDateTime);
            HapticFeedback.lightImpact();
            onboardingFilledData =
                onboardingFilledData.copyWith(lastSmokedDate: formattedDate);
            getCurrentPageStatus();
            // Handle the selected date
          },
        ),
      );
    });
  }

  Widget cigarreteFrequencyScroll() {
    return // Number Picker
        SizedBox(
      height: 300.h,
      child: ListWheelScrollView.useDelegate(
        controller: listWheelController1,
        itemExtent: 120,

        // Spacing between items
        perspective: 0.005,
        diameterRatio: 5.0,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          HapticFeedback.mediumImpact();
          selectedNumber1 = numbers[index];
          onboardingFilledData =
              onboardingFilledData.copyWith(cigarettesPerDay: numbers[index]);
          getCurrentPageStatus();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = selectedNumber1 == numbers[index];

            return AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                  fontSize: 86.sp,
                  fontFamily: circularBold,
                  color: isSelected
                      ? nicotrackPurple
                      : nicotrackPurple.withOpacity(0.3)),
              child: Center(child: Text(numbers[index].toString())),
            );
          },
          childCount: numbers.length,
        ),
      ),
    );
  }

  Widget cigarreteFrequencyPack() {
    return // Number Picker
        SizedBox(
      height: 300.h,
      child: ListWheelScrollView.useDelegate(
        controller: listWheelController2,
        itemExtent: 120,
        // Spacing between items
        perspective: 0.005,
        diameterRatio: 5.0,
        physics: BouncingScrollPhysics(),
        onSelectedItemChanged: (index) {
          HapticFeedback.mediumImpact();
          selectedNumber2 = packNumbers[index];
          onboardingFilledData = onboardingFilledData.copyWith(
              numberOfCigarettesIn1Pack: packNumbers[index]);
          getCurrentPageStatus();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = selectedNumber2 == packNumbers[index];

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

  Widget biggestMotivationGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: GridView.builder(
          itemCount: motivationPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedMotivationIndex.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedMotivationIndex.contains(index)) {
                  selectedMotivationIndex.remove(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      biggestMotivation: onboardingFilledData.biggestMotivation
                          .where((e) => e != motivationPairs[index].text)
                          .toList());
                } else {
                  selectedMotivationIndex.add(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      biggestMotivation: [
                        ...onboardingFilledData.biggestMotivation,
                        motivationPairs[index].text
                      ]);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? nicotrackBlack1 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      motivationPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        motivationPairs[index].text,
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

  Widget cravingsGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GridView.builder(
          itemCount: craveSituationPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedcravingsIndex.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedcravingsIndex.contains(index)) {
                  selectedcravingsIndex.remove(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      craveSituations: onboardingFilledData.craveSituations
                          .where((e) => e != craveSituationPairs[index].text)
                          .toList());
                } else {
                  selectedcravingsIndex.add(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      craveSituations: [
                        ...onboardingFilledData.craveSituations,
                        craveSituationPairs[index].text
                      ]);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: Colors.deepPurple, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      craveSituationPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                        width: 120.w,
                        child: TextAutoSize(
                          craveSituationPairs[index].text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1),
                        )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget helpGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GridView.builder(
          itemCount: helpPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedHelpIndex.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedHelpIndex.contains(index)) {
                  selectedHelpIndex.remove(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      helpNeeded: onboardingFilledData.helpNeeded
                          .where((e) => e != helpPairs[index].text)
                          .toList());
                } else {
                  selectedHelpIndex.add(index);
                  onboardingFilledData = onboardingFilledData.copyWith(
                      helpNeeded: [
                        ...onboardingFilledData.helpNeeded,
                        helpPairs[index].text
                      ]);
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.h,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: Colors.deepPurple, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      helpPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                        width: 120.w,
                        child: TextAutoSize(
                          helpPairs[index].text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1),
                        )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget pricePackPicker() {
    return // Dollar Picker UI
        SizedBox(
      height: 328.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dollar Sign - Fixed
          TextAutoSize(
            "\$",
            style: TextStyle(
              fontSize: 86.sp,
              fontFamily: circularBold,
              color: Color(0xffF35E5C),
            ),
          ),

          SizedBox(width: 10),

          // Dollar Value Scroll
          SizedBox(
            width: 110.w,
            height: 328.h,
            child: ListWheelScrollView.useDelegate(
              controller: dollarController,
              itemExtent: 120.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedDollar = dollars[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                onboardingFilledData =
                    onboardingFilledData.copyWith(costOfAPack: dollarValue);
                getCurrentPageStatus();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: dollars.length,
                builder: (context, index) {
                  bool isSelected = selectedDollar == dollars[index];
                  return Center(
                    child: TextAutoSize(
                      dollars[index].toString(),
                      style: TextStyle(
                        fontSize: 86.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dot
          TextAutoSize(
            ".",
            style: TextStyle(
                fontSize: 86.sp,
                fontFamily: circularBold,
                color: Color(0xffF35E5C)),
          ),

          // Cents Scroll
          SizedBox(
            width: 110.w,
            height: 328.h,
            child: ListWheelScrollView.useDelegate(
              controller: centController,
              itemExtent: 120.h,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                HapticFeedback.mediumImpact();
                selectedCent = cents[index];
                String dollarValue = "$selectedDollar.$selectedCent";
                onboardingFilledData =
                    onboardingFilledData.copyWith(costOfAPack: dollarValue);
                getCurrentPageStatus();
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: cents.length,
                builder: (context, index) {
                  bool isSelected = selectedCent == cents[index];
                  String display = cents[index].toString().padLeft(2, '0');
                  return Center(
                    child: TextAutoSize(
                      display,
                      style: TextStyle(
                        fontSize: isSelected ? 86.sp : 86.sp,
                        fontFamily: circularBold,
                        color: isSelected
                            ? Color(0xffF35E5C)
                            : Color(0xffF35E5C).withOpacity(0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quitMethodSelection() {
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
                      instantQuitSelected = 1;
                      onboardingFilledData =
                          onboardingFilledData.copyWith(quitMethod: 1);
                      update();
                    },
                    child: Container(
                      width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.circular(16.r),
                        image: instantQuitSelected == 1
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
                          Image.asset(
                            instantQuitEmoji,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextAutoSize(
                            "Instant\nQuit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              "Stop immediately and use support tools",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                height: 1.2,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          )
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
                      instantQuitSelected = 2;
                      update();
                    },
                    child: Container(
                      // width: 155.h,
                      height: 235.h,
                      decoration: BoxDecoration(
                          color: Color(0xffF4F4F4),
                          image: instantQuitSelected == 2
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
                          Image.asset(
                            stepdownEmoji,
                            width: 70.w,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextAutoSize(
                            "Step-down Method",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 18.sp,
                              fontFamily: circularMedium,
                              color: nicotrackBlack1,
                            ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          SizedBox(
                            width: 130.w,
                            child: TextAutoSize(
                              "Gradually reduce smoking over time",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                height: 1.2,
                                fontFamily: circularMedium,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      ),
                    ))),
          ],
        ));
  }

  Widget nameTextField() {
    return TextField(
      maxLines: 2,
      onChanged: (v) {
        onboardingFilledData = onboardingFilledData.copyWith(name: v);
        getCurrentPageStatus();
      },
      decoration: InputDecoration(
        hintText: "Jane Wilson",
        hintStyle: TextStyle(
          fontFamily: circularBold,
          color: nicotrackPurple.withOpacity(0.21),
          fontSize: 48.sp,
        ),
        border: InputBorder.none,
        isDense: true,
        // Reduces vertical padding
        contentPadding: EdgeInsets.zero, // Optional: aligns with container edge
      ),
      cursorColor: nicotrackBlack1,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: circularBold,
        fontSize: 48.sp,
        color: nicotrackPurple,
      ),
    );
  }

  Widget continueButton(BuildContext context) {
    return GestureDetector(
      onTap: () async{

        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          if (currentPage == (pages.length - 1)) {
            final box = Hive.box<OnboardingData>('onboardingCompletedData');
            await box.put('currentUserOnboarding', onboardingFilledData); // Use a consistent key
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const Base(
                  ),
                ),
                    (route) => false);
          } else {
            nextPage();
          }
        }
      },
      child: Container(
        width: 346.w,
        height: 54.h,
        decoration: BoxDecoration(
          color: currentPageDoneStatus
              ? nicotrackBlack1
              : nicotrackButtonLightBlack,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Center(
          child: TextAutoSize(
            currentPage == (pages.length - 1) ? "Finish" : "Continue",
            style: TextStyle(
                fontSize: 18.sp,
                fontFamily: circularMedium,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool currentPageCompleted() {
    switch (currentPage) {
      case 0:
        if (onboardingFilledData.lastSmokedDate != "") {
          return true;
        } else {
          return false;
        }
      case 1:
        if (onboardingFilledData.cigarettesPerDay != -1) {
          return true;
        } else {
          return false;
        }
      case 2:
        if (onboardingFilledData.costOfAPack != "") {
          return true;
        } else {
          return false;
        }
      case 3:
        if (onboardingFilledData.numberOfCigarettesIn1Pack != -1) {
          return true;
        } else {
          return false;
        }
      case 4:
        if (onboardingFilledData.biggestMotivation != []) {
          return true;
        } else {
          return false;
        }
      case 5:
        if (onboardingFilledData.craveSituations != []) {
          return true;
        } else {
          return false;
        }
      case 6:
        if (onboardingFilledData.helpNeeded != []) {
          return true;
        } else {
          return false;
        }
      case 7:
        if (onboardingFilledData.name != "") {
          return true;
        } else {
          return false;
        }
      default:
        return false;
    }
  }

  void getCurrentPageStatus() {
    switch (currentPage) {
      case 0:
        if (onboardingFilledData.lastSmokedDate != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 1:
        if (onboardingFilledData.cigarettesPerDay != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 2:
        if (onboardingFilledData.costOfAPack != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 3:
        if (onboardingFilledData.numberOfCigarettesIn1Pack != -1) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 4:
        if (onboardingFilledData.biggestMotivation.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 5:
        if (onboardingFilledData.craveSituations.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 6:
        if (onboardingFilledData.helpNeeded.isNotEmpty) {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      case 7:
        if (onboardingFilledData.name != "") {
          currentPageDoneStatus = true;
        } else {
          currentPageDoneStatus = false;
        }
      default:
        currentPageDoneStatus = false;
    }
    update();
  }
}