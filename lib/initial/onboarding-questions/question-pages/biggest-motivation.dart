import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/color-constants.dart';
import '../../../constants/font-constants.dart';
import '../../../constants/image-constants.dart';
import '../../../screens/elements/textAutoSize.dart';

class BiggestMotivation extends StatefulWidget {
  const BiggestMotivation({super.key});

  @override
  State<BiggestMotivation> createState() => _LastSmokedState();
}

class _LastSmokedState extends State<BiggestMotivation> {
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
            "What is your biggest motivation 💪 for quitting?",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2,
                fontSize: 24.sp,
                fontFamily: circularMedium,
                color: nicotrackBlack1),
          ),
        ),

        SizedBox(
          height: 18.h,
        ),

      ],
    );
  }
}

