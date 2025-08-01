import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../extensions/app_localizations_extension.dart';

class FinancialGoalsInOverview extends StatefulWidget {
  final bool showPercent;
  final int percent;
  final bool isUserPremium;

  const FinancialGoalsInOverview(
      {super.key, required this.showPercent, required this.percent, required this.isUserPremium});

  @override
  State<FinancialGoalsInOverview> createState() =>
      _FinancialGoalsInOverviewState();
}

class _FinancialGoalsInOverviewState extends State<FinancialGoalsInOverview> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
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
                            text: context.l10n.financial_goals_title,
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
                items: progressController.getUserFinancialGoalsAsEmojiTextList(),
                childAspectRatio: 1.25,
                withPercent: widget.showPercent,
                percent: widget.percent,
                percentList: progressController.getIndividualFinancialGoalsCompletionPercentages(),
                newfinancialGoalAction: () {
                  print("This acvtive here");
                  progressController.showAddFinancialGoalsBottomSheet(context);
                },
                onItemTap: (index) {
                  progressController.showViewEditGoalBottomSheet(context, index);
                },
                isUserPremium: widget.isUserPremium,
              ),
            ],
          );
        });
  }
}