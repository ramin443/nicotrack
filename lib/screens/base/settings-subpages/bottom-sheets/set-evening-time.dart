import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class SetEveningTimeBottomSheet extends StatefulWidget {
  const SetEveningTimeBottomSheet({super.key});

  @override
  State<SetEveningTimeBottomSheet> createState() => _SetEveningTimeBottomSheetState();
}

class _SetEveningTimeBottomSheetState extends State<SetEveningTimeBottomSheet> {
  SettingsController settingsMainController =
  Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        initState: (v) {
          // Initialize with default evening time (8:00 PM)
          int eveningHour = 8; // 8 PM in 12-hour format
          int eveningMinute = 0;
          String eveningPeriod = ' PM';
          
          // Set the UI variables to match the evening time
          settingsMainController.selectedHour = eveningHour;
          settingsMainController.selectedMinute = eveningMinute;
          settingsMainController.selectedHalf = eveningPeriod;
          
          // Initialize controllers with evening time
          final initialIndex1 = settingsMainController.hours.indexOf(eveningHour);
          settingsMainController.hourController =
              FixedExtentScrollController(
                initialItem: initialIndex1 >= 0 ? initialIndex1 : 0,
              );
          settingsMainController.hourController.jumpToItem(initialIndex1 >= 0 ? initialIndex1 : 0);

          final initialIndex2 = settingsMainController.minutes.indexOf(eveningMinute);
          settingsMainController.minuteController= FixedExtentScrollController(
            initialItem: initialIndex2 >= 0 ? initialIndex2 : 0,
          );
          settingsMainController.minuteController.jumpToItem(initialIndex2 >= 0 ? initialIndex2 : 0);

          final initialIndex3 = settingsMainController.halves.indexOf(eveningPeriod);
          settingsMainController.amPmController= FixedExtentScrollController(
            initialItem: initialIndex3 >= 0 ? initialIndex3 : 0,
          );
          settingsMainController.amPmController.jumpToItem(initialIndex3 >= 0 ? initialIndex3 : 0);
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
                    onTap: (){
                      settingsController.selectedHalf = ' PM';
                      settingsController.selectedHour = 8;
                      settingsController.selectedMinute = 0;
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
                          settingsController.updateEveningNotificationTime();
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
                "Set Evening Time",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: circularBold,
                  color: nicotrackBlack1,
                  height: 1.1,
                ),
              ),
              Expanded(child: settingsController.setTimePicker()),
              SizedBox(
                height: 24.w,
              ),
            ],
          ),
        );
      }
    );
  }
}