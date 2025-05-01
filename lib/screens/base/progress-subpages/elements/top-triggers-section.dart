import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/4x4-alt-scroll-view.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/dummy-data-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../elements/textAutoSize.dart';

class TopTriggersSection extends StatefulWidget {
  const TopTriggersSection({super.key});

  @override
  State<TopTriggersSection> createState() => _TopTriggersSectionState();
}

class _TopTriggersSectionState extends State<TopTriggersSection> {
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
                            text: "📈 Top ",
                          ),
                          TextSpan(
                            text: "triggers",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: const Color(0xFFFF611D)),
                          ),
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              FourxFourAltScrollView(
                scrollController:
                    progressController.topTriggersScrollController,
                items: whenSmokeCravingStrikesDummyData,
                childAspectRatio: 2.6,
              ),
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