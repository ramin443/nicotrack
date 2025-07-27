import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class MoodCravings extends StatefulWidget {
  const MoodCravings({super.key});

  @override
  State<MoodCravings> createState() => _MoodCravingsState();
}

class _MoodCravingsState extends State<MoodCravings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodController>(
        init: MoodController(),
        builder: (moodController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.h,
              ),
              SizedBox(
                width: 227.w,
                child: TextAutoSize(
                  context.l10n.mood_any_cravings_today,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              Spacer(),
              moodController.anyCravingsTodayGrid(context),
              Spacer(),
              Spacer(),
              Spacer(),
            ],
          );
        });
  }
}