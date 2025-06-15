import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/progress-controller.dart';
import '../../../elements/textAutoSize.dart';

class ProgressFinancialGoalsBottomSheet extends StatefulWidget {
  const ProgressFinancialGoalsBottomSheet({super.key});

  @override
  State<ProgressFinancialGoalsBottomSheet> createState() => _ProgressFinancialGoalsBottomSheetState();
}

class _ProgressFinancialGoalsBottomSheetState extends State<ProgressFinancialGoalsBottomSheet> {
  ProgressController progressMainController = Get.find<ProgressController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        builder: (progressController) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            child: Column(
              children: [
                SizedBox(
                  height: 18.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4.8.w,
                      width: 52.w,
                      decoration: BoxDecoration(
                          color: nicotrackBlack1,
                          borderRadius: BorderRadius.circular(18.r)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        progressController.selectedFinGoalDollar1 = 150;
                        progressController.selectedFinGoalCent1 = 25;
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                            color: nicotrackOrange.withOpacity(0.2),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            size: 20.w,
                            color: nicotrackOrange,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (progressController.isFinancialGoalFormValid1()) {
                              progressController.addNewFinancialGoal1();
                              Navigator.of(context).pop();
                            }
                          },
                          child: TextAutoSize(
                            'Done',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBook,
                              color: progressController.isFinancialGoalFormValid1()
                                  ? nicotracklightBlue 
                                  : nicotracklightBlue.withOpacity(0.4),
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.w,
                ),

                SizedBox(
                  height: 15.w,
                ),

                Expanded(child: progressController.financialGoalTextFields1(context)),
                SizedBox(
                  height: 24.w,
                ),
              ],
            ),
          );
        });
  }
}