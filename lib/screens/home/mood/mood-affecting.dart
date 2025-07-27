import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../elements/textAutoSize.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';

class MoodAffecting extends StatefulWidget {
  const MoodAffecting({super.key});

  @override
  State<MoodAffecting> createState() => _MoodAffectingState();
}

class _MoodAffectingState extends State<MoodAffecting> {
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
                width: 257.w,
                child: TextAutoSize(
                  context.l10n.mood_whats_affecting,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              moodController.moodAffectingGrid(context),
              SizedBox(
                height: 94.h,
              ),
            ],
          );
        });
  }
}