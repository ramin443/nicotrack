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
import '../elements/textAutoSize.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
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
          return Scaffold(
           key: planController.scaffoldState,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
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

                    Column(
                      children: [
                        SizedBox(height: 18.w),
                        planController.withdrawalTimeline(context),
                        SizedBox(height: 34.w),
                        AllBadgesSection(),
                        SizedBox(height: 24.w),
                      ],
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: _showFloatingButton
                ? FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor: nicotrackBlack1,
                    elevation: 8,
                    child: Icon(
                      Icons.abc,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  )
                : null,
          );
        });
  }
}