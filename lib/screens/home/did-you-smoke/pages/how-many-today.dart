import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/did-you-smoke-controller.dart';
import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../elements/textAutoSize.dart';

class HowManyToday extends StatefulWidget {
  const HowManyToday({super.key});

  @override
  State<HowManyToday> createState() => _HowManyTodayState();
}

class _HowManyTodayState extends State<HowManyToday> {
  final didYouSmokeMainController = Get.find<DidYouSmokeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DidYouSmokeController>(
        init: DidYouSmokeController(),
        initState: (v) {
          // Ensure the initial index matches the current selection
          final initialIndex = didYouSmokeMainController.packNumbers
              .indexOf(didYouSmokeMainController.selectedNumber1);
          didYouSmokeMainController.listWheelController =
              FixedExtentScrollController(
            initialItem: initialIndex >= 0 ? initialIndex : 0,
          );
          didYouSmokeMainController.listWheelController
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
                width: 247.w,
                child: TextAutoSize(
                  "How many 🚬 cigarettes did you consume today?",
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
              didYouSmokeController.cigarreteFrequencySlider(),
              SizedBox(
                height: 54.h,
              ),
            ],
          );
        });
  }
}