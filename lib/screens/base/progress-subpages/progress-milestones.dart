import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/all-badges-section.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/feelings-after-cravings.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/health-improvements-trend.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/mood-trend.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/symptoms-healed-from.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/things-to-avoid-craving.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/top-triggers-section.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/upcoming-body-trends.dart';
class ProgressMilestones extends StatefulWidget {
  const ProgressMilestones({super.key});

  @override
  State<ProgressMilestones> createState() => _ProgressMilestonesState();
}

class _ProgressMilestonesState extends State<ProgressMilestones> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MoodTrendRow(),
              SizedBox(
                height: 34.h,
              ),
              TopTriggersSection(),
              SizedBox(
                height: 34.h,
              ),
              AllBadgesSection()
            ],
          );
        }
    );
  }
}