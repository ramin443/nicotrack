import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nicotrack/constants/dummy-data-constants.dart';
import 'package:nicotrack/getx-controllers/progress-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/1x2-scroll-view.dart';
import '../../../../constants/color-constants.dart';
import '../../../../constants/font-constants.dart';

class AllBadgesSection extends StatefulWidget {
  const AllBadgesSection({super.key});

  @override
  State<AllBadgesSection> createState() => _AllBadgesSectionState();
}

class _AllBadgesSectionState extends State<AllBadgesSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProgressController>(
        init: ProgressController(),
        builder: (progressController) {
          return Column(
            children: [
              SizedBox(
                height: 18.h,
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
                            text: "🪙  Earned Badges",
                          ),
                        ])),
                  ),
                ],
              ),
              SizedBox(
                height: 18.h,
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
                                text: "📆  Next Milestones",
                              ),
                            ])),
                  ),
                ],
              ),
            ],
          );
        });
  }
}