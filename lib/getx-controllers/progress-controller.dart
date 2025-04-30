import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/base/progress-subpages/progress-overview.dart';
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
  final ScrollController moodHistoryScrollController = ScrollController();
  final PageController healthScrollViewController = PageController(viewportFraction: 0.75);
  final PageController upcominghealthccrollController = PageController(viewportFraction: 0.75);

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
  List<Widget> allprogressTabs = [ProgressOverview()];

  Widget mainDisplayCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: mainCard(
              emoji: bicepsEmoji,
              value: 24,
              label: 'Days since\nlast smoked',
              backgroundColor: const Color(0xFFB0F0A1), // green-ish background
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
          Expanded(
            flex: 2,
            child: statCard(
              emoji: moneyEmoji,
              value: 84,
              label: 'Money saved',
              isCost: true,
            ),
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

  Widget progressTabContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 600.h, // <-- give it a MINIMUM working height here
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: List.generate(tabs.length, (index) {
              return Center(
                child: Column(
                  children: [
                    ProgressOverview(),
                  ],
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

  List<DateTime> getAprilDates() {
    return List.generate(30, (index) => DateTime(2025, 4, index + 1));
  }

  Widget moodHistoryRow() {
    final List<DateTime> dates = getAprilDates();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: moodHistoryScrollController,
      child: Row(
        children: dates.asMap().entries.map((entry) {
          final int index = entry.key;
          final DateTime date = entry.value;
          final bool isFirst = index == 0;
          final bool isLast = index == dates.length - 1;

          final String formatted = DateFormat("MMMM d, yyyy").format(date);
          final String emoji = emojiDummyData[formatted] ?? "❌";

          return Row(
            children: [
              SizedBox(width: isFirst ? 16.sp : 0),
              Padding(
                padding: EdgeInsets.only(
                  top: 12.sp,
                  bottom: 8.sp,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffF0F0F0), width: 1),
                            bottom:
                                BorderSide(color: Color(0xffF0F0F0), width: 1),
                            left: isFirst
                                ? BorderSide(color: Color(0xffF0F0F0), width: 1)
                                : BorderSide.none,
                            right: isLast
                                ? BorderSide(color: Color(0xffF0F0F0), width: 1)
                                : BorderSide.none,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: isFirst
                                  ? Radius.circular(40.r)
                                  : Radius.circular(0),
                              bottomLeft: isFirst
                                  ? Radius.circular(40.r)
                                  : Radius.circular(0),
                              bottomRight: isLast
                                  ? Radius.circular(40.r)
                                  : Radius.circular(0),
                              topRight: isLast
                                  ? Radius.circular(40.r)
                                  : Radius.circular(0))),
                      child: Column(
                        children: [
                          SizedBox(height: 10.sp),
                          Row(
                            children: [
                              SizedBox(width: isFirst ? 16.sp : 8.sp),
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: Color(0xffE9ECCC),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  emoji,
                                  style: TextStyle(
                                    fontSize: 34.sp,
                                    fontFamily: circularBold,
                                    height: 1.1,
                                    color: nicotrackBlack1,
                                  ),
                                ),
                              ),
                              SizedBox(width: isLast ? 16.sp : 8.sp),
                            ],
                          ),
                          SizedBox(height: 10.sp),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      DateFormat.E().format(date), // e.g. Mon, Tue
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: circularMedium,
                        height: 1.1,
                        color: nicotrackBlack1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isLast ? 16.sp : 0),
            ],
          );
        }).toList(),
      ),
    );
  }
}