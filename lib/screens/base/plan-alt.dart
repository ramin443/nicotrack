import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/plan-controller.dart';
import 'package:nicotrack/screens/base/progress-subpages/elements/all-badges-section.dart';

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
  bool _showFloatingButton = false;

  void _scrollListener(ScrollController controller) {
    if (controller.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (controller.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y').format(DateTime.now());
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
          // Add scroll listener
          planController.scrollController.removeListener(() => _scrollListener(planController.scrollController));
          planController.scrollController.addListener(() => _scrollListener(planController.scrollController));
          
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
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                enableDrag: false,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40.r),
                                        topRight: Radius.circular(40.r),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20.h),
                                        Container(
                                          width: 52.w,
                                          height: 5.w,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(24.r),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          "Plan Information",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontFamily: circularBold,
                                            color: nicotrackBlack1,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                                          child: Text(
                                            "This is your personalized quit plan designed to help you successfully quit smoking. Follow the timeline to understand what to expect during your journey.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: circularBook,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FeatherIcons.info,
                                  weight: 14.sp,
                                  color: const Color(0xFFA1A1A1),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                TextAutoSize(
                                  "Info",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: circularBook,
                                    height: 1.1,
                                    color: const Color(0xFFA1A1A1),
                                  ),
                                ),
                              ],
                            ),
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
                              SizedBox(height: 34.h),
                              AllBadgesSection(),
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
            floatingActionButton: _showFloatingButton
                ? FloatingActionButton(
                    onPressed: () => _scrollToTop(planController.scrollController),
                    backgroundColor: nicotrackBlack1,
                    elevation: 8,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  )
                : null,
          );
        });
  }
}