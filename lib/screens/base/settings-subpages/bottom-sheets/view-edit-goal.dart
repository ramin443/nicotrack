import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
import 'package:nicotrack/models/financial-goals-model/financialGoals-model.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';
import 'package:nicotrack/getx-controllers/app-preferences-controller.dart';

class ViewEditGoalBottomSheet extends StatefulWidget {
  final FinancialGoalsModel goal;
  final int goalIndex;

  const ViewEditGoalBottomSheet({
    super.key,
    required this.goal,
    required this.goalIndex,
  });

  @override
  State<ViewEditGoalBottomSheet> createState() =>
      _ViewEditGoalBottomSheetState();
}

class _ViewEditGoalBottomSheetState extends State<ViewEditGoalBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.sp),
        child: Column(
          children: [
            SizedBox(height: 18.w),
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
                Row(children: [
                  GestureDetector(
                    onTap: () {
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
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      _showDeleteConfirmation(context, settingsController);
                    },
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Icon(
                          Icons.delete_outline,
                          size: 20.w,
                          color: nicotrackOrange,
                        ),
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (settingsController.isFinancialGoalFormValid1()) {
                          settingsController
                              .updateFinancialGoal(widget.goalIndex);
                          Navigator.of(context).pop();
                        }
                      },
                      child: TextAutoSize(
                        context.l10n.save,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: circularBook,
                          color: settingsController.isFinancialGoalFormValid1()
                              ? nicotracklightBlue
                              : nicotracklightBlue.withOpacity(0.4),
                          height: 1.1,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25.w),
            _buildEditableGoalFields(context, settingsController),
            SizedBox(height: 24.w),
          ],
        ),
      ));
    });
  }

  Widget _buildEditableGoalFields(
      BuildContext context, SettingsController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.showEmojiPicker1(context);
                  },
                  child: Container(
                    height: 120.w,
                    width: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: Center(
                      child: TextAutoSize(
                        controller.selectedEmoji1,
                        style: TextStyle(
                          fontSize: 64.sp,
                          letterSpacing: 1.92,
                          fontFamily: circularBook,
                          color: nicotrackBlack1,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.showEmojiPicker1(context);
                    },
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: nicotracklightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 18.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 18.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              context.l10n.edit_financial_goal,
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        TextField(
          controller: controller.goalTitleController1,
          cursorColor: nicotrackBlack1,
          onChanged: (value) {
            controller.update(); // Update UI when text changes for validation
          },
          decoration: InputDecoration(
            hintText: 'e.g., Airpods pro ',
            hintStyle: TextStyle(
              fontSize: 24.sp,
              fontFamily: circularBold,
              color: Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none, // removes outline
            ),
          ),
          style: TextStyle(
            fontSize: 24.sp,
            fontFamily: circularBold,
            color: nicotrackBlack1,
            height: 1.1,
          ),
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 30.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextAutoSize(
              context.l10n.set_the_price,
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1.92,
                fontFamily: circularBook,
                color: nicotrackBlack1,
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.w,),
        GestureDetector(
          onTap: () {
            controller.showEditGoalPriceBottomSheet1(context);
          },
          child: TextAutoSize(
            '${Get.find<AppPreferencesController>().currencySymbol} ${controller.selectedFinGoalDollar1}.${controller.selectedFinGoalCent1.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 48.sp,
              fontFamily: circularBold,
              color: controller.isFinGoalSet
                  ? nicotrackOrange
                  : Color(0xff454545).withOpacity(0.25),
              height: 1.1,
            ),
          ),
        ),
        SizedBox(height: 8.w),
      ],
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Delete Goal',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: circularBold,
              color: nicotrackBlack1,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${widget.goal.goalTitle}"?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: circularBook,
              color: nicotrackBlack1,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteFinancialGoal(widget.goalIndex);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close bottom sheet
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: circularMedium,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}