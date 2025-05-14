import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';

class SetTimeBottomSheet extends StatefulWidget {
  const SetTimeBottomSheet({super.key});

  @override
  State<SetTimeBottomSheet> createState() => _SetTimeBottomSheetState();
}

class _SetTimeBottomSheetState extends State<SetTimeBottomSheet> {
  SettingsController settingsMainController =
  Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        initState: (v) {
          // Ensure the initial index matches the current selection
          final initialIndex1 = settingsMainController.hours
              .indexOf(settingsMainController.selectedHour);
          settingsMainController.hourController =
              FixedExtentScrollController(
                initialItem: initialIndex1 >= 0 ? initialIndex1 : 0,
              );
          settingsMainController.hourController.jumpToItem(initialIndex1);

          final initialIndex2 = settingsMainController.minutes
              .indexOf(settingsMainController.selectedMinute);
          settingsMainController.minuteController= FixedExtentScrollController(
            initialItem: initialIndex2 >= 0 ? initialIndex2 : 0,
          );
          settingsMainController.minuteController.jumpToItem(initialIndex2);
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
                      settingsController.selectedHalf = ' AM';
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
                          Navigator.of(context).pop();
                        },
                        child: TextAutoSize(
                          'Done',
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
                '🕑 Set Time',
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