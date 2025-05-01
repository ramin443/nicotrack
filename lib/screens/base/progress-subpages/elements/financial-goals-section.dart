import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/1x2-scroll-view.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';
import '4x4-scroll-view.dart';
class FinancialGoalsSection extends StatefulWidget {
  const FinancialGoalsSection({super.key});

  @override
  State<FinancialGoalsSection> createState() => _FinancialGoalsSectionState();
}

class _FinancialGoalsSectionState extends State<FinancialGoalsSection> {
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
                                text: "🥅 Financial Goals",

                              ),
                            ])),
                  ),
                ],
              ),

              SizedBox(
                height: 16.h,
              ),
              OnexTwoScrollView(
                scrollController:
                progressController.financialGoalsScrollController,
                items: financialDummyData, childAspectRatio: 1.38, withPercent: false, percent: 0,),
              SizedBox(
                height: 12.h,
              ),

            ],
          );
        }
    );
  }
}