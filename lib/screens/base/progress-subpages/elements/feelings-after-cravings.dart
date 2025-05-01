import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-scroll-view.dart';
import 'package:nicotrack/screens/elements/textAutoSize.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';

class FeelingsAfterCravings extends StatefulWidget {
  const FeelingsAfterCravings({super.key});

  @override
  State<FeelingsAfterCravings> createState() => _FeelingsAfterCravingsState();
}

class _FeelingsAfterCravingsState extends State<FeelingsAfterCravings> {
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
                    width: 150.w,
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: nicotrackBlack1),
                            children: [
                          TextSpan(
                            text: "⚡ How you ",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFF6D9C32)),
                          ),
                          TextSpan(
                            text: "felt after cravings",
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
                      progressController.cravingFeelingsScrollController,
                  items: feelingsAfterCravingsDummyData, childAspectRatio: 1.9,),
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
        });
  }
}