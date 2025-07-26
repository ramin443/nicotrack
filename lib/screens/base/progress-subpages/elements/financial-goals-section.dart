import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../extensions/app_localizations_extension.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import 'package:nicotrack/screens/elements/linear-progress-bar.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';
import '4x4-scroll-view.dart';

class FinancialGoalsSection extends StatefulWidget {
  final bool isUserPremium;
  
  const FinancialGoalsSection({super.key, required this.isUserPremium});

  @override
  State<FinancialGoalsSection> createState() => _FinancialGoalsSectionState();
}

class _FinancialGoalsSectionState extends State<FinancialGoalsSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        builder: (progressController) {
          DateTime now = DateTime.now();
          double moneySaved = getMoneySaved(now);
          var userGoals = progressController.userFinancialGoals;
                
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
                      withPercent: false,
                      percent: 0,
                      newfinancialGoalAction: () {
                        progressController.showAddFinancialGoalsBottomSheet(context);
                      },
                      onItemTap: (index) {
                        progressController.showViewEditGoalBottomSheet(context, index);
                      },
                      isUserPremium: widget.isUserPremium,
                    ),
                    if (userGoals.isNotEmpty) SizedBox(height: 24.h),
                    if (userGoals.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Column(
                          children: [
                            for (int index = 0; index < userGoals.length; index++)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 300.w,child:
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontFamily: circularMedium,
                                                  height: 1.1,
                                                  color: nicotrackBlack1),
                                              children: [
                                                TextSpan(
                                                  text:
                                                  "${userGoals[index].emoji} ${userGoals[index].goalTitle} ",
                                                ),
                                                TextSpan(
                                                  text: "${((moneySaved / userGoals[index].cost) * 100).clamp(0, 100).toInt()}% ",
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontFamily: circularBold,
                                                      height: 1.1,
                                                      color: Color(0xff6D9C32)),
                                                ),
                                                TextSpan(
                                                  text: context.l10n.goal_completed,
                                                ),
                                              ])),)

                                    ],
                                  ),
                                  SizedBox(
                                    height: 9.w,
                                  ),
                                  StyledProgressBar(
                                    progress: (moneySaved / userGoals[index].cost).clamp(0.0, 1.0),
                                  ),
                                  SizedBox(
                                    height: 20.w,
                                  ),
                                ],
                              )
                          ],
                        ),
                      )
                  ],
                );
              });
  }
}