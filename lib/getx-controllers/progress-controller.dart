import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-cravings.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-health.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-milestones.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-overview.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-savings.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../constants/color-constants.dart';
import '../constants/dummy-data-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';

class ProgressController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  final ScrollController tabScrollController = ScrollController();
  final PageController healthScrollViewController =
      PageController(viewportFraction: 0.75);
  final PageController upcominghealthscrollController =
      PageController(viewportFraction: 0.75);
  final PageController cravingFeelingsScrollController =
      PageController(viewportFraction: 0.75);
  final PageController avoidCravingsScrollController =
      PageController(viewportFraction: 0.75);
  final PageController topTriggersScrollController =
      PageController(viewportFraction: 0.75);
  final PageController symptomsHealedScrollController =
      PageController(viewportFraction: 0.75);
  final PageController financialGoalsScrollController =
      PageController(viewportFraction: 0.75);
  final ScrollController dailyStreakScrollController = ScrollController();

  final List<Map<String, String>> tabs = [
    {"label": "Overview", "emoji": "📋"},
    {"label": "Health", "emoji": "🧠"},
    {"label": "Savings", "emoji": "🪙"},
    {"label": "Cravings", "emoji": "🤤"},
    {"label": "Milestones", "emoji": "🏆"},
  ];

  final List<Map<String, String>> moodHistory = [
    {"date": "April 27, 2025", "emoji": "📋"},
    {"date": "April 26, 2025", "emoji": "🧠"},
    {"date": "April 24, 2025", "emoji": "🪙"},
    {"date": "April 23, 2025", "emoji": "🤤"},
    {"date": "April 22, 2025", "emoji": "🏆"},
  ];
  List<Widget> allprogressTabs = [
    ProgressOverview(),
    ProgressHealth(),
    ProgressSavings(),
    ProgressCravings(),
    ProgressMilestones()
  ];

  Widget mainDisplayCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
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
            value: 24,
            label: 'Days since\nlast smoked',
            backgroundColor: const Color(0xFFB0F0A1),
            isCost: false, // green-ish background
          ),
          statCard(
            emoji: moneyEmoji,
            value: 84,
            label: 'Money saved',
            isCost: true,
          ),
        ],
      ),
    );
  }

  Widget savingsDisplayCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
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
            emoji: moneyEmoji,
            value: 24,
            label: 'Money saved',
            backgroundColor: const Color(0xFFB0F0A1),
            isCost: true, // green-ish background
          ),
          statCard(
            emoji: bicepsEmoji,
            value: 84,
            label: 'Days since\nlast smoked',
            isCost: false,
          ),
        ],
      ),
    );
  }

  Widget progressTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: tabScrollController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final isSelected = tabController.index == index;
          return GestureDetector(
            onTap: () {
              tabController.animateTo(index);

              // Scroll to the tapped tab's position
              final tabWidth =
                  140.w; // Approximate tab width (adjust if needed)
              double targetOffset = (tabWidth + 8.w) * index - 34.w;

              if (targetOffset < 0) targetOffset = 0;
              if (targetOffset > tabScrollController.position.maxScrollExtent) {
                targetOffset = tabScrollController.position.maxScrollExtent;
              }

              tabScrollController.animateTo(
                targetOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );

              update(); // Rebuild to update active tab
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: index == 0 ? 16.w : 0,
                  right: index == tabs.length - 1 ? 16.w : 0),
              padding: EdgeInsets.only(
                  right: 16.w, left: 8.w, top: 16.h, bottom: 16.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Row(
                children: [
                  TextAutoSize(
                    '  ${tabs[index]["emoji"]!}',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: isSelected ? Colors.white : nicotrackBlack1),
                  ),
                  SizedBox(width: 6.w),
                  TextAutoSize(
                    tabs[index]["label"]!,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: isSelected ? Colors.white : nicotrackBlack1),
                  ),
                  SizedBox(width: 2.w),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget progressTabContent2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        allprogressTabs[tabController.index], // Only show current tab content
      ],
    );
  }

  Widget progressTabContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: MediaQuery.of(context)
              .size
              .height, // or a custom calculated height
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: List.generate(tabs.length, (index) {
              return Center(
                child: Column(
                  children: [allprogressTabs[index]],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget moodTrend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: Color(0xffFF9900)),
                    children: [
                  TextSpan(text: '🌤️️ Mood '),
                  TextSpan(
                      text: 'trend',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: nicotrackBlack1,
                      )),
                ])),
          ],
        ),
      ],
    );
  }
}