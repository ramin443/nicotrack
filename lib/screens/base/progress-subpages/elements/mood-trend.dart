import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';

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
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: nicotrackBlack1),
                          children: [
                        TextSpan(
                          text: "🌤️️ Mood ",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: Color(0xffFF9900)),
                        ),
                        TextSpan(
                          text: "trend",
                        ),
                      ])),
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