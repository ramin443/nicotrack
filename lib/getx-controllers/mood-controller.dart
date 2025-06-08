import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/models/emoji-text-pair/emojitext-model.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:nicotrack/screens/home/mood/mood-affecting.dart';
import 'package:nicotrack/screens/home/mood/mood-crave-times.dart';
import 'package:nicotrack/screens/home/mood/mood-cravings.dart';
import 'package:nicotrack/screens/home/mood/mood-feeling.dart';
import 'package:nicotrack/screens/home/mood/mood-reflect-note.dart';
import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../screens/elements/textAutoSize.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:hive/hive.dart';
import 'package:nicotrack/screens/base/base.dart';

class MoodController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0;
  List<Widget> pages = [
    MoodFeeling(),
    MoodAffecting(),
    MoodCravings(),
    MoodCraveTimes(),
    MoodReflectTimes()
  ];
  bool currentPageDoneStatus = false;
  MoodModel moodFilledData = MoodModel();
  TextEditingController noteTextController = TextEditingController();

  //How you feeling variables
  int selectedFeelingsIndex = -1;
  List<EmojiTextModel> howareyouFeelingPairs = [
    EmojiTextModel(emoji: happyImg, text: "Happy"),
    EmojiTextModel(emoji: neutralImg, text: "Neutral"),
    EmojiTextModel(emoji: sadImg, text: "Sad"),
    EmojiTextModel(emoji: angryImg, text: "Angry"),
    EmojiTextModel(emoji: anxiousImg, text: "Anxious"),
    EmojiTextModel(emoji: motivImg, text: "Confident"),
    EmojiTextModel(emoji: tiredImg, text: "Tired"),
    EmojiTextModel(emoji: frustratedImg, text: "Frustrated"),
    EmojiTextModel(emoji: partyImg, text: "Excited"),
    EmojiTextModel(emoji: confusedImg, text: "Confused"),
    EmojiTextModel(emoji: targetImg, text: "Motivated"),
    EmojiTextModel(emoji: othersEmoji, text: "Other"),
  ];

  //Mood Affecting variables
  int selectedMoodAffectingIndex = -1;
  List<EmojiTextModel> moodAffectingPairs = [
    EmojiTextModel(emoji: workstressImg, text: "Work Stress"),
    EmojiTextModel(emoji: heartbreakImg, text: "Relationship"),
    EmojiTextModel(emoji: familyImg, text: "Family"),
    EmojiTextModel(emoji: healthImg, text: "Health "),
    EmojiTextModel(emoji: cigImg, text: "Craving Episode"),
    EmojiTextModel(emoji: confettiImg, text: "Feeling Proud"),
    EmojiTextModel(emoji: sunImg, text: "Just a chill day"),
    EmojiTextModel(emoji: xmarkEmoji, text: "Other"),
  ];

  //Any cravings variables
  int selectedCravingIndex = -1;
  List<EmojiTextModel> cravingPairs = [
    EmojiTextModel(emoji: fireImg, text: "Yes,\nstrong ones"),
    EmojiTextModel(emoji: wavesImg, text: "Yes,\nmild"),
    EmojiTextModel(emoji: iceImg, text: "No cravings at all"),
  ];

  //When did you crave variables
  int selectedCraveTimesIndex = -1;
  List<EmojiTextModel> craveTimesPairs = [
    EmojiTextModel(emoji: coffeeEmoji, text: "Morning with coffee"),
    EmojiTextModel(emoji: platesEmoji, text: "After meals"),
    EmojiTextModel(emoji: beerEmoji, text: "When drinking alcohol"),
    EmojiTextModel(emoji: stressedEmoji, text: "When feeling stressed"),
    EmojiTextModel(emoji: homeEmoji, text: "Boredom or habit"),
    EmojiTextModel(emoji: othersEmoji, text: "Other"),
  ];

  Widget topSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        width: 315.w,
        height: 6.w,
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
              height: 6.w,
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

  Widget moodFeelingsGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: GridView.builder(
          itemCount: howareyouFeelingPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedFeelingsIndex == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedFeelingsIndex == index) {
                } else {
                  selectedFeelingsIndex = index;
                  moodFilledData = moodFilledData.copyWith(
                      selfFeeling: howareyouFeelingPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.w,
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
                      howareyouFeelingPairs[index].emoji,
                      width: 38.w,
                    ),
                    SizedBox(height: 8.w),
                    SizedBox(
                      child: TextAutoSize(
                        howareyouFeelingPairs[index].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.sp,
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

  Widget moodAffectingGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 28.w,
          right: 28.w,
        ),
        child: GridView.builder(
          itemCount: moodAffectingPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedMoodAffectingIndex == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedMoodAffectingIndex == index) {
                } else {
                  selectedMoodAffectingIndex = index;
                  moodFilledData = moodFilledData.copyWith(
                      moodAffecting: moodAffectingPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.w,
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
                      moodAffectingPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.w),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        moodAffectingPairs[index].text,
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

  Widget anyCravingsTodayGrid() {
    // Grid View for selection
    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int index = 0; index < cravingPairs.length; index++)
            Builder(builder: (context) {
              bool isSelected = selectedCravingIndex == index;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      if (selectedCravingIndex == index) {
                      } else {
                        selectedCravingIndex = index;
                        moodFilledData =
                            moodFilledData.copyWith(anyCravingToday: index);
                      }
                      getCurrentPageStatus();
                    },
                    child: Container(
                      width: 298.w,
                      padding: EdgeInsets.symmetric(vertical: 22.w),
                      decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.black87 : Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(16.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 30.w,
                          ),
                          Image.asset(
                            cravingPairs[index].emoji,
                            width: 54.w,
                          ),
                          SizedBox(
                            width: 38.w,
                          ),
                          SizedBox(
                            width: 120.w,
                            child: TextAutoSize(
                              cravingPairs[index].text,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  height: 1.2,
                                  fontFamily: circularMedium,
                                  color: isSelected
                                      ? Colors.white
                                      : nicotrackBlack1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.w,
                  )
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget craveTimesGrid() {
    // Grid View for selection
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: GridView.builder(
          itemCount: craveTimesPairs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 9.w,
            mainAxisSpacing: 9.w,
            childAspectRatio: 1, // Adjusts box shape
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedCraveTimesIndex == index;

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedCraveTimesIndex == index) {
                } else {
                  selectedCraveTimesIndex = index;
                  moodFilledData = moodFilledData.copyWith(
                      craveTiming: craveTimesPairs[index].toJson());
                }
                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.w,
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
                      craveTimesPairs[index].emoji,
                      width: 54.w,
                    ),
                    SizedBox(height: 18.w),
                    SizedBox(
                      width: 138.w,
                      child: TextAutoSize(
                        craveTimesPairs[index].text,
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

  Widget quickNoteTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.w),
              height: 332.w,
              decoration: BoxDecoration(
                  color: Color(0xfff4f4f4),
                  borderRadius: BorderRadius.circular(16.r)),
              child: TextField(
                maxLines: null,
                controller: noteTextController,
                // makes it multiline
                keyboardType: TextInputType.multiline,
                onChanged: (v) {
                  moodFilledData = moodFilledData.copyWith(reflectionNote: v);
                  getCurrentPageStatus();
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Write something... 💬 (optional)",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: circularBook,
                    color: Colors.black.withValues(alpha: 92),
                  ),
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularBook,
                  color: Colors.black87,
                ),
              )),
        ],
      ),
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

  void goToNextPage(int page) {
    currentPage = page;
    update();
  }

  Widget continueButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          if (currentPage == (pages.length - 1)) {
            addDatatoHiveandNavigate(context);
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
            currentPage == (pages.length - 1) ? "🙌 Finish" : "Continue",
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

  void nextPage() {
    // Move to the next page
    if (currentPage < pages.length - 1) {
      print("Mood filled data is ${moodFilledData}");
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

  void addDatatoHiveandNavigate(BuildContext context) async {
    DateTime todayDate = DateTime.now();
    String moodStringToday = DateFormat.yMMMd()
        .format(DateTime(todayDate.year, todayDate.month, todayDate.day));
    final box = Hive.box<MoodModel>('moodData');
    await box.put(moodStringToday, moodFilledData);
    if (context.mounted) {
      // Good practice: check if the widget is still in the tree
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Base(),
          ),
          (route) => false);
    }
  }
}