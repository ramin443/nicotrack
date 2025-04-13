import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../elements/textAutoSize.dart';

class MoodReflectTimes extends StatefulWidget {
  const MoodReflectTimes({super.key});

  @override
  State<MoodReflectTimes> createState() => _MoodReflectTimesState();
}

class _MoodReflectTimesState extends State<MoodReflectTimes> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodController>(
      init: MoodController(),
      builder: (moodController) {
        return ListView(
          padding: EdgeInsets.only(
            top: 18.h,

            bottom: MediaQuery.of(context).viewInsets.bottom + 45.h,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: SizedBox(
                width: 207.w,
                child: TextAutoSize(
                  "Want to reflect a bit more 🗒️?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.15,
                    fontSize: 26.sp,
                    fontFamily: circularMedium,
                    color: nicotrackBlack1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 26.h),
            moodController.quickNoteTextField(),
          ],
        );
      },
    );
  }
}