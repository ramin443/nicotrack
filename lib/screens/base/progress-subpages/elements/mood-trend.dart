import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../../models/mood-model/mood-model.dart';
import '../../../../extensions/app_localizations_extension.dart';

class MoodTrendRow extends StatefulWidget {
  const MoodTrendRow({super.key});

  @override
  State<MoodTrendRow> createState() => _MoodTrendRowState();
}

class _MoodTrendRowState extends State<MoodTrendRow> {
  final progressMainController = Get.find<ProgressController>();
  bool hasScrolledtoEnd = false;
  final ScrollController moodHistoryScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v) {
          if(!hasScrolledtoEnd){
            WidgetsBinding.instance.addPostFrameCallback((_) {
              moodHistoryScrollController.jumpTo(
                moodHistoryScrollController.position.maxScrollExtent,
                // duration: Duration(milliseconds: 2000),
                // curve: Curves.easeOut,
              );
            });
          }
          hasScrolledtoEnd=true;

          // super.initState();
        },
        builder: (progressController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18.w,
                  ),
                  Text(
                    context.l10n.progress_mood_trend,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: circularBold,
                        height: 1.1,
                        color: nicotrackBlack1),
                  ),
                ],
              ),
              SizedBox(
                width: 12.h,
              ),
              moodHistoryRow(),
            ],
          );
        });
  }
  List<DateTime> getMoodDates() {
    final moodBox = Hive.box<MoodModel>('moodData');
    final today = DateTime.now();
    
    // Get all mood entries
    final moodEntries = moodBox.keys.cast<String>().toList();
    
    if (moodEntries.isEmpty) {
      // No mood data - show last 7 days
      return List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));
    }
    
    // Parse dates from mood entries
    List<DateTime> moodDates = [];
    for (String key in moodEntries) {
      try {
        DateTime date = DateFormat.yMMMd().parse(key);
        moodDates.add(date);
      } catch (e) {
        // Skip invalid date formats
      }
    }
    
    if (moodDates.isEmpty) {
      // If no valid dates found, show last 7 days
      return List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));
    }
    
    // Sort dates
    moodDates.sort();
    
    // Get earliest mood date
    DateTime earliestDate = moodDates.first;
    
    // Calculate days between earliest and today
    int daysDifference = today.difference(earliestDate).inDays;
    
    if (daysDifference < 6) {
      // If less than 7 days of data, show last 7 days
      return List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));
    } else {
      // Show from earliest entry to today
      List<DateTime> dates = [];
      for (int i = 0; i <= daysDifference; i++) {
        dates.add(earliestDate.add(Duration(days: i)));
      }
      return dates;
    }
  }

  String _getLocalizedDayName(BuildContext context, DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return context.l10n.monday.substring(0, 3); // Mon
      case DateTime.tuesday:
        return context.l10n.tuesday.substring(0, 3); // Tue
      case DateTime.wednesday:
        return context.l10n.wednesday.substring(0, 3); // Wed
      case DateTime.thursday:
        return context.l10n.thursday.substring(0, 3); // Thu
      case DateTime.friday:
        return context.l10n.friday.substring(0, 3); // Fri
      case DateTime.saturday:
        return context.l10n.saturday.substring(0, 3); // Sat
      case DateTime.sunday:
        return context.l10n.sunday.substring(0, 3); // Sun
      default:
        return DateFormat.E().format(date); // Fallback
    }
  }

  Widget moodHistoryRow() {
    final List<DateTime> dates = getMoodDates();
    final moodBox = Hive.box<MoodModel>('moodData');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: moodHistoryScrollController,
      child: Row(
        children: dates.asMap().entries.map((entry) {
          final int index = entry.key;
          final DateTime date = entry.value;
          final bool isFirst = index == 0;
          final bool isLast = index == dates.length - 1;

          // Get mood data for this date
          final String dateKey = DateFormat.yMMMd().format(date);
          final MoodModel? moodData = moodBox.get(dateKey);
          
          String emoji = "📭"; // Default to X mark
          
          if (moodData != null && moodData.selfFeeling.isNotEmpty) {
            // Extract emoji from selfFeeling map
            try {
              emoji = moodData.selfFeeling['emoji'] ?? "📭";
            } catch (e) {
              emoji = "📭";
            }
          }

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
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              SizedBox(width: isFirst ? 12.sp : 8.sp),
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: emoji == "📭" ? Colors.redAccent.withOpacity(0.22) : Color(0xffE9ECCC),
                                  shape: BoxShape.circle,
                                ),
                                child: emoji == "📭"
                                  ? Text(
                                      emoji,
                                      style: TextStyle(
                                        fontSize: 26.sp,
                                        fontFamily: circularBold,
                                        height: 1.1,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Image.asset(
                                      emoji,
                                      width: 28.sp,
                                    ),
                              ),
                              SizedBox(width: isLast ? 12.sp : 8.sp),
                            ],
                          ),
                          SizedBox(height: 10.w),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Text(
                      _getLocalizedDayName(context, date),
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