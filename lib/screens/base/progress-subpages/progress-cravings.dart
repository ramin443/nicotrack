import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/feelings-after-cravings.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/things-to-avoid-craving.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/top-triggers-section.dart';

class ProgressCravings extends StatefulWidget {
  const ProgressCravings({super.key});

  @override
  State<ProgressCravings> createState() => _ProgressCravingsState();
}

class _ProgressCravingsState extends State<ProgressCravings> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              TopTriggersSection(),
              SizedBox(
                height: 34.h,
              ),
              FeelingsAfterCravings(),
              SizedBox(
                height: 34.h,
              ),
              ThingsToAvoidCraving(),
              SizedBox(
                height: 34.h,
              ),
            ],
          );
        });
  }
}