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
import '../../extensions/app_localizations_extension.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;
  bool _showCurrentPositionButton = false;
  double _currentTimelinePosition = 0.0;

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
    
    // Check if user is viewing their current timeline position
    _checkCurrentPositionVisibility();
  }
  
  void _checkCurrentPositionVisibility() {
    try {
      final planController = Get.find<PlanController>();
      final currentIndex = planController.getCurrentTimelineIndex(context);
      
      // Calculate approximate position of current timeline item
      // Timeline starts after header content (approximately 520px) + (index * item height)
      // Each timeline item is roughly 200px tall including spacing
      final headerHeight = 520.0;
      final itemHeight = 200.0;
      final targetPosition = headerHeight + (currentIndex * itemHeight);
      
      _currentTimelinePosition = targetPosition;
      
      // Check if current position is visible on screen
      final viewportHeight = MediaQuery.of(context).size.height;
      final currentScrollOffset = _scrollController.offset;
      
      // Add buffer zone to make button appear earlier
      final bufferZone = 100.0;
      final isCurrentPositionVisible = (targetPosition >= (currentScrollOffset - bufferZone)) && 
                                       (targetPosition <= (currentScrollOffset + viewportHeight + bufferZone));
      
      // Always show the button when scrolled past the header
      final shouldShowButton = currentScrollOffset > 300.0 && !isCurrentPositionVisible;
      
      if (shouldShowButton != _showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = shouldShowButton;
        });
      }
    } catch (e) {
      // If controller not found, show button when scrolled down
      final shouldShowButton = _scrollController.offset > 300.0;
      if (shouldShowButton != _showCurrentPositionButton) {
        setState(() {
          _showCurrentPositionButton = shouldShowButton;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  void _scrollToCurrentPosition() {
    _scrollController.animateTo(
      _currentTimelinePosition,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('MMMM d, y', Localizations.localeOf(context).languageCode).format(DateTime.now());
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
                          context.l10n.plan_today(todayDate),
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
                                context.l10n.personalized_quit_routine,
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
                            context.l10n.instant_quit_plan,
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
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.r),
                                  topRight: Radius.circular(40.r),
                                ),
                              ),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: 36.w,
                                            width: 36.w,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffFF611D).withOpacity(0.20)),
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Color(0xffFF611D),
                                                size: 18.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 24.w,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    // Header Section
                                    Container(
                                      width: 86.w,
                                      height: 86.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: nicotrackLightGreen.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "📋",
                                          style: TextStyle(fontSize: 48.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      context.l10n.your_quit_journey,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontFamily: circularBold,
                                        color: nicotrackBlack1,
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: nicotrackGreen.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        context.l10n.personalized_plan,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontFamily: circularMedium,
                                          color: nicotrackGreen,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    // Main Content
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                                      padding: EdgeInsets.all(20.w),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF8F8F8),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Column(
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontFamily: circularBook,
                                                height: 1.4,
                                                color: nicotrackBlack1,
                                              ),
                                              children: [
                                                TextSpan(text: context.l10n.plan_description),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 48.w,
                                                    height: 48.w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: nicotrackOrange.withOpacity(0.15),
                                                    ),
                                                    child: Center(
                                                      child: Text("🎯", style: TextStyle(fontSize: 24.sp)),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    context.l10n.track_progress,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: circularMedium,
                                                      color: nicotrackBlack1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 48.w,
                                                    height: 48.w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: nicotracklightBlue.withOpacity(0.15),
                                                    ),
                                                    child: Center(
                                                      child: Text("🏆", style: TextStyle(fontSize: 24.sp)),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    context.l10n.earn_badges,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: circularMedium,
                                                      color: nicotrackBlack1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 48.w,
                                                    height: 48.w,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: nicotrackPurple.withOpacity(0.15),
                                                    ),
                                                    child: Center(
                                                      child: Text("💪", style: TextStyle(fontSize: 24.sp)),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    context.l10n.stay_strong,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: circularMedium,
                                                      color: nicotrackBlack1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    // Disclaimer Section
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: Color(0xFFE0E0E0),
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 32.w,
                                            height: 32.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: nicotrackLightGreen.withOpacity(0.3),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "💡",
                                                style: TextStyle(fontSize: 16.sp),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context.l10n.important_note,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: circularBold,
                                                    color: nicotrackBlack1,
                                                    height: 1.1,
                                                  ),
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  context.l10n.timeline_disclaimer,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: circularBook,
                                                    height: 1.3,
                                                    color: nicotrackBlack1.withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 54.w),
                                  ],
                                ),
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
                            context.l10n.info_button,
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
                        SizedBox(height: 0),
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
            floatingActionButton: (_showFloatingButton || _showCurrentPositionButton)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current position button (appears when not viewing current timeline position)
                      if (_showCurrentPositionButton)
                        FloatingActionButton(
                          onPressed: _scrollToCurrentPosition,
                          backgroundColor: nicotrackPurple,
                          elevation: 8,
                          heroTag: "currentPosition",
                          child: Icon(
                            Icons.my_location,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                      // Add spacing only if both buttons are showing
                      if (_showCurrentPositionButton && _showFloatingButton)
                        SizedBox(height: 12.h),
                      // Scroll to top button (appears when scrolled down)
                      if (_showFloatingButton)
                        FloatingActionButton(
                          onPressed: _scrollToTop,
                          backgroundColor: nicotrackBlack1,
                          elevation: 8,
                          heroTag: "scrollToTop",
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white,
                            size: 28.w,
                          ),
                        ),
                    ],
                  )
                : null,
          );
        });
  }
}