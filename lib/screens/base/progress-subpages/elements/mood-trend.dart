import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';

class MoodTrendRow extends StatefulWidget {
  const MoodTrendRow({super.key});

  @override
  State<MoodTrendRow> createState() => _MoodTrendRowState();
}

class _MoodTrendRowState extends State<MoodTrendRow> {
  final progressMainController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        initState: (v) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            progressMainController.moodHistoryScrollController.jumpTo(
              progressMainController
                  .moodHistoryScrollController.position.maxScrollExtent,
              // duration: Duration(milliseconds: 2000),
              // curve: Curves.easeOut,
            );
          });
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
                              fontFamily: circularMedium,
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
              progressController.moodHistoryRow(),
            ],
          );
        });
  }
}