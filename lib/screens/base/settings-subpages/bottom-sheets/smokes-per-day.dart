import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/color-constants.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

import '../../../../constants/font-constants.dart';
import '../../../../getx-controllers/settings-controller.dart';
import '../../../elements/textAutoSize.dart';

class SmokesPerDayBottomSheet extends StatefulWidget {
  const SmokesPerDayBottomSheet({super.key});

  @override
  State<SmokesPerDayBottomSheet> createState() => _SmokesPerDayBottomSheetState();
}

class _SmokesPerDayBottomSheetState extends State<SmokesPerDayBottomSheet> {
  SettingsController settingsMainController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        initState: (v) {
          // Ensure the initial index matches the current selection
          final initialIndex1 = settingsMainController.smokesPerDay
              .indexOf(settingsMainController.selectedFreq);
          settingsMainController.smokesPerDayController = FixedExtentScrollController(
            initialItem: initialIndex1 >= 0 ? initialIndex1 : 0,
          );
          settingsMainController.smokesPerDayController.jumpToItem(initialIndex1);
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
                        settingsController.selectedFreq = 4;
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
                            settingsController.updateCigarettesPerDay();
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
                        SizedBox(
                          width: 4.w,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.w,
                ),
                TextAutoSize(
                  context.l10n.cigarettes_per_day,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: circularBold,
                    color: nicotrackBlack1,
                    height: 1.1,
                  ),
                ),
                Expanded(child: settingsController.setCigsPerDay()),
                SizedBox(
                  height: 24.w,
                ),
              ],
            ),
          );
        });
  }
}