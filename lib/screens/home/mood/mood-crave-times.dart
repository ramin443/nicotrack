import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../elements/textAutoSize.dart';

class MoodCraveTimes extends StatefulWidget {
  const MoodCraveTimes({super.key});

  @override
  State<MoodCraveTimes> createState() => _MoodCraveTimesState();
}

class _MoodCraveTimesState extends State<MoodCraveTimes> {
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
                width: 247.w,
                child: TextAutoSize(
                  "When did you crave cigarettes 😥 today?",
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
              moodController.craveTimesGrid(),
              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}