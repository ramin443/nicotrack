import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import 'package:nicotrack/getx-controllers/mood-controller.dart';

import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';

class SmokedToday extends StatefulWidget {
  const SmokedToday({super.key});

  @override
  State<SmokedToday> createState() => _SmokedTodayState();
}

class _SmokedTodayState extends State<SmokedToday> {
  final didYouSmokeTodayMainController = Get.find<DidYouSmokeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        initState: (v){
          final initialIndex = didYouSmokeTodayMainController.packNumbers
              .indexOf(didYouSmokeTodayMainController.selectedNumber1);
          didYouSmokeTodayMainController.listWheelController =
              FixedExtentScrollController(
                initialItem: initialIndex >= 0 ? initialIndex : 0,
              );
          didYouSmokeTodayMainController.listWheelController
              .jumpToItem(initialIndex);
        },
        builder: (didYouSmokeController) {
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
                  "Did you\nsmoke 🚬 today?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 26.sp,
                      fontFamily: circularMedium,
                      color: nicotrackBlack1),
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                child: TextAutoSize(
                  "Honesty is the best policy 😉",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.15,
                      fontSize: 13.sp,
                      fontFamily: circularBook,
                      color: Color(0xff979797)),
                ),
              ),
              SizedBox(
                height: 75.h,
              ),
              didYouSmokeController.smokedTodaySelection(),
              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}