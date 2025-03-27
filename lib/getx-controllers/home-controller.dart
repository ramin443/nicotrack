import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/color-constants.dart';
import '../constants/font-constants.dart';
import '../constants/image-constants.dart';
import '../screens/elements/textAutoSize.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController( );
  final double itemWidth = 70;
  int selectedDateIndex = 6;
  late List<DateTime> last7Days;
  final int initialIndex = 6;  // Today is the last item

  @override
  void onInit() {
    super.onInit();
    // Wait until after UI builds to scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final offset = scrollController.position.maxScrollExtent;
      if (scrollController.hasClients) {
        scrollController.animateTo(offset, duration: Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      }
    });
    HapticFeedback.mediumImpact();
  }

  void initializeCalendar() {
    // Scroll to today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(selectedDateIndex * itemWidth);
    });
  }

  /// 👇 This is your inline mini calendar widget
  Widget weeklyCalendarView() {
    final today = DateTime.now();
    last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    return SizedBox(
      height: 94.h,
      child: ListView.builder(
        controller: scrollController,
        itemCount: last7Days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final date = last7Days[index];
          final isSelected = index == selectedDateIndex;

          return GestureDetector(
            onTap: () {
              selectedDateIndex = index;
              update();
            },
            child: Container(
              width: itemWidth,
              margin: EdgeInsets.only(
                  right: index == (last7Days.length - 1) ? 24.w : 0,
                  left: index == 0 ? 24.w : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
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
            value: '24',
            label: 'Days since\nlast smoked',
            backgroundColor: const Color(0xFFB0F0A1), // green-ish background
          ),
          statCard(
            emoji: moneyEmoji,
            value: '\$84',
            label: 'Money saved',
          ),
          statCard(
            emoji: heartEmoji,
            value: '2',
            label: 'Days regained\nin life',
          ),
          statCard(
            emoji: clapEmoji,
            value: '48',
            label: 'Cigarettes\nnot smoked',
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
              TextAutoSize(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 33.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
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
    required String value,
    required String label,
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
              TextAutoSize(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 33.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1),
              ),
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
}