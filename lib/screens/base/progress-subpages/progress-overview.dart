import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/feelings-after-cravings.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-in-overview.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/financial-goals-section.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/health-improvements-trend.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/mood-trend.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/symptoms-healed-from.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/things-to-avoid-craving.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/top-triggers-section.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/upcoming-body-trends.dart';
import 'package:nicotrack/extensions/app_localizations_extension.dart';
class ProgressOverview extends StatefulWidget {
  final bool isUserPremium;
  
  const ProgressOverview({super.key, required this.isUserPremium});

  @override
  State<ProgressOverview> createState() => _ProgressOverviewState();
}

class _ProgressOverviewState extends State<ProgressOverview> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
      builder: (progressController) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            progressController.mainDisplayCards(context),
            SizedBox(
              height: 34.w,
            ),
            MoodTrendRow(),
            SizedBox(
              height: 34.w,
            ),
            TopTriggersSection(),
            SizedBox(
              height: 34.w,
            ),
            SymptomsHealedFrom(),
            SizedBox(
              height: 34.w,
            ),
            FinancialGoalsInOverview(showPercent: true, percent: progressController.getAverageFinancialGoalsCompletionPercentage(), isUserPremium: widget.isUserPremium),
            SizedBox(
              height: 34.w,
            ),
            HealthImprovementTrend(scrollController: progressController.healthScrollViewController,
            ),
            SizedBox(
              height: 34.w,
            ),
            UpcomingHealthTrend(scrollController: progressController.upcominghealthscrollController,),
            SizedBox(
              height: 34.w,
            ),
            FeelingsAfterCravings(),
            SizedBox(
              height: 34.w,
            ),
            ThingsToAvoidCraving(),
            SizedBox(
              height: 80.w,
            ),
          ],
        );
      }
    );
  }
}