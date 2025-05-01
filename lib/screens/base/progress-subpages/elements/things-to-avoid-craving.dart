import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';
import '4x4-scroll-view.dart';
class ThingsToAvoidCraving extends StatefulWidget {
  const ThingsToAvoidCraving({super.key});

  @override
  State<ThingsToAvoidCraving> createState() => _ThingsToAvoidCravingState();
}

class _ThingsToAvoidCravingState extends State<ThingsToAvoidCraving> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 18.w,
                ),
                SizedBox(
                  width: 170.w,
                  child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBold,
                              height: 1.1,
                              color: nicotrackBlack1),
                          children: [
                            TextSpan(
                              text: "🛡️ What you would do to ",

                            ),
                            TextSpan(
                              text: "avoid cravings?",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: circularBold,
                                  height: 1.1,
                                  color: const Color(0xFFC79C42)),
                            ),
                          ])),
                ),
              ],
            ),

            SizedBox(
              height: 16.h,
            ),
            FourxFourScrollView(
                scrollController:
                progressController.avoidCravingsScrollController,
                items: whatToDoToAvoidSmokingDummyData, childAspectRatio: 1.65,),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              width: 180.w,
              child: TextAutoSize(
                "We will keep updating this as you log your daily tasks",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: circularBook,
                    height: 1.1,
                    color: const Color(0xFFC8C8C8)),
              ),
            )
          ],
        );
      }
    );
  }
}