import 'dart:ui';
import 'package:dotted_line/dotted_line.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';
import 'package:nicotrack/screens/elements/gradient-text.dart';
import 'package:nicotrack/screens/elements/info-bottom-sheet.dart';
import 'package:nicotrack/screens/premium/reusables/premium-widgets.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';
import '../extensions/app_localizations_extension.dart';

import '../constants/font-constants.dart';
import '../models/timeline-item-model/timelineItem-model.dart';
import '../screens/elements/textAutoSize.dart';
import '../screens/premium/premium-paywall-screen.dart';
import 'premium-controller.dart';

class PlanController extends GetxController {
  int tabIndex = 0;
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool isBottomSheetOn = false;

  // Method to get translated timeline items
  List<TimelineItemModel> getTimelineItems(BuildContext context) => [
    TimelineItemModel(
        dayNumber: 0,
        streakNumber: 0,
        dayDuration: context.l10n.timeline_duration_first_24_hours,
        whatHappens: context.l10n.timeline_happens_first_24_hours,
        streakImg: badge1Emoji),
    TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        dayDuration: context.l10n.timeline_duration_day_2,
        whatHappens: context.l10n.timeline_happens_day_2,
        streakImg: baseballImg),
    TimelineItemModel(
        dayNumber: 3,
        streakNumber: 3,
        dayDuration: context.l10n.timeline_duration_day_3_4,
        whatHappens: context.l10n.timeline_happens_day_3_4,
        streakImg: pinataImg),
    TimelineItemModel(
        dayNumber: 5,
        streakNumber: 5,
        dayDuration: context.l10n.timeline_duration_day_5_7,
        whatHappens: context.l10n.timeline_happens_day_5_7,
        streakImg: medalImg),
    TimelineItemModel(
        dayNumber: 8,
        streakNumber: 8,
        dayDuration: context.l10n.timeline_duration_week_1_2,
        whatHappens: context.l10n.timeline_happens_week_1_2,
        streakImg: kiteImg),
    TimelineItemModel(
        dayNumber: 14,
        streakNumber: 14,
        dayDuration: context.l10n.timeline_duration_2_weeks,
        whatHappens: context.l10n.timeline_happens_2_weeks,
        streakImg: golfImg),
    TimelineItemModel(
        dayNumber: 18,
        streakNumber: 18,
        dayDuration: context.l10n.timeline_duration_2_5_weeks,
        whatHappens: context.l10n.timeline_happens_2_5_weeks,
        streakImg: dartarrowImg),
    TimelineItemModel(
        dayNumber: 21,
        streakNumber: 21,
        dayDuration: context.l10n.timeline_duration_3_weeks,
        whatHappens: context.l10n.timeline_happens_3_weeks,
        streakImg: teddyImg),
    TimelineItemModel(
        dayNumber: 28,
        streakNumber: 28,
        dayDuration: context.l10n.timeline_duration_4_weeks,
        whatHappens: context.l10n.timeline_happens_4_weeks,
        streakImg: hat2Img),
    TimelineItemModel(
        dayNumber: 35,
        streakNumber: 35,
        dayDuration: context.l10n.timeline_duration_5_weeks,
        whatHappens: context.l10n.timeline_happens_5_weeks,
        streakImg: ballrollImg),
    TimelineItemModel(
        dayNumber: 42,
        streakNumber: 42,
        dayDuration: context.l10n.timeline_duration_6_weeks,
        whatHappens: context.l10n.timeline_happens_6_weeks,
        streakImg: hatImg),
    TimelineItemModel(
        dayNumber: 50,
        streakNumber: 50,
        dayDuration: context.l10n.timeline_duration_7_weeks,
        whatHappens: context.l10n.timeline_happens_7_weeks,
        streakImg: ballImg),
    TimelineItemModel(
        dayNumber: 56,
        streakNumber: 56,
        dayDuration: context.l10n.timeline_duration_8_weeks,
        whatHappens: context.l10n.timeline_happens_8_weeks,
        streakImg: chocolateImg),
    TimelineItemModel(
        dayNumber: 65,
        streakNumber: 65,
        dayDuration: context.l10n.timeline_duration_9_10_weeks,
        whatHappens: context.l10n.timeline_happens_9_10_weeks,
        streakImg: magicbowlImg),
    TimelineItemModel(
        dayNumber: 75,
        streakNumber: 75,
        dayDuration: context.l10n.timeline_duration_10_11_weeks,
        whatHappens: context.l10n.timeline_happens_10_11_weeks,
        streakImg: crownImg),
    TimelineItemModel(
        dayNumber: 84,
        streakNumber: 84,
        dayDuration: context.l10n.timeline_duration_12_weeks,
        whatHappens: context.l10n.timeline_happens_12_weeks,
        streakImg: vacayImg),
    TimelineItemModel(
        dayNumber: 95,
        streakNumber: 95,
        dayDuration: context.l10n.timeline_duration_13_14_weeks,
        whatHappens: context.l10n.timeline_happens_13_14_weeks,
        streakImg: no1Img),
    TimelineItemModel(
        dayNumber: 105,
        streakNumber: 105,
        dayDuration: context.l10n.timeline_duration_15_weeks,
        whatHappens: context.l10n.timeline_happens_15_weeks,
        streakImg: trophyImg),
    TimelineItemModel(
        dayNumber: 112,
        streakNumber: 112,
        dayDuration: context.l10n.timeline_duration_16_weeks,
        whatHappens: context.l10n.timeline_happens_16_weeks,
        streakImg: drumrollImg),
    TimelineItemModel(
        dayNumber: 126,
        streakNumber: 126,
        dayDuration: context.l10n.timeline_duration_18_weeks,
        whatHappens: context.l10n.timeline_happens_18_weeks,
        streakImg: capImg),
    TimelineItemModel(
        dayNumber: 140,
        streakNumber: 140,
        dayDuration: context.l10n.timeline_duration_20_weeks,
        whatHappens: context.l10n.timeline_happens_20_weeks,
        streakImg: cablecarImg),
    TimelineItemModel(
        dayNumber: 154,
        streakNumber: 154,
        dayDuration: context.l10n.timeline_duration_22_weeks,
        whatHappens: context.l10n.timeline_happens_22_weeks,
        streakImg: campingImg),
    TimelineItemModel(
        dayNumber: 168,
        streakNumber: 168,
        dayDuration: context.l10n.timeline_duration_24_weeks,
        whatHappens: context.l10n.timeline_happens_24_weeks,
        streakImg: beachvacayImg),
    TimelineItemModel(
        dayNumber: 180,
        streakNumber: 180,
        dayDuration: context.l10n.timeline_duration_6_months,
        whatHappens: context.l10n.timeline_happens_6_months,
        streakImg: rocketImg),
  ];
  final ScrollController scrollController = ScrollController();
  final RxDouble scrollPosition = 0.0.obs;
  final int initialSection;

  PlanController({this.initialSection = 0});

  @override
  void onInit() {
    super.onInit();
    // Initialize the controller and add listeners here
    scrollController.addListener(_scrollListener);
    // Schedule the scroll after the layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSectionAfterLayout(initialSection);
    });
  }

  // Get current days passed since last smoke
  int getCurrentDaysPassed() {
    return getDaysSinceLastSmoked(DateTime.now());
  }

  // Determine which timeline item the user has reached based on days passed
  int getCurrentTimelineIndex(BuildContext context) {
    int daysPassed = getCurrentDaysPassed();
    final items = getTimelineItems(context);

    for (int i = items.length - 1; i >= 0; i--) {
      if (daysPassed >= items[i].dayNumber) {
        return i;
      }
    }
    return 0; // Default to first item if less than 0 days
  }

  @override
  void onClose() {
    // Clean up the controller and listeners when the controller is removed
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    scrollPosition.value = scrollController.offset;
    // Your additional logic here based on the scroll position
  }

  // You can add methods to programmatically scroll to specific positions
  void scrollToPosition(double position) {
    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Method to scroll to a specific section
  void scrollToSection(int sectionIndex) {
    double position;
    switch (sectionIndex) {
      case 0:
        position = 0.0;
        break;
      case 1:
        position = 300.0;
        break;
      case 2:
        position = 600.0;
        break;
      default:
        position = 0.0;
    }

    scrollToPosition(position);
  }

  // Method to scroll to a specific section by index
  void scrollToSectionAfterLayout(int sectionIndex) {
    // Fixed positions approach
    double position;
    switch (sectionIndex) {
      case 0:
        position = 0.0;
        break;
      case 1:
        position = 300.0;
        break;
      case 2:
        position = 600.0;
        break;
      default:
        position = 0.0;
    }

    scrollToPosition(position);
  }

  Widget timelineTab(String text, int index) {
    final isSelected = tabIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        tabIndex = index;
        update();
      },
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 200),
        style: TextStyle(
          height: 1.1,
          fontSize: 18.sp,
          fontFamily: circularBold,
          color: isSelected ? Colors.black87 : Colors.black38,
        ),
        child: Text(text),
      ),
    );
  }

  Widget withdrawalTimeline(BuildContext context) {
    return GetBuilder<PremiumController>(
        init: PremiumController(),
        builder: (premiumController) {
          return Stack(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      for (int index = 0; index < getTimelineItems(context).length; index++)
                        Column(
                          children: [
                            timelineRow(
                                timelineModelItem: getTimelineItems(context)[index],
                                index: index,
                                context: context),
                            SizedBox(
                              height: index == 0 ? 0 : 8.w,
                            ),
                            SizedBox(
                              height: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 20.w,
                                          width: 2.w,
                                          decoration: BoxDecoration(
                                            color: index ==
                                                    getTimelineItems(context).length - 1
                                                ? Colors.transparent
                                                : Color(0xffF6F4F1),
                                            borderRadius: index == 0
                                                ? BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22.w),
                                                    bottomLeft:
                                                        Radius.circular(22.w))
                                                : BorderRadius.circular(22.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        )
                    ],
                  )),
              // Calendar lock overlay covering all except first two rows
              if (!premiumController.effectivePremiumStatus)
                Positioned(
                  top: 320.w,
                  // Skip first two rows completely
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const PremiumPaywallScreen();
                      }));
                    },
                    child: ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = 0; i < 5; i++)
                                Column(
                                  children: [
                                    i == 0
                                        ? SizedBox(
                                            height: 80.w,
                                          )
                                        : SizedBox.shrink(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.1),
                                      ),
                                      child: Center(
                                        child: calendarLock(context),
                                      ),
                                    ),
                                    i == 4
                                        ? SizedBox(
                                            height: 80.w,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                )
                            ],
                          )),
                    ),
                  ),
                ),
            ],
          );
        });

    // Expanded(
    //   child: ListView.builder(
    //     padding: EdgeInsets.symmetric(horizontal: 20.w),
    //       scrollDirection: Axis.vertical,
    //       shrinkWrap: true,
    //       itemCount: timelineItems.length,
    //       itemBuilder: (context, index) {
    //         return timelineRow(timelineModelItem: timelineItems[index]);
    //       }),
    // )
  }

  Widget timelineRow(
      {required BuildContext context,
      required int index,
      required TimelineItemModel timelineModelItem}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: index == 0
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.center,
            children: [
              timelineModelItem.dayNumber == 0
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Changed from MainAxisAlignment.end
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.w,
                              width: 2.w,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(22.w),
                                    topLeft: Radius.circular(22.w)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 100.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: nicotrackBlack1,
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          child: Center(
                            child: TextAutoSize(
                              context.l10n.start_label,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: circularMedium,
                                height: 1.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // The bottom line will now be positioned at the bottom
                        Container(
                          height: 40.w,
                          width: 2.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF6F4F1),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(22.w),
                                topLeft: Radius.circular(22.w)),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextAutoSize(
                          context.l10n.day_number(
                              timelineModelItem.dayNumber.toString()),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: nicotrackBlack1,
                          ),
                        ),
                        SizedBox(
                          height: 9.w,
                        ),
                        // Apply grayscale filter to entire stack if this streak hasn't been earned yet
                        index > getCurrentTimelineIndex(context)
                            ? ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.saturation, // Removes color = grayscale
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      iconPolygon,
                                      width: 100.w,
                                    ),
                                    Image.asset(
                                      timelineModelItem.streakImg,
                                      width: 54.w,
                                    )
                                  ],
                                ),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    iconPolygon,
                                    width: 100.w,
                                  ),
                                  Image.asset(
                                    timelineModelItem.streakImg,
                                    width: 54.w,
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 5.w,
                        ),
                        GradientText(
                          text: context.l10n.streak_number(
                              timelineModelItem.streakNumber.toString()),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xff3217C3).withOpacity(0.7),
                              Color(0xffFF4B4B)
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: circularBold,
                            height: 1.1,
                            color: const Color(0xFFA1A1A1),
                          ),
                        )
                      ],
                    ),
              GestureDetector(
                onTap: () {
                  openDraggableBottomSheet(context: context, index: index);
                },
                child: Container(
                  width: 222.w,
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 12.h, bottom: 16.h),
                  decoration: BoxDecoration(
                      color: Color(0xffE5DED6).withOpacity(0.34),
                      borderRadius: BorderRadius.circular(13.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: TextAutoSize(
                              "📅 ${timelineModelItem.dayDuration}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: nicotrackBlack1,
                              ),
                            ),
                          ),
                          Icon(
                            FeatherIcons.arrowUpRight,
                            color: nicotrackBlack1,
                            size: 18.w,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.w,
                      ),
                      TextAutoSize(
                        context.l10n.what_happens_to_body,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: circularMedium,
                          height: 1.1,
                          color: const Color(0xFFFF611D),
                        ),
                      ),
                      SizedBox(
                        height: 6.w,
                      ),
                      TextAutoSize(
                        timelineModelItem.whatHappens,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: circularBook,
                          height: 1.2,
                          color: nicotrackBlack1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        _shouldShowProgressLine(index, context)
            ? Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DottedLine(
                        direction: Axis.horizontal,
                        lineLength: double.infinity,
                        lineThickness: 2.0,
                        dashLength: 6.0,
                        dashColor: nicotrackGreen,
                        dashGapLength: 4.0,
                        dashGapColor: Colors.transparent,
                      )
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 0,
              )
      ],
    );
  }

  // Determine if the green progress line should be shown at this timeline index
  bool _shouldShowProgressLine(int index, BuildContext context) {
    int currentIndex = getCurrentTimelineIndex(context);
    // Show the line at the user's current position in the timeline
    return index == currentIndex;
  }

  void setBottomSheetOn() {
    isBottomSheetOn = true;
    update();
  }

  void setBottomSheetOff() {
    isBottomSheetOn = false;
    update();
  }

  void openDraggableBottomSheet(
      {required BuildContext context, required int index}) {
    setBottomSheetOn();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return InfoBottomSheet(withdrawalStage: getTranslatedWithdrawalStages(context)[index]);
      },
    );
  }
}