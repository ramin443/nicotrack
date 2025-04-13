import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';

class WhatTriggered extends StatefulWidget {
  const WhatTriggered({super.key});

  @override
  State<WhatTriggered> createState() => _WhatTriggeredState();
}

class _WhatTriggeredState extends State<WhatTriggered> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        builder: (didYouSmokeController) {
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
                  "What triggered you smoking 🚬 today?",
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
              didYouSmokeController.whatTriggeredGrid(),

              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}