import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';
import 'package:nicotrack/screens/home/did-you-smoke/didyousmoke-main-slider.dart';
import 'package:nicotrack/screens/home/mood/mood-main-slider.dart';
import 'package:nicotrack/screens/mood/mood-detail-screen.dart';
import 'package:nicotrack/screens/smoking/smoking-detail-screen.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../screens/elements/textAutoSize.dart';
import 'package:nicotrack/models/mood-model/mood-model.dart';
import 'package:hive/hive.dart';
import 'package:nicotrack/models/onboarding-data/onboardingData-model.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';
import 'package:nicotrack/models/did-you-smoke/didyouSmoke-model.dart';
import 'package:nicotrack/models/quick-actions-model/quickActions-model.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final double itemWidth = 70;
  int selectedDateIndex = 6;
  late List<DateTime> last7Days;
  final int initialIndex = 6; // Today is the last item
  bool isQuickActionsExpanded = false;
  int daysSinceLastSmoked = 0;
  int totalMoneySaved = 0;
  int hoursRegainedinLife = 0;
  int cigarettesAvoided = 0;
  double animationMultiplier =1; // Default is usually 1.0
  // Date variables
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  List<String> quickActionsList = [
    "Remove all 🚬cigarettes, 🔥 lighters & ashtrays from your home",
    "Replace 🚬 smoking with a new habit(e.g., chewing gum, 🫁 deep breathing)",
    "Identify your biggest triggers 🎯 and avoid them",
    "Log ✍️ any cravings and how you overcame them"
  ];

  OnboardingData currentDateOnboardingData = OnboardingData();
  QuickactionsModel quickActionsModel = QuickactionsModel();

  @override
  void onInit() {
    super.onInit();
    // Wait until after UI builds to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final offset = scrollController.position.maxScrollExtent;
      if (scrollController.hasClients) {
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      }
    });
    resetHomeGridValues();
    setCurrentFilledData();
    setQuickActionsData();
    HapticFeedback.mediumImpact();
  }

  void initializeCalendar() {
    // Scroll to today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(selectedDateIndex * itemWidth);
    });
  }

  /// 👇 This is your inline mini calendar widget
  Widget weeklyCalendarView(BuildContext context) {
    final today = DateTime.now();
    last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    if (last7Days.isNotEmpty &&
        selectedDateIndex >= 0 &&
        selectedDateIndex < last7Days.length) {
      final initialSelectedDate = last7Days[selectedDateIndex];
      selectedYear = initialSelectedDate.year;
      selectedMonth = initialSelectedDate.month;
      selectedDay = initialSelectedDate.day;
    }

    return SizedBox(
      height: getDynamicHeightWeeklyCalendar(context),
      child: ListView.builder(
        controller: scrollController,
        itemCount: last7Days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final date = last7Days[index];
          final isSelected = (index == selectedDateIndex);
          bool isToday = (DateFormat.yMMMd().format(date) ==
              DateFormat.yMMMd().format(DateTime.now()));
          return GestureDetector(
            onTap: () {
              selectedDateIndex = index;
              // When an item is tapped, 'date' here is the DateTime object for that item
              final tappedDate = last7Days[
                  index]; // Or simply use 'date' directly from the itemBuilder scope

              selectedYear = tappedDate.year;
              selectedMonth = tappedDate.month; // month is 1-12
              selectedDay = tappedDate.day;
              resetHomeGridValues();
              update();
            },
            child: Container(
              // width: itemWidth,
              margin: EdgeInsets.only(
                  right: index == (last7Days.length - 1) ? 24.w : 0,
                  left: index == 0 ? 24.w : 0),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextAutoSize(
                    DateFormat.E().format(date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: circularMedium,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? nicotrackBlack1
                                : nicotrackBlack1.withOpacity(0.37)),
                  ),
                  SizedBox(height: 2.h),
                  TextAutoSize(
                    '${date.day}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 21.sp,
                        fontFamily: circularMedium,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? nicotrackBlack1
                                : nicotrackBlack1.withOpacity(0.37)),
                  ),
                  SizedBox(height: 2.h),
                  TextAutoSize(
                    DateFormat.MMM().format(date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: circularMedium,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? nicotrackBlack1
                                : nicotrackBlack1.withOpacity(0.37)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget homeGridView() {
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
            value: daysSinceLastSmoked.toString(),
            label: 'Days since\nlast smoked',
            backgroundColor: const Color(0xFFB0F0A1), // green-ish background
          ),
          statCard(
            emoji: moneyEmoji,
            value: totalMoneySaved,
            label: 'Money saved',
            isCost: true,
          ),
          statCard(
            emoji: heartEmoji,
            value: hoursRegainedinLife,
            label: 'Hours regained\nin life',
            isCost: false,
          ),
          statCard(
            emoji: clapEmoji,
            value: cigarettesAvoided,
            label: 'Cigarettes\nnot smoked',
            isCost: false,
          ),
        ],
      ),
    );
  }

  Widget mainCard({
    required String emoji,
    required String value,
    required String label,
    Color? backgroundColor,
  }) {
    return Container(
      height: 106.h,
      width: 186.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        image:
            DecorationImage(image: AssetImage(homeMainBG), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            emoji,
            width: 51.w,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFlipCounter(
                  wholeDigits: 2,
                  // 👈 forces two digits to be shown & flip
                  duration: Duration(milliseconds: 1250),
                  value: daysSinceLastSmoked,
                  fractionDigits: 0,
                  // No decimal
                  textStyle: TextStyle(
                      fontSize: 33.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1)),
              TextAutoSize(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 12.5.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statCard({
    required String emoji,
    required int value,
    required String label,
    required bool isCost,
    Color? backgroundColor,
  }) {
    return Container(
      // height: 106.h,
      width: 186.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            emoji,
            width: 51.w,
          ),
          // SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFlipCounter(
                  prefix: isCost ? '\$' : '',
                  // 👈 add dollar sign here (escaped with backslash)
                  wholeDigits: 2,
                  // 👈 forces two digits to be shown & flip
                  duration: Duration(milliseconds: 1250),
                  value: value,
                  fractionDigits: 0,
                  // No decimal
                  textStyle: TextStyle(
                      fontSize: 33.sp,
                      fontFamily: circularBold,
                      color: nicotrackBlack1)),
              TextAutoSize(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                    height: 1.1,
                    fontSize: 12.5.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyTasksSection(BuildContext context) {
    return Builder(builder: (context) {
      DateTime todayDate = DateTime.now();
      DateTime currentSelectedDateTime =
          DateTime(selectedYear, selectedMonth, selectedDay);
      String currentDate = DateFormat.yMMMd().format(currentSelectedDateTime);
      final moodBox = Hive.box<MoodModel>(
          'moodData'); // Specify the type of values in the box
      final didYouSmokebox = Hive.box<DidYouSmokeModel>(
          'didYouSmokeData'); // Specify the type of values in the box
      MoodModel? capturedData = moodBox.get(currentDate);
      DidYouSmokeModel? smokedcapturedData = didYouSmokebox.get(currentDate);
      bool isSmokedToday = false;
      bool isMoodDone = false;
      if (capturedData != null) {
        if (capturedData.selfFeeling.isNotEmpty) {
          isMoodDone = true;
        }
      }
      if (smokedcapturedData != null) {
        if (smokedcapturedData.hasSmokedToday != -1) {
          isSmokedToday = true;
        }
      }
      int moodPoints = isMoodDone ? 1 : 0;
      int smokedPoints = isSmokedToday
          ? 1
          : 0; // Or based on your specific logic for this part
      int numberofCompletedDaily = moodPoints + smokedPoints;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextAutoSize(
                    "Daily Tasks",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        height: 1.1,
                        fontSize: 18.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 8.h,
                        width: 62.w,
                        margin: EdgeInsets.only(bottom: 1.h),
                        decoration: BoxDecoration(
                          color: nicotrackGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              height: 8.h,
                              width: (numberofCompletedDaily / 2) * 62.w,
                              decoration: BoxDecoration(
                                color: nicotrackGreen,
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      TextAutoSize(
                        "$numberofCompletedDaily/2",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            height: 1.1,
                            fontSize: 13.sp,
                            fontFamily: circularBook,
                            color: Color(0xff404040)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.w,
            ),
            GestureDetector(
              onTap: () {
                if (!isSmokedToday) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DidYouSmokeMainSlider(
                      currentDateTime: currentSelectedDateTime,
                    );
                  }));
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SmokingDetailScreen(
                        selectedDate: currentSelectedDateTime);
                  }));
                }
              },
              child: dailyTaskBox(
                  emoji: isSmokedToday ? clappingEmoji : moodEmoji,
                  emojiColor: Color(0xffdfbba8).withOpacity(0.59),
                  titleTxt: isSmokedToday
                      ? 'Smoking Status ✅'
                      : 'Did you smoke today?',
                  subTitle: isSmokedToday
                      ? 'Thanks for the update! 👍'
                      : 'Let us know if you did 😌',
                  isCompleted: isSmokedToday),
            ),
            SizedBox(
              height: 7.h,
            ),
            GestureDetector(
              onTap: () {
                if (!isMoodDone) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MoodMainSlider(
                        currentDateTime: currentSelectedDateTime);
                  }));
                } else {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MoodDetailScreen(
                        selectedDate: currentSelectedDateTime,
                        routeSource: MoodDetailRouteSource.fromHome);
                  }));
                }
              },
              child: dailyTaskBox(
                  emoji: isMoodDone ? kheartEmoji : paperEmoji,
                  emojiColor: Color(0xffEBE8FB).withOpacity(0.53),
                  titleTxt:
                      isMoodDone ? 'Mood Recorded ✅' : 'How do you feel today?',
                  subTitle: isMoodDone
                      ? 'Your mood for today is set 📝'
                      : 'Tap to tell us about your mood 📝',
                  isCompleted: isMoodDone),
            ),
            SizedBox(
              height: 7.h,
            ),
            quickActions()
          ],
        ),
      );
    });
  }

  Widget dailyTaskBox(
      {required String emoji,
      required Color emojiColor,
      required String titleTxt,
      required String subTitle,
      required bool isCompleted}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        // height: 86.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.r),
            border: Border.all(
              width: 1,
              color: const Color(0xFFEFEFEF),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 12.w,
            ),
            Container(
              width: 61.w,
              height: 60.w,
              decoration: BoxDecoration(
                  color: isCompleted
                      ? nicotrackGreen.withOpacity(0.15)
                      : emojiColor,
                  borderRadius: BorderRadius.circular(11.r)),
              child: Center(
                child: Image.asset(
                  emoji,
                  width: 34.w,
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextAutoSize(
                  titleTxt,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 15.sp,
                      fontFamily: circularBold,
                      color: Colors.black.withOpacity(0.76)),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextAutoSize(subTitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 14.sp,
                      fontFamily: circularBook,
                      color: Color(0xffBCB6D8),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget quickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.r),
            border: Border.all(
              width: 1,
              color: const Color(0xFFEFEFEF),
            )),
        child: ExpansionTile(
          trailing: AnimatedRotation(
            turns: isQuickActionsExpanded ? 0.5 : 0.0,
            // 180 degrees when expanded
            duration: Duration(milliseconds: 200),
            child: Icon(
              FeatherIcons.chevronDown,
              size: 22.sp,
              color: nicotrackBlack1,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.r)),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          initiallyExpanded: true,
          tilePadding: EdgeInsets.only(right: 19.w, top: 6.h, bottom: 6.h),
          childrenPadding: EdgeInsets.only(bottom: 14.h),
          onExpansionChanged: (expanded) {
            isQuickActionsExpanded = expanded;
            update();
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 12.w,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SleekCircularSlider(
                    min: 0,
                    max: 100,
                    initialValue:
                        (countTrueActions(quickActionsModel) / 4) * 100,
                    // value to control how much of the circle is filled
                    appearance: CircularSliderAppearance(
                      animationEnabled: true,
                      customWidths: CustomSliderWidths(
                        trackWidth: 5.w,
                        progressBarWidth: 5.w,
                        handlerSize: 0, // no handler knob
                      ),
                      customColors: CustomSliderColors(
                        trackColor: nicotrackGreen.withOpacity(0.2),
                        progressBarColor: nicotrackGreen,
                        hideShadow: true,
                      ),
                      size: 55.w,
                      startAngle: 270,
                      angleRange: 360,
                      animDurationMultiplier: animationMultiplier,
                      infoProperties: InfoProperties(
                        modifier: (value) => '', // Hide value text
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.checkmark_alt,
                    color: nicotrackGreen,
                    weight: 12,
                    size: 26.sp,
                  )
                ],
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAutoSize('Quick Actions',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 15.5.sp,
                        fontFamily: circularBold,
                        color: nicotrackBlack1,
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  TextAutoSize('${countTrueActions(quickActionsModel)}/4',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 16.sp,
                        fontFamily: circularBook,
                        color: const Color(0x82A1A1A1),
                      )),
                ],
              ),
            ],
          ),
          children: List.generate(quickActionsList.length, (index) {
            return GestureDetector(
              onTap: () {
                toggleAction(index);
              },
              child: Container(
                  margin: EdgeInsets.only(left: 20.h, bottom: 12.sp),
                  child: Builder(builder: (context) {
                    bool isSelected = isActionDone(index);
                    return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 18.w,
                            height: 18.w,
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? nicotrackGreen
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: isSelected
                                        ? nicotrackGreen
                                        : Colors.black12,
                                    width: 2.sp)),
                            child: Icon(
                              CupertinoIcons.checkmark_alt,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              size: 14.w,
                            ),
                          ),
                          SizedBox(
                            width: 18.w,
                          ),
                          SizedBox(
                            width: 264.w,
                            child: TextAutoSize(quickActionsList[index],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 1.1,
                                  fontSize: 13.sp,
                                  fontFamily: circularBook,
                                  color: Colors.black87,
                                )),
                          ),
                        ]);
                  })),
            );
          }),
        ),
      ),
    );
  }

  Widget peronalizedQuitRoutine() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          homePlanBg,
          width: 260.w,
        ),
        SizedBox(
          width: 260.w,
          height: 75.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 18.w,
              ),
              Image.asset(
                coffeeEmoji,
                width: 48.w,
              ),
              SizedBox(
                width: 14.w,
              ),
              TextAutoSize('Personalized\nQuit Routine',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 18.sp,
                    fontFamily: circularBold,
                    color: Colors.black87,
                  )),
              SizedBox(
                width: 11.w,
              ),
              Icon(
                FeatherIcons.chevronRight,
                size: 26.sp,
                color: nicotrackBlack1,
              ),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void resetHomeGridValues() {
    DateTime currentDateTime =
        DateTime(selectedYear, selectedMonth, selectedDay);
    int unsmokedDays = 0;
    double moneySavedsoFar = 0;
    double hoursRegained = 0;
    int cigarettesAvoided = 0;
    unsmokedDays = getDaysSinceLastSmoked(currentDateTime);
    moneySavedsoFar = getMoneySaved(currentDateTime);
    hoursRegained = getdaysOfLifeRegained(currentDateTime);
    cigarettesAvoided = getcigarettesNotSmoked(currentDateTime);

    Future.delayed(Duration(milliseconds: 0), () {
      setDaysSinceLastSmoked(unsmokedDays);
    });
    Future.delayed(Duration(milliseconds: 0), () {
      setMoneySaved(moneySavedsoFar);
    });
    Future.delayed(Duration(milliseconds: 0), () {
      setHoursRegainedinLife(hoursRegained);
    });
    Future.delayed(Duration(milliseconds: 0), () {
      setCigarettesAvoided(cigarettesAvoided);
    });

    update();
  }

  void setDaysSinceLastSmoked(int days) {
    daysSinceLastSmoked = days;
    update();
  }

  void setMoneySaved(double moneySaved) {
    totalMoneySaved = moneySaved.toInt();
    update();
  }

  void setHoursRegainedinLife(double hoursRegained) {
    hoursRegainedinLife = (hoursRegained * 24).toInt();
    update();
  }

  void setCigarettesAvoided(int noofcigs) {
    cigarettesAvoided = noofcigs;
    update();
  }

  void setCurrentFilledData() {
    DateTime currentDateTime =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final onboardingBox = Hive.box<OnboardingData>(
        'onboardingCompletedData'); // Specify the type of values in the box
    OnboardingData userOnboardingData =
        onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
    currentDateOnboardingData = userOnboardingData;
    update();
  }

  void setQuickActionsData() {
    DateTime currentDateTime =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final quickActionBox = Hive.box<QuickactionsModel>(
        'quickActionsData'); // Specify the type of values in the box
    QuickactionsModel quickActionsData =
        quickActionBox.get('currentUserActions') ?? QuickactionsModel();
    quickActionsModel = quickActionsData;
    update();
  }

  int countTrueActions(QuickactionsModel actions) {
    int count = 0;
    if (actions.firstActionDone) {
      count++;
    }
    if (actions.secondActionDone) {
      count++;
    }
    if (actions.thirdActionDone) {
      count++;
    }
    if (actions.fourthActionDone) {
      count++;
    }
    return count;
  }

  void toggleAction(int actionNumber) async {
    String quickActionsStringToday = "currentUserActions";
    final box = Hive.box<QuickactionsModel>('quickActionsData');
    switch (actionNumber) {
      case 0:
        quickActionsModel = quickActionsModel.copyWith(
            firstActionDone: !quickActionsModel.firstActionDone);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 1:
        quickActionsModel = quickActionsModel.copyWith(
            secondActionDone: !quickActionsModel.secondActionDone);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 2:
        quickActionsModel = quickActionsModel.copyWith(
            thirdActionDone: !quickActionsModel.thirdActionDone);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 3:
        quickActionsModel = quickActionsModel.copyWith(
            fourthActionDone: !quickActionsModel.fourthActionDone);
        await box.put(quickActionsStringToday, quickActionsModel);
      default:
        quickActionsModel = quickActionsModel.copyWith(
            firstActionDone: !quickActionsModel.firstActionDone);
        await box.put(quickActionsStringToday, quickActionsModel);
    }
    setQuickActionsData();
    update();
  }

  bool isActionDone(index) {
    switch (index) {
      case 0:
        return quickActionsModel.firstActionDone;
      case 1:
        return quickActionsModel.secondActionDone;

      case 2:
        return quickActionsModel.thirdActionDone;

      case 3:
        return quickActionsModel.fourthActionDone;

      default:
        return quickActionsModel.firstActionDone;
    }
    update();
  }
}