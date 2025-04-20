import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nicotrack/constants/image-constants.dart';
import 'package:nicotrack/getx-controllers/plan-controller.dart';

import '../../constants/color-constants.dart';
import '../../constants/font-constants.dart';
import '../elements/textAutoSize.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y').format(DateTime.now());
    return GetBuilder<PlanController>(
        init: PlanController(),
        builder: (planController) {
          return Scaffold(
           key: planController.scaffoldState,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          planBtnBg,
                          width: 240.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
          );
        });
  }
}