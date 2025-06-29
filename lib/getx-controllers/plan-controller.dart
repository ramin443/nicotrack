import 'package:dotted_line/dotted_line.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';
import 'package:nicotrack/screens/elements/gradient-text.dart';
import 'package:nicotrack/screens/elements/info-bottom-sheet.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';

import '../constants/font-constants.dart';
import '../models/timeline-item-model/timelineItem-model.dart';
import '../screens/elements/textAutoSize.dart';

class PlanController extends GetxController {
  int tabIndex = 0;
  final scaffoldState = GlobalKey<ScaffoldState>();
  bool isBottomSheetOn = false;

  List<TimelineItemModel> timelineItems = [
    TimelineItemModel(
        dayNumber: 0,
        streakNumber: 0,
        dayDuration: "First 24 Hours",
        whatHappens: "💨 CO exits • 🧠 Oxygen normalizes • 💓 Heart rate drops",
        streakImg: ballImg),
    TimelineItemModel(
        dayNumber: 1,
        streakNumber: 1,
        dayDuration: "Day 2",
        whatHappens: "🧪 Nicotine drops 90% • 👃 Taste improves • 😰 Withdrawal starts",
        streakImg: ballImg),
    TimelineItemModel(
        dayNumber: 3,
        streakNumber: 3,
        dayDuration: "Day 3-4",
        whatHappens: "🚫 Nicotine eliminated • 📈 Peak cravings • 🧠 Brain adjusts",
        streakImg: ballrollImg),
    TimelineItemModel(
        dayNumber: 5,
        streakNumber: 5,
        dayDuration: "Day 5-7",
        whatHappens: "🫁 Cilia moving • 🤧 Toxin removal • 💪 Peak withdrawal",
        streakImg: baseballImg),
    TimelineItemModel(
        dayNumber: 8,
        streakNumber: 8,
        dayDuration: "Week 1-2",
        whatHappens: "🩸 Circulation +15% • 😮‍💨 Easier breathing • 🧠 Fog clears",
        streakImg: capImg),
    TimelineItemModel(
        dayNumber: 14,
        streakNumber: 14,
        dayDuration: "2 Weeks",
        whatHappens: "🫁 Lung function +5% • 🏃 Exercise easier • 😊 Mood stabilizes",
        streakImg: medalImg),
    TimelineItemModel(
        dayNumber: 18,
        streakNumber: 18,
        dayDuration: "2.5 Weeks",
        whatHappens: "🫁 Rapid cilia regrowth • 🌬️ Self-cleaning starts • 💪 Stamina up",
        streakImg: teddyImg),
    TimelineItemModel(
        dayNumber: 21,
        streakNumber: 21,
        dayDuration: "3 Weeks",
        whatHappens: "🧠 Receptors -50% • 😌 Less anxiety • 🔋 Energy boost",
        streakImg: celebrateImg),
    TimelineItemModel(
        dayNumber: 28,
        streakNumber: 28,
        dayDuration: "4 Weeks",
        whatHappens: "🫁 Capacity +15% • 💓 BP stabilizes • 🎯 Cravings fade",
        streakImg: crownImg),
    TimelineItemModel(
        dayNumber: 35,
        streakNumber: 35,
        dayDuration: "5 Weeks",
        whatHappens: "🌬️ Infection risk drops • 🏃‍♂️ Cardio +20% • 😴 Better sleep",
        streakImg: chocolateImg),
    TimelineItemModel(
        dayNumber: 42,
        streakNumber: 42,
        dayDuration: "6 Weeks",
        whatHappens: "👃 Sinuses clear • 💪 Strength up • ⚡ Energy doubles",
        streakImg: trophyImg),
    TimelineItemModel(
        dayNumber: 50,
        streakNumber: 50,
        dayDuration: "7 Weeks",
        whatHappens: "🫁 Function +25% • 🧠 Sharp focus • 🔥 Optimal metabolism",
        streakImg: vacayImg),
    TimelineItemModel(
        dayNumber: 56,
        streakNumber: 56,
        dayDuration: "8 Weeks",
        whatHappens: "🩸 Peak oxygen delivery • 💓 Heart +30% • 😊 Mood optimal",
        streakImg: magicbowlImg),
    TimelineItemModel(
        dayNumber: 65,
        streakNumber: 65,
        dayDuration: "9-10 Weeks",
        whatHappens: "🏃 Athletic baseline • 🛡️ Strong immunity • 🌟 Better skin",
        streakImg: no1Img),
    TimelineItemModel(
        dayNumber: 75,
        streakNumber: 75,
        dayDuration: "10-11 Weeks",
        whatHappens: "🫁 Cilia 70% restored • 😮‍💨 No breathlessness • 🧠 Peak clarity",
        streakImg: hatImg),
    TimelineItemModel(
        dayNumber: 84,
        streakNumber: 84,
        dayDuration: "12 Weeks",
        whatHappens: "💪 Peak muscle oxygen • 🌬️ Full lung cleaning • 🎯 Optimal cognition",
        streakImg: dartarrowImg),
    TimelineItemModel(
        dayNumber: 95,
        streakNumber: 95,
        dayDuration: "13-14 Weeks",
        whatHappens: "🫁 Function +40% • ❤️ Low heart risk • ⚡ Sustained energy",
        streakImg: kiteImg),
    TimelineItemModel(
        dayNumber: 105,
        streakNumber: 105,
        dayDuration: "15 Weeks",
        whatHappens: "🛡️ Optimal white cells • 🏃‍♀️ Fast recovery • 😴 Deep sleep",
        streakImg: golfImg),
    TimelineItemModel(
        dayNumber: 112,
        streakNumber: 112,
        dayDuration: "16 Weeks",
        whatHappens: "🌬️ Athletic breathing • 🧠 Full neurotransmitters • 💎 Peak repair",
        streakImg: pinataImg),
    TimelineItemModel(
        dayNumber: 126,
        streakNumber: 126,
        dayDuration: "18 Weeks",
        whatHappens: "🫁 Capacity +45% • 🔋 Optimal mitochondria • 🌟 Visible transformation",
        streakImg: hat2Img),
    TimelineItemModel(
        dayNumber: 140,
        streakNumber: 140,
        dayDuration: "20 Weeks",
        whatHappens: "💓 Peak heart efficiency • 🏃 Max VO2 • 🧬 DNA repair boost",
        streakImg: ballrollImg),
    TimelineItemModel(
        dayNumber: 154,
        streakNumber: 154,
        dayDuration: "22 Weeks",
        whatHappens: "🫁 Cilia 90% normal • 🛡️ Max infection resistance • ⚡ No crashes",
        streakImg: hatImg),
    TimelineItemModel(
        dayNumber: 168,
        streakNumber: 168,
        dayDuration: "24 Weeks",
        whatHappens: "🫁 Function +50% • 🌬️ Non-smoker breathing • 🏆 Full transformation",
        streakImg: badge1Emoji),
    TimelineItemModel(
        dayNumber: 180,
        streakNumber: 180,
        dayDuration: "6 Months",
        whatHappens: "✨ Complete restoration • 💪 Peak performance • 🎉 Major milestone!",
        streakImg: dartarrowImg),
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
  int getCurrentTimelineIndex() {
    int daysPassed = getCurrentDaysPassed();
    
    for (int i = timelineItems.length - 1; i >= 0; i--) {
      if (daysPassed >= timelineItems[i].dayNumber) {
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
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            for (int index = 0; index < timelineItems.length; index++)
              Column(
                children: [
                  timelineRow(
                      timelineModelItem: timelineItems[index], index: index, context: context),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 20.w,
                                width: 2.w,
                                decoration: BoxDecoration(
                                  color: index == timelineItems.length - 1
                                      ? Colors.transparent
                                      : Color(0xffF6F4F1),
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(22.w),
                                          bottomLeft: Radius.circular(22.w))
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
        )

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
        );
  }

  Widget timelineRow(
      {required  BuildContext context,required int index, required TimelineItemModel timelineModelItem}) {
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
                              "Start",
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
                          "Day ${timelineModelItem.dayNumber}",
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
                        Stack(
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
                          text: "Streak ${timelineModelItem.streakNumber}",
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
                onTap: (){
                  openDraggableBottomSheet( context: context, index: index);
                  // showBottomSheet(
                  //   enableDrag: true,
                  //   backgroundColor: Colors.transparent,
                  //    builder:  (context){
                  //     return InfoBottomSheet();
                  //     }, context: context
                  // );
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextAutoSize(
                            "📅 ${timelineModelItem.dayDuration}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: nicotrackBlack1,
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
                        "What happens to your body",
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
        _shouldShowProgressLine(index)
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
  bool _shouldShowProgressLine(int index) {
    int currentIndex = getCurrentTimelineIndex();
    // Show the line at the user's current position in the timeline
    return index == currentIndex;
  }

  void setBottomSheetOn(){
    isBottomSheetOn = true;
    update();
  }
  void setBottomSheetOff(){
    isBottomSheetOn = false;
    update();
  }
  void openDraggableBottomSheet({required BuildContext context,required int index}){
    setBottomSheetOn();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return InfoBottomSheet(withdrawalStage: withdrawalStages[index]);
      },
    );
  }
}