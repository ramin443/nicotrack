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
import 'package:hive/hive.dart';
import 'package:nicotrack/screens/mood/mood-detail-screen.dart';

class MoodController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0;
  List<Widget> _basePagesTemplate = [
    MoodFeeling(),
    MoodAffecting(),
    MoodCravings(),
    MoodCraveTimes(),
    MoodReflectTimes()
  ];
  List<Widget> pages = [];
  bool currentPageDoneStatus = false;
  MoodModel moodFilledData = MoodModel();
  TextEditingController noteTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize with basic pages - will be updated dynamically
    pages = List.from(_basePagesTemplate);
  }

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
  Set<int> selectedMoodAffectingIndices = <int>{};
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
  Set<int> selectedCraveTimesIndices = <int>{};
  List<EmojiTextModel> craveTimesPairs = [
    EmojiTextModel(emoji: coffeeEmoji, text: "Morning with coffee"),
    EmojiTextModel(emoji: platesEmoji, text: "After meals"),
    EmojiTextModel(emoji: beerEmoji, text: "When drinking alcohol"),
    EmojiTextModel(emoji: stressedEmoji, text: "When feeling stressed"),
    EmojiTextModel(emoji: homeEmoji, text: "Boredom or habit"),
    EmojiTextModel(emoji: othersEmoji, text: "Other"),
  ];

  void _rebuildPagesBasedOnCravingSelection() {
    // Rebuild pages list based on whether user had cravings or not
    if (moodFilledData.anyCravingToday == 2) {
      // User selected "No cravings at all" - remove the crave times page
      pages = [
        _basePagesTemplate[0],
        // MoodFeeling
        _basePagesTemplate[1],
        // MoodAffecting
        _basePagesTemplate[2],
        // MoodCravings
        _basePagesTemplate[4],
        // MoodReflectTimes (skip index 3 which is MoodCraveTimes)
      ];
    } else {
      // User had cravings - include all pages
      pages = List.from(_basePagesTemplate);
    }
    update();
  }

  double _getProgressWidth() {
    // Simple progress calculation based on current active pages
    if (pages.isEmpty) return 0.0;

    double progress = (currentPage + 1) / pages.length;
    // Ensure progress doesn't exceed 1.0
    progress = progress.clamp(0.0, 1.0);

    // Calculate width and ensure it doesn't exceed container width
    double calculatedWidth = progress * 315.w;
    return calculatedWidth.clamp(0.0, 315.w);
  }

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
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _getProgressWidth(),
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
            bool isSelected = selectedMoodAffectingIndices.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedMoodAffectingIndices.contains(index)) {
                  // Deselect if already selected
                  selectedMoodAffectingIndices.remove(index);
                } else {
                  // Select if not selected
                  selectedMoodAffectingIndices.add(index);
                }

                // Update moodFilledData with all selected items
                List<Map<String, dynamic>> selectedItems =
                    selectedMoodAffectingIndices
                        .map((i) => moodAffectingPairs[i].toJson())
                        .toList();
                moodFilledData =
                    moodFilledData.copyWith(moodAffecting: selectedItems);

                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.w,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.transparent,
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

                        // If user selected "No cravings at all", set empty craving timing
                        if (index == 2) {
                          moodFilledData =
                              moodFilledData.copyWith(craveTiming: []);
                          // Also clear any previously selected crave times
                          selectedCraveTimesIndices.clear();
                        }

                        // Rebuild pages based on craving selection
                        _rebuildPagesBasedOnCravingSelection();
                      }
                      getCurrentPageStatus();
                    },
                    child: Container(
                      width: 298.w,
                      padding: EdgeInsets.symmetric(vertical: 22.w),
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple.shade100
                              : Color(0xffF4F4F4),
                          border: isSelected
                              ? Border.all(color: Colors.deepPurple, width: 2)
                              : null,
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
                                  color: nicotrackBlack1),
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
            bool isSelected = selectedCraveTimesIndices.contains(index);

            return GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (selectedCraveTimesIndices.contains(index)) {
                  // Deselect if already selected
                  selectedCraveTimesIndices.remove(index);
                } else {
                  // Select if not selected
                  selectedCraveTimesIndices.add(index);
                }

                // Update moodFilledData with all selected items
                List<Map<String, dynamic>> selectedItems =
                    selectedCraveTimesIndices
                        .map((i) => craveTimesPairs[i].toJson())
                        .toList();
                moodFilledData =
                    moodFilledData.copyWith(craveTiming: selectedItems);

                getCurrentPageStatus();
              },
              child: AnimatedContainer(
                height: 176.w,
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple.shade100
                      : Colors.transparent,
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
    // Move to the previous page
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle the case when reaching the first page
      print("At first page!");
    }
  }

  void goToNextPage(int page) {
    currentPage = page;
    update();
  }

  Widget continueButton(DateTime currentDateTime, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentPageDoneStatus) {
          HapticFeedback.mediumImpact();
          if (currentPage == (pages.length - 1)) {
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
    // Check completion status based on current page type rather than index
    if (currentPage < pages.length) {
      Widget currentPageWidget = pages[currentPage];

      if (currentPageWidget is MoodFeeling) {
        currentPageDoneStatus = moodFilledData.selfFeeling.isNotEmpty;
      } else if (currentPageWidget is MoodAffecting) {
        currentPageDoneStatus = moodFilledData.moodAffecting.isNotEmpty;
      } else if (currentPageWidget is MoodCravings) {
        currentPageDoneStatus = moodFilledData.anyCravingToday != -1;
      } else if (currentPageWidget is MoodCraveTimes) {
        currentPageDoneStatus = moodFilledData.craveTiming.isNotEmpty;
      } else if (currentPageWidget is MoodReflectTimes) {
        currentPageDoneStatus = true; // Note page is always considered complete
      } else {
        currentPageDoneStatus = false;
      }
    } else {
      currentPageDoneStatus = false;
    }
    update();
  }

  void addDatatoHiveandNavigate(
      DateTime currentDateTime, BuildContext context) async {
    String moodStringToday = DateFormat.yMMMd().format(currentDateTime);
    final box = Hive.box<MoodModel>('moodData');
    await box.put(moodStringToday, moodFilledData);
    if (context.mounted) {
      // Good practice: check if the widget is still in the tree
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MoodDetailScreen(
              selectedDate: currentDateTime,
              routeSource: MoodDetailRouteSource.afterMoodCompletion,
            ),
          ),
          (route) => false);
    }
  }
}