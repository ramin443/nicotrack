import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class SetWeeklyTimeBottomSheet extends StatefulWidget {
  const SetWeeklyTimeBottomSheet({super.key});

  @override
  State<SetWeeklyTimeBottomSheet> createState() => _SetWeeklyTimeBottomSheetState();
}

class _SetWeeklyTimeBottomSheetState extends State<SetWeeklyTimeBottomSheet> {
  SettingsController settingsMainController =
  Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        initState: (v) {
          // Initialize with saved weekly reminder time, fallback to 6 PM if not set
          int weeklyHour = settingsMainController.currentNotificationsPreferences?.weeklyReminderHour ?? 6;
          int weeklyMinute = settingsMainController.currentNotificationsPreferences?.weeklyReminderMinute ?? 0;
          String weeklyPeriod = settingsMainController.currentNotificationsPreferences?.weeklyReminderPeriod ?? ' PM';
          
          // Set the UI variables to match the saved weekly reminder time
          settingsMainController.selectedWeeklyHour = weeklyHour;
          settingsMainController.selectedWeeklyMinute = weeklyMinute;
          settingsMainController.selectedWeeklyHalf = weeklyPeriod;
          
          // Initialize controllers with saved weekly reminder time
          final initialIndex1 = settingsMainController.hours.indexOf(weeklyHour);
          settingsMainController.weeklyHourController =
              FixedExtentScrollController(
                initialItem: initialIndex1 >= 0 ? initialIndex1 : 0,
              );
          settingsMainController.weeklyHourController.jumpToItem(initialIndex1 >= 0 ? initialIndex1 : 0);

          final initialIndex2 = settingsMainController.minutes.indexOf(weeklyMinute);
          settingsMainController.weeklyMinuteController = FixedExtentScrollController(
            initialItem: initialIndex2 >= 0 ? initialIndex2 : 0,
          );
          settingsMainController.weeklyMinuteController.jumpToItem(initialIndex2 >= 0 ? initialIndex2 : 0);

          final initialIndex3 = settingsMainController.halves.indexOf(weeklyPeriod);
          settingsMainController.weeklyAmPmController = FixedExtentScrollController(
            initialItem: initialIndex3 >= 0 ? initialIndex3 : 0,
          );
          settingsMainController.weeklyAmPmController.jumpToItem(initialIndex3 >= 0 ? initialIndex3 : 0);
        },
        builder: (settingsController) {
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
                        settingsController.selectedWeeklyHalf = ' AM';
                        settingsController.selectedWeeklyHour = 8;
                        settingsController.selectedWeeklyMinute = 0;
                        Navigator.of(context).pop();

                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: nicotrackOrange.withOpacity(0.2),
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(Icons.close_rounded,
                          size: 20.w,
                          color: nicotrackOrange,),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            settingsController.updateWeeklyReminderPreferences();
                            Navigator.of(context).pop();
                          },
                          child: TextAutoSize(
                            context.l10n.done,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: circularBook,
                              color: nicotracklightBlue,
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w,)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.w,
                ),
                TextAutoSize(
                  context.l10n.set_weekly_reminder_time,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
                Expanded(child: settingsController.setWeeklyTimePicker()),
                SizedBox(
                  height: 24.w,
                ),
              ],
            ),
          );
        });
  }
}