import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';

class FinancialGoalsBottomSheet extends StatefulWidget {
  const FinancialGoalsBottomSheet({super.key});

  @override
  State<FinancialGoalsBottomSheet> createState() =>
      _FinancialGoalsBottomSheetState();
}

class _FinancialGoalsBottomSheetState extends State<FinancialGoalsBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
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
                        settingsController.selectedFinGoalDollar = 150;
                        settingsController.selectedFinGoalCent = 25;
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
                            if (settingsController.isFinancialGoalFormValid()) {
                              settingsController.addNewFinancialGoal();
                              Navigator.of(context).pop();
                            }
                          },
                          child: TextAutoSize(
                            context.l10n.done,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBook,
                              color:
                                  settingsController.isFinancialGoalFormValid()
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
                Expanded(
                    child: settingsController.financialGoalTextFields(context)),
                SizedBox(
                  height: 24.w,
                ),
              ],
            ),
          ));
    });
  }
}