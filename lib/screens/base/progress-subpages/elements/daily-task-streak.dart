import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/screens/elements/gradient-text.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../elements/textAutoSize.dart';

class DailyTaskStreak extends StatefulWidget {
  final ScrollController scrollController;

  const DailyTaskStreak({super.key, required this.scrollController});

  @override
  State<DailyTaskStreak> createState() => _DailyTaskStreakState();
}

class _DailyTaskStreakState extends State<DailyTaskStreak> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          });
        },
        builder: (progressController) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 18.h, right: 16.w, bottom: 20.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: Offset(0, 3),
                        blurRadius: 10),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                                color: nicotrackBlack1, shape: BoxShape.circle),
                            child: TextAutoSize(
                              '🗓️',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontFamily: circularBook,
                                  height: 1.1,
                                  color: Color(0xffA1A1A1)),
                            ),
                          ),
                          SizedBox(
                            width: 11.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextAutoSize(
                                'Daily task streak',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: circularBold,
                                    height: 1.1,
                                    color: nicotrackBlack1),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              TextAutoSize(
                                '4 out of 7 this week',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: circularBook,
                                    height: 1.1,
                                    color: Color(0xffA1A1A1)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 215.w,
                        height: 66.h,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                  itemCount: 7,
                                  controller:
                                      progressController.dailyStreakScrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final last7Days = getLast7WeekdayLetters();
                                    bool isCompleted = index.isEven;
                                    final dayLetter = last7Days[index];
                                    return Padding(
                                      padding: EdgeInsets.only(left: 12.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GradientText(
                                              text: dayLetter,
                                              gradient: LinearGradient(
                                                  colors: isCompleted
                                                      ? [
                                                          Color(0xffFF611D)
                                                              .withOpacity(0.64),
                                                          Color(0xffFF4B4B)
                                                        ]
                                                      : [
                                                          Color(0xffA1A1A1),
                                                          Color(0xffA1A1A1)
                                                        ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight),
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: circularBook,
                                                  height: 1.1,
                                                  color: Color(0xffA1A1A1))),
                                          isCompleted
                                              ? Container(
                                                  width: 38.w,
                                                  height: 38.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xffFF611D)
                                                              .withOpacity(0.64),
                                                          Color(0xffFF4B4B)
                                                        ],
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight),
                                                  ),
                                                  child: Icon(
                                                    CupertinoIcons.checkmark_alt,
                                                    color: Colors.white,
                                                    size: 20.w,
                                                  ),
                                                )
                                              : Container(
                                                  width: 38.w,
                                                  height: 38.w,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xffA1A1A1)
                                                          .withOpacity(0.16)),
                                                )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 90.w,
                        width: 90.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xffFF611D).withOpacity(0.64),
                                  Color(0xffFF4B4B)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: Center(
                          child: TextAutoSize(
                            '14',
                            style: TextStyle(
                                fontSize: 48.sp,
                                fontFamily: circularBook,
                                height: 1.1,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  List<String> getLast7WeekdayLetters() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return DateFormat.E().format(day)[0]; // Get first letter like 'M'
    });
  }
}