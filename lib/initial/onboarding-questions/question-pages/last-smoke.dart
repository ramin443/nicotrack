import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';
import 'package:get/get.dart';

class LastSmoked extends StatefulWidget {
  const LastSmoked({super.key});

  @override
  State<LastSmoked> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<LastSmoked> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 26.h,
        ),
        SizedBox(
          width: 340.w,
          child: TextAutoSize(
            "When was the last time you smoked a 🚬 cigarette?",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2,
                fontSize: 24.sp,
                fontFamily: circularMedium,
                color: nicotrackBlack1),
          ),
        ),
        Spacer(),
        Builder(builder: (context) {
          return

            SizedBox(
            height: 240.h,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                // Handle the selected date
              },
            ),
          );
        }),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
