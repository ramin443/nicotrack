import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/constants/quick-function-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/3x-grid-view.dart';
import 'package:nicotrack/utility-functions/home-grid-calculations.dart';
import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';
import '../../../../models/award-model/award-model.dart';
import '../../../../extensions/app_localizations_extension.dart';

class AllBadgesSection extends StatefulWidget {
  const AllBadgesSection({super.key});

  @override
  State<AllBadgesSection> createState() => _AllBadgesSectionState();
}

class _AllBadgesSectionState extends State<AllBadgesSection> {
  
  List<AwardModel> _getEarnedBadges() {
    int currentDays = getDaysSinceLastSmoked(DateTime.now());
    return allAwards.where((badge) => badge.day <= currentDays).toList();
  }
  
  List<AwardModel> _getNextMilestones() {
    int currentDays = getDaysSinceLastSmoked(DateTime.now());
    return allAwards.where((badge) => badge.day > currentDays).take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final earnedBadges = _getEarnedBadges();
    final nextMilestones = _getNextMilestones();
    final currentDays = getDaysSinceLastSmoked(DateTime.now());
    
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: nicotrackBlack1,
                      borderRadius: BorderRadius.circular(24.r)
                    ),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: Colors.white),
                            children: [
                          TextSpan(
                            text: "🪙  ${context.l10n.earned_badges_title} (${earnedBadges.length})",
                          ),
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              if (earnedBadges.isNotEmpty)
                ThreexGridView(awardsList: earnedBadges,)
              else
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    context.l10n.first_badge_message(allAwards.first.day.toString()),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: circularMedium,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    decoration: BoxDecoration(
                        color: nicotrackBlack1,
                        borderRadius: BorderRadius.circular(24.r)
                    ),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: circularBold,
                                height: 1.1,
                                color: Colors.white),
                            children: [
                              TextSpan(
                                text: "📆  ${context.l10n.next_milestones_title}",
                              ),
                            ])),
                  ),
                ],
              ),
              SizedBox(
                height: 0.w,
              ),
              if (nextMilestones.isNotEmpty)
                ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.saturation, // Removes color = grayscale
                    ),
                    child: ThreexGridView(awardsList: nextMilestones,))
              else
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    context.l10n.all_badges_earned_message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: circularMedium,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                height: 12.h,
              ),
            ],
          );
        });
  }
}