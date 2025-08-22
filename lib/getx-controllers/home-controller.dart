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
import 'package:nicotrack/models/award-model/award-model.dart';
import 'package:nicotrack/screens/home/did-you-smoke/didyousmoke-main-slider.dart';
import 'package:nicotrack/screens/home/mood/mood-main-slider.dart';
import 'package:nicotrack/screens/mood/mood-detail-screen.dart';
import 'package:nicotrack/screens/smoking/smoking-detail-screen.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../services/firebase-service.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/screens/premium/premium-paywall-screen.dart';

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
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/services/mood-usage-service.dart';

enum DailyTaskType { mood, smoking }

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
  double animationMultiplier = 1; // Default is usually 1.0
  // Date variables
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  // Quick actions list will be populated from translations
  List<String> quickActionsList = [];

  OnboardingData currentDateOnboardingData = OnboardingData();
  QuickactionsModel quickActionsModel = QuickactionsModel();

  @override
  void onInit() {
    super.onInit();
    // Wait until after UI builds to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final offset = scrollController.position.maxScrollExtent;
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      }
    });
    resetHomeGridValues();
    setCurrentFilledData();
    setQuickActionsData();
    HapticFeedback.mediumImpact();
  }

  void initializeQuickActions(BuildContext context) {
    quickActionsList = [
      context.l10n.quick_action_remove_cigarettes,
      context.l10n.quick_action_replace_habit,
      context.l10n.quick_action_identify_triggers,
      context.l10n.quick_action_log_cravings,
    ];
  }

  void initializeCalendar() {
    // Scroll to today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(selectedDateIndex * itemWidth);
    });
  }

  /// Helper function to get localized short weekday name
  String getLocalizedWeekdayShort(BuildContext context, DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return context.l10n.monday_short;
      case DateTime.tuesday:
        return context.l10n.tuesday_short;
      case DateTime.wednesday:
        return context.l10n.wednesday_short;
      case DateTime.thursday:
        return context.l10n.thursday_short;
      case DateTime.friday:
        return context.l10n.friday_short;
      case DateTime.saturday:
        return context.l10n.saturday_short;
      case DateTime.sunday:
        return context.l10n.sunday_short;
      default:
        return context.l10n.monday_short;
    }
  }

  /// Helper function to get localized month name
  String getLocalizedMonth(BuildContext context, DateTime date) {
    switch (date.month) {
      case 1:
        return context.l10n.january;
      case 2:
        return context.l10n.february;
      case 3:
        return context.l10n.march;
      case 4:
        return context.l10n.april;
      case 5:
        return context.l10n.may;
      case 6:
        return context.l10n.june;
      case 7:
        return context.l10n.july;
      case 8:
        return context.l10n.august;
      case 9:
        return context.l10n.september;
      case 10:
        return context.l10n.october;
      case 11:
        return context.l10n.november;
      case 12:
        return context.l10n.december;
      default:
        return context.l10n.january;
    }
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
              HapticFeedback.lightImpact();
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
                    getLocalizedWeekdayShort(context, date),
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
                    getLocalizedMonth(context, date),
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

  Widget homeGridView({
    required BuildContext context,
    required String daysSinceLabel,
    required String moneySavedLabel,
    required String hoursRegainedLabel,
    required String cigarettesNotSmokedLabel,
  }) {
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
            context: context,
            emoji: bicepsEmoji,
            value: daysSinceLastSmoked.toString(),
            label: daysSinceLabel,
            backgroundColor: const Color(0xFFB0F0A1), // green-ish background
          ),
          statCard(
            context: context,
            emoji: moneyEmoji,
            value: totalMoneySaved,
            label: moneySavedLabel,
            isCost: true,
          ),
          statCard(
            context: context,
            emoji: heartEmoji,
            value: hoursRegainedinLife,
            label: hoursRegainedLabel,
            isCost: false,
          ),
          statCard(
            context: context,
            emoji: clapEmoji,
            value: cigarettesAvoided,
            label: cigarettesNotSmokedLabel,
            isCost: false,
          ),
        ],
      ),
    );
  }

  Widget mainCard({
    required BuildContext context,
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
            width: 48.w,
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
              SizedBox(
                width: 80.w,
                child: TextAutoSize(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 12.5.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget statCard({
    required BuildContext context,
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
            width: 48.w,
          ),
          // SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedFlipCounter(
                  prefix: isCost
                      ? Get.find<AppPreferencesController>().currencySymbol
                      : '',
                  // 👈 add currency symbol dynamically
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
              SizedBox(
                width: 90.w,
                child: TextAutoSize(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      height: 1.1,
                      fontSize: 12.5.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyTasksSection({
    required BuildContext context,
    required bool isUserPremium,
    required String dailyTasksLabel,
    required String smokingStatusDone,
    required String didYouSmokeToday,
    required String thanksForUpdate,
    required String letUsKnow,
    required String moodRecorded,
    required String howDoYouFeel,
    required String moodSet,
    required String tapToTellMood,
    required String quickActionsLabel,
  }) {
    // Initialize quick actions with translations
    if (quickActionsList.isEmpty) {
      initializeQuickActions(context);
    }
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
                    dailyTasksLabel,
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
                HapticFeedback.mediumImpact();
                // Smoking task is always available (no lock), so proceed normally
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
                  titleTxt:
                      isSmokedToday ? smokingStatusDone : didYouSmokeToday,
                  subTitle: isSmokedToday ? thanksForUpdate : letUsKnow,
                  isCompleted: isSmokedToday,
                  isUserPremium: isUserPremium,
                  taskType: DailyTaskType.smoking),
            ),
            SizedBox(
              height: 7.h,
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                // Check if user can use mood feature
                bool canUseMood = MoodUsageService.canUseMoodFeature();

                if (!canUseMood) {
                  // User has exceeded free usage limit, show premium screen
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const PremiumPaywallScreen();
                  }));
                } else {
                  // User can use mood feature (either premium or within free limit)
                  if (!isMoodDone) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MoodMainSlider(
                          currentDateTime: currentSelectedDateTime);
                    }));
                  } else {
                    // If mood is already done for today, allow viewing details
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MoodDetailScreen(
                          selectedDate: currentSelectedDateTime,
                          routeSource: MoodDetailRouteSource.fromHome);
                    }));
                  }
                }
              },
              child: dailyTaskBox(
                  emoji: isMoodDone ? kheartEmoji : paperEmoji,
                  emojiColor: Color(0xffEBE8FB).withOpacity(0.53),
                  titleTxt: isMoodDone ? moodRecorded : howDoYouFeel,
                  subTitle: isMoodDone ? moodSet : tapToTellMood,
                  isCompleted: isMoodDone,
                  isUserPremium: isUserPremium,
                  taskType: DailyTaskType.mood),
            ),
            SizedBox(
              height: 7.h,
            ),
            quickActions(
              context: context,
              label: quickActionsLabel,
            )
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
      required bool isCompleted,
      required bool isUserPremium,
      required DailyTaskType taskType}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            Container(
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
                      SizedBox(
                        width: 200.w,
                        child: TextAutoSize(subTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 1.1,
                              fontSize: 14.sp,
                              fontFamily: circularBook,
                              color: Color(0xffBCB6D8),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
            // Show lock box if user cannot use mood feature
            taskType == DailyTaskType.mood &&
                    !MoodUsageService.canUseMoodFeature()
                ? Positioned(top: 10.w, right: 10.w, child: smallLockBox())
                : SizedBox.shrink()
          ],
        ));
  }

  Widget quickActions({
    required BuildContext context,
    required String label,
  }) {
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
            HapticFeedback.lightImpact();
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
                  TextAutoSize(label,
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
                HapticFeedback.lightImpact();
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

  Widget emergencyCravingButton({
    required BuildContext context,
    required String label,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          emergencyCravingHomeBtn,
          width: 260.w,
        ),
        SizedBox(
          width: 260.w,
          // height: 75.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 18.w,
              ),
              // Image.asset(
              //   coffeeEmoji,
              //   width: 48.w,
              TextAutoSize('📟',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 50.sp,
                    fontFamily: circularBold,
                    color: Colors.black87,
                  )),
              SizedBox(
                width: 8.w,
              ),
              SizedBox(
                width: 145.w,
                child: TextAutoSize(label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 18.sp,
                      fontFamily: circularBold,
                      color: Colors.black87,
                    )),
              ),

              SizedBox(
                width: 11.w,
              ),
              // Icon(
              //   FeatherIcons.chevronRight,
              //   size: 26.sp,
              //   color: nicotrackBlack1,
              // ),
              // SizedBox(
              //   width: 16.w,
              // ),
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
    
    // Check if box is open before accessing
    if (Hive.isBoxOpen('onboardingCompletedData')) {
      final onboardingBox = Hive.box<OnboardingData>(
          'onboardingCompletedData'); // Specify the type of values in the box
      OnboardingData userOnboardingData =
          onboardingBox.get('currentUserOnboarding') ?? OnboardingData();
      currentDateOnboardingData = userOnboardingData;
    } else {
      // If box is not open yet, set default model
      currentDateOnboardingData = OnboardingData();
    }
    update();
  }

  void setQuickActionsData() {
    DateTime currentDateTime =
        DateTime(selectedYear, selectedMonth, selectedDay);
    // Check if box is open before accessing
    if (Hive.isBoxOpen('quickActionsData')) {
      final quickActionBox = Hive.box<QuickactionsModel>(
          'quickActionsData'); // Specify the type of values in the box
      QuickactionsModel quickActionsData =
          quickActionBox.get('currentUserActions') ?? QuickactionsModel();
      quickActionsModel = quickActionsData;
    } else {
      // If box is not open yet, set default model
      quickActionsModel = QuickactionsModel();
    }
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

    // Track the current state for analytics
    bool newState = false;
    String actionText = quickActionsList.length > actionNumber
        ? quickActionsList[actionNumber]
        : "unknown_action";

    switch (actionNumber) {
      case 0:
        newState = !quickActionsModel.firstActionDone;
        quickActionsModel =
            quickActionsModel.copyWith(firstActionDone: newState);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 1:
        newState = !quickActionsModel.secondActionDone;
        quickActionsModel =
            quickActionsModel.copyWith(secondActionDone: newState);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 2:
        newState = !quickActionsModel.thirdActionDone;
        quickActionsModel =
            quickActionsModel.copyWith(thirdActionDone: newState);
        await box.put(quickActionsStringToday, quickActionsModel);
      case 3:
        newState = !quickActionsModel.fourthActionDone;
        quickActionsModel =
            quickActionsModel.copyWith(fourthActionDone: newState);
        await box.put(quickActionsStringToday, quickActionsModel);
      default:
        newState = !quickActionsModel.firstActionDone;
        quickActionsModel =
            quickActionsModel.copyWith(firstActionDone: newState);
        await box.put(quickActionsStringToday, quickActionsModel);
    }

    // Log analytics event
    FirebaseService().logQuickActionToggled(
      actionNumber: actionNumber,
      actionText: actionText,
      completed: newState,
    );

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

  // Get latest achieved milestone image
  Widget getLatestMilestoneImage() {
    int currentDays = getDaysSinceLastSmoked(DateTime.now());
    List<AwardModel> earnedBadges = allAwards.where((badge) => badge.day <= currentDays).toList();
    
    if (earnedBadges.isNotEmpty) {
      // Get the latest (highest day) milestone
      AwardModel latestMilestone = earnedBadges.reduce((a, b) => a.day > b.day ? a : b);
      return Image.asset(
        latestMilestone.emojiImg,
        width: 28.w,
        height: 28.w,
        fit: BoxFit.contain,
      );
    } else {
      // No milestones achieved yet - show a default icon
      return Icon(
        Icons.emoji_events_outlined,
        size: 24.w,
        color: nicotrackOrange,
      );
    }
  }

  // Build milestone grid for bottom sheet using plan screen UI pattern
  Widget buildMilestoneGrid(BuildContext context) {
    int currentDays = getDaysSinceLastSmoked(DateTime.now());
    List<AwardModel> earnedBadges = allAwards.where((badge) => badge.day <= currentDays).toList();
    List<AwardModel> nextMilestones = allAwards.where((badge) => badge.day > currentDays).toList();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Earned badges section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: nicotrackBlack1,
                  borderRadius: BorderRadius.circular(24.r)
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: circularBold,
                      height: 1.1,
                      color: Colors.white
                    ),
                    children: [
                      TextSpan(
                        text: "🪙  Earned Badges (${earnedBadges.length})",
                      ),
                    ]
                  )
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (earnedBadges.isNotEmpty)
            _buildThreexGridView(earnedBadges, context)
          else
            Container(
              padding: EdgeInsets.all(24.w),
              child: Text(
                "Your first badge will be unlocked at day ${allAwards.first.day}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularMedium,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 12.h),
          
          // Next milestones section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: nicotrackBlack1,
                  borderRadius: BorderRadius.circular(24.r)
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: circularBold,
                      height: 1.1,
                      color: Colors.white
                    ),
                    children: [
                      TextSpan(
                        text: "📆  Next Milestones",
                      ),
                    ]
                  )
                ),
              ),
            ],
          ),
          SizedBox(height: 0.w),
          if (nextMilestones.isNotEmpty)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.saturation, // Removes color = grayscale
              ),
              child: _buildThreexGridView(nextMilestones, context)
            )
          else
            Container(
              padding: EdgeInsets.all(24.w),
              child: Text(
                "Congratulations! You've earned all badges!",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: circularMedium,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  // Build the same grid view as used in plan screen
  Widget _buildThreexGridView(List<AwardModel> awardsList, BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.7,
      ),
      itemCount: awardsList.length,
      itemBuilder: (context, index) {
        final item = awardsList[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  hexaPolygon,
                  width: 105.w,
                ),
                Image.asset(
                  item.emojiImg,
                  width: 58.w,
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildGradientText(
              text: "Day ${item.day}",
              fontSize: 14.sp,
              fontFamily: circularBold,
            ),
          ],
        );
      },
    );
  }

  // Build gradient text like in plan screen
  Widget _buildGradientText({
    required String text,
    required double fontSize,
    required String fontFamily,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFFFF6B35), // nicotrackOrange
          Color(0xFFFF8C00), // Slightly different orange
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          color: Colors.white, // This will be masked by the gradient
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}