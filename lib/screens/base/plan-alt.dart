import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/plan-controller.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../../constants/quick-function-constants.dart';
import '../elements/sliver-header-delegate.dart';
import '../elements/textAutoSize.dart';

class PlanAlt extends StatefulWidget {
  const PlanAlt({super.key});

  @override
  State<PlanAlt> createState() => _PlanAltState();
}

class _PlanAltState extends State<PlanAlt> {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y').format(DateTime.now());
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                    child: CustomScrollView(
                  controller: planController.scrollController,
                  slivers: [
                    // Bottom padding
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                      ),
                    ),
                    // Third section with sticky header
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: SliverHeaderDelegate(
                        minHeight: getDynamicPlanHeader(context),
                        maxHeight: getDynamicPlanHeader(context),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextAutoSize(
                                    "Today • $todayDate",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: circularBook,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        planBtnBg,
                                        width: 240.w,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            coffeeEmoji,
                                            width: 52.w,
                                          ),
                                          SizedBox(
                                            width: 16.w,
                                          ),
                                          SizedBox(
                                            width: 120.w,
                                            child: TextAutoSize(
                                              "Personalized Quit Routine",
                                              style: TextStyle(
                                                  fontSize: 19.sp,
                                                  fontFamily: circularBold,
                                                  height: 1.1,
                                                  color: nicotrackBlack1),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 10.h,
                            width: 1.w,
                            decoration: BoxDecoration(color: nicotrackBlack1),
                          ),
                          Container(
                            width: 206.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 14.h),
                            decoration: BoxDecoration(
                                color: nicotrackBlack1,
                                borderRadius: BorderRadius.circular(26.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  instantQuitEmoji,
                                  width: 24.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                TextAutoSize(
                                  "Instant Quit Plan",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: circularMedium,
                                      height: 1.1,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FeatherIcons.repeat,
                                weight: 14.sp,
                                color: const Color(0xFFA1A1A1),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              TextAutoSize(
                                "Change Plan",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: circularBook,
                                  height: 1.1,
                                  color: const Color(0xFFA1A1A1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              planController.timelineTab('Timeline', 0),
                              SizedBox(width: 20.w),
                              planController.timelineTab('Stage', 1),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 24.h),
                              planController.withdrawalTimeline(context),
                              SizedBox(height: 24.h),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )),
                planController.isBottomSheetOn
                    ? GestureDetector(
                        onTap: () {
                          planController.setBottomSheetOff();
                        },
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(color: Colors.black54),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      )
              ],
            ),
          );
        });
  }
}