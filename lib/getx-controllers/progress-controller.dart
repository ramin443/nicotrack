import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/elements/display-cards.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';

class ProgressController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  final ScrollController tabScrollController = ScrollController();

  final List<Map<String, String>> tabs = [
    {"label": "Health", "emoji": "🧠"},
    {"label": "Savings", "emoji": "🪙"},
    {"label": "Milestones", "emoji": "🏆"},
  ];

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
              // Scroll to start if first tab
              if (index == 0) {
                tabScrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }

              // Scroll to end if last tab
              else if (index == tabs.length - 1) {
                tabScrollController.animateTo(
                  tabScrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
              update(); // Rebuild to update active tab
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: index == 0 ? 16.w : 0,
                  right: index == tabs.length - 1 ? 16.w : 0),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Row(
                children: [
                  TextAutoSize(
                    '  ${tabs[index]["label"]!}',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: isSelected ? Colors.white : nicotrackBlack1),
                  ),
                  SizedBox(width: 6.w),
                  TextAutoSize(
                    tabs[index]["emoji"]!,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: nicotrackBlack1),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}